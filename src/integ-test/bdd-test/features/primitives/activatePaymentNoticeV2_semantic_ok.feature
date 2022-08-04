Feature: semantic checks OK for activatePaymentNoticeV2Request

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
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  # [SEM_APNV2_17]
  Scenario: Check outcome OK on non-existent psp in idempotencyKey
    Given random idempotencyKey having 00088877799 as idPSP in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  # [SEM_APNV2_17.1]
  Scenario: Check outcome OK on non-existent psp in idempotencyKey
    Given random idempotencyKey having 00088877799 as idPSP in activatePaymentNoticeV2
    And noticeNumber with 310$iuv in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  # [SEM_APNV2_18]
  Scenario: Check outcome OK on disabled psp in idempotencyKey
    Given random idempotencyKey having 80000000001 as idPSP in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  # [SEM_APNV2_18.1]
  Scenario: Check outcome OK on disabled psp in idempotencyKey
    Given random idempotencyKey having 80000000001 as idPSP in activatePaymentNoticeV2
    And noticeNumber with 310$iuv in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  # [SEM_APNV2_24]
  Scenario: Check outcome OK if combination psp-channel-pa in denylist
    Given fiscalCode with 77777777777 in activatePaymentNoticeV2
    And idBrokerPSP with 70000000002 in activatePaymentNoticeV2
    And idChannel with 70000000002_01 in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response

  # [SEM_APNV2_24.1]
  Scenario: Check outcome OK if combination psp-channel-pa in denylist
    Given fiscalCode with 77777777777 in activatePaymentNoticeV2
    And idBrokerPSP with 70000000002 in activatePaymentNoticeV2
    And idChannel with 70000000002_01 in activatePaymentNoticeV2
    And noticeNumber with 310$iuv in activatePaymentNoticeV2
    When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response