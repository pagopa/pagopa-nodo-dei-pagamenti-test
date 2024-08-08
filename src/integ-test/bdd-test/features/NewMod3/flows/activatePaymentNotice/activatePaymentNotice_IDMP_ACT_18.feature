Feature: semantic check for activatePaymentNotice regarding idempotency 1049

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter useIdempotency set to true
    And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000


  Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice
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
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1

  #DB check
  Scenario: DB check1
    Given the Execute activatePaymentNotice request scenario executed successfully
    And check datetime plus number of date default_idempotency_key_validity_minutes of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value activatePaymentNotice of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act on db nodo_online under macro NewMod3

  @runnable
  Scenario: Execute activatePaymentNotice1 request
    Given the DB check1 scenario executed successfully
    And wait 62 seconds for expiration
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
      <idempotencyKey>$activatePaymentNotice.idempotencyKey</idempotencyKey>
      <qrCode>
      <fiscalCode>$activatePaymentNotice.fiscalCode</fiscalCode>
      <noticeNumber>$activatePaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response

  #DB check
    And check datetime plus number of date 0 of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value activatePaymentNotice of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_act_orderby on db nodo_online under macro NewMod3
    And apply new restore initial configurations