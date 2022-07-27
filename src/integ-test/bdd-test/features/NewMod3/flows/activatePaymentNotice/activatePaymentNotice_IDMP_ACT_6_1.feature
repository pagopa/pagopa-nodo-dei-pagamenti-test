Feature: semantic check for activatePaymentNotice regarding idempotency

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  Scenario: Execute activatePaymentNotice1 request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>60000000001</idPSP>
      <idBrokerPSP>60000000001</idBrokerPSP>
      <idChannel>60000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>$activatePaymentNotice.idempotencyKey</idempotencyKey>
      <qrCode>
      <fiscalCode>$activatePaymentNotice.fiscalCode</fiscalCode>
      <noticeNumber>$activatePaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response

  #DB check
  Scenario: Execute activatePaymentNotice request
    Given the Execute activatePaymentNotice1 request scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_pay on db nodo_online under macro NewMod3
    And checks the value PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_pay on db nodo_online under macro NewMod3
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query payment_status_pay on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query payment_status_pay on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_KEY retrived by the query idempotency_key on db nodo_online under macro NewMod3






