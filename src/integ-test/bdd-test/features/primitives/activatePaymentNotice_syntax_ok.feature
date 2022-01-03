Feature:  syntax checks OK for activatePaymentNoticeReq

  Background:
    Given systems up
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
                  <expirationTime>120000</expirationTime>
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """


  Scenario: Check valid URL in WSDL namespace
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  Scenario Outline: Check OK response on missing optional fields idempotencyKey - SIN_APNR_18
    Given <elem> with <value> in activatePaymentNotice
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Examples:
      | elem           | value | soapUI test |
      | idempotencyKey | None  | SIN_APNR_18 |
      | expirationTime | None  | SIN_APNR_35 |
      | amount         | None  | SIN_APNR_39 |
      | dueDate        | None  | SIN_APNR_44 |
      | paymentNote    | None  | SIN_APNR_47 |
      # TODO: amount test fail: fix it

