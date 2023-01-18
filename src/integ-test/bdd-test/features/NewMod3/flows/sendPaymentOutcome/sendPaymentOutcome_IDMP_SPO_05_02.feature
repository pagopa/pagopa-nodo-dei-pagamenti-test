Feature: semantic check for sendPaymentOutcomeReq regarding idempotency 

  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <expirationTime>15000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send payment outcome Phase
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      <outcome>KO</outcome>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And save sendPaymentOutcome response in sendPaymentOutcome1

  #Send payment outcome Phase 1
  Scenario: Execute sendPaymentOutcome request 1
    Given the Execute sendPaymentOutcome request scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>$sendPaymentOutcome.idempotencyKey</idempotencyKey>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      <outcome>KO</outcome>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And save sendPaymentOutcome response in sendPaymentOutcome2

@runnable
  Scenario: DB check
    Given the Execute sendPaymentOutcome request 1 scenario executed successfully
    Then sendPaymentOutcome1 response is equal to sendPaymentOutcome2 response
    And checks the value PAYING,FAILED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_pay on db nodo_online under macro NewMod3
    And checks the value FAILED_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_pay on db nodo_online under macro NewMod3
    And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
    And verify 1 record for the table POSITION_PAYMENT retrived by the query payment_status_pay on db nodo_online under macro NewMod3
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
