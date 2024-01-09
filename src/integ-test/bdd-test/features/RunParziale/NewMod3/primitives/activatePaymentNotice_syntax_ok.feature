Feature: Syntax checks OK for activatePaymentNoticeReq 1527

  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
  
  @ALL
  Scenario: Check valid URL in WSDL namespace
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @ALL
  Scenario Outline: Check OK response on missing optional fields idempotencyKey - SIN_APNR_18
    Given <elem> with <value> in activatePaymentNotice
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Examples:
      | elem           | value | soapUI test |
      | idempotencyKey | None  | SIN_APNR_18 |
      | expirationTime | None  | SIN_APNR_35 |
      | dueDate        | None  | SIN_APNR_44 |
      | paymentNote    | None  | SIN_APNR_47 |

