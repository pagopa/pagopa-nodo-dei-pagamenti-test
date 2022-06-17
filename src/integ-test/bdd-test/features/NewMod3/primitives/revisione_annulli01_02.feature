Feature: process tests for reviione-poller annulli01_02

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:verifyPaymentNoticeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      </nod:verifyPaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  #activate phase
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>2000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # test execution
  Scenario: Execution test
    Given the nodoInviaRPT request scenario executed successfully
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200


    #db check
    Scenario: DB check [REV_ANN_01]
    Given the Execute nodoInoltraEsitoPagamentoCarta request scenario executed successfully
    Then checks the value INSERTED of the record at column STATUS of POSITION_STATUS retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.notice_number of the record at column notice_number of the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro NewMod3

    #db check
    Scenario: DB check [REV_ANN_02]
    Given the Execute nodoInoltraEsitoPagamentoCarta request scenario executed successfully
    Then checks the value CANCELLED of the record at column STATUS of POSITION_STATUS retrived by the query position_payment on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.notice_number of the record at column notice_number of the table POSITION_STATUS_SNAPSHOT retrived by the query position_payment on db nodo_online under macro NewMod3
