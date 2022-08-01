Feature: semantic check for activatePaymentNotice regarding idempotency

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter useIdempotency set to true
    And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
    And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false

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
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1
    And saving activatePaymentNotice request in activatePaymentNotice1

  Scenario: Execute activatePaymentNotice1 request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And PSP waits 70 seconds for expiration
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>70000000001</idPSP>
      <idBrokerPSP>70000000001</idBrokerPSP>
      <idChannel>70000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>$activatePaymentNotice.idempotencyKey</idempotencyKey>
      <qrCode>
      <fiscalCode>66666666666</fiscalCode>
      <noticeNumber>$activatePaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice2
    And saving activatePaymentNotice request in activatePaymentNotice2

  #DB check
  Scenario: Execute activatePaymentNotice request
    Given the Execute activatePaymentNotice1 request scenario executed successfully
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken1 on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice1.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken1 on db nodo_online under macro NewMod3
     And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken2 on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken2 on db nodo_online under macro NewMod3