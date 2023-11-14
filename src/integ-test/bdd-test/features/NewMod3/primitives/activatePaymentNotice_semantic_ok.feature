Feature: Semantic checks OK for activatePaymentNotice

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
            <!--Optional:-->
            <expirationTime>12345</expirationTime>
            <!--Optional:-->
            <amount>10.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>responseFull</paymentNote>
          </nod:activatePaymentNoticeReq>
        </soapenv:Body>
      </soapenv:Envelope>
      """

  @runnable
  Scenario: Check valid URL in WSDL namespace
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @runnable
  # idPsp in idempotencyKey (idempotencyKey: <idPSp>+"_"+<RANDOM STRING>) not in db  [SEM_APNR_17]
  Scenario: Check outcome OK on non-existent psp in idempotencyKey
    Given random idempotencyKey having 00088877799 as idPSP in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @runnable
  # idPsp in idempotencyKey (idempotencyKey: <idPsp>+"_"+<RANDOM STRING>) with field ENABLED = N  [SEM_APNR_18]
  Scenario: Check outcome OK on disabled psp in idempotencyKey
    Given random idempotencyKey having 80000000001 as idPSP in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
