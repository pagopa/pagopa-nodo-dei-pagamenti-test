Feature: semantic check for activatePaymentNoticeReq regarding idempotency - use idempotency 1084

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
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>120000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Activate Phase 2 [SEM_APNR_19]
  @runnable
  Scenario: Execute again activatePaymentNotice request before idempotencyKey expires
    Given the Execute activatePaymentNotice request scenario executed successfully
    And call the paymentToken of activatePaymentNotice response as target
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And verify the paymentToken of the activatePaymentNotice response is equals to target
    And apply new restore initial configurations