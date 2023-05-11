Feature: semantic check for activatePaymentNoticeReq regarding idempotency - not useIdempotency

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
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <expirationTime>120000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And nodo-dei-pagamenti has config parameter useIdempotency set to false

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And wait 1 seconds for expiration

  # Activate Phase 2 [SEM_APNR_19.1]
  @runnable
  Scenario: Execute again activatePaymentNotice request with same idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
    And random noticeNumber in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And restore initial configurations

  # [SEM_APNR_20.1]
  @runnable
  Scenario: Execute again activatePaymentNotice request with different fiscalCode
    Given the Execute activatePaymentNotice request scenario executed successfully
    And fiscalCode with #creditor_institution_code_secondary# in activatePaymentNotice
    And expirationTime with 60000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And nodo-dei-pagamenti has config parameter useIdempotency set to false
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_act on db nodo_online under macro NewMod3
    And restore initial configurations