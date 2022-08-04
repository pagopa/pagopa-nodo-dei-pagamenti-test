Feature: syntax checks OK for activatePaymentNoticeV2Request

  Background:
    Given systems up
    And initial XML activatePaymentNoticeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeV2Request>
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
      </nod:activatePaymentNoticeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: Check valid URL in WSDL namespace
    When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  Scenario Outline: Check OK response on missing optional fields
    Given <elem> with <value> in activatePaymentNoticeV2
    When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    Examples:
      | elem           | value | soapUI test |
      | idempotencyKey | None  | SIN_APNV2_18 |
      | expirationTime | None  | SIN_APNV2_35 |
      | dueDate        | None  | SIN_APNV2_44 |
      | paymentNote    | None  | SIN_APNV2_47 |

  Scenario Outline: Check OK response on missing optional fields (stazione con versione primitive 2)
    Given noticeNumber with 310$iuv in activatePaymentNoticeV2
    And <elem> with <value> in activatePaymentNoticeV2
    When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    Examples:
      | elem           | value | soapUI test   |
      | idempotencyKey | None  | SIN_APNV2_18.1 |
      | expirationTime | None  | SIN_APNV2_35.1 |
      | dueDate        | None  | SIN_APNV2_44.1 |
      | paymentNote    | None  | SIN_APNV2_47.1 |