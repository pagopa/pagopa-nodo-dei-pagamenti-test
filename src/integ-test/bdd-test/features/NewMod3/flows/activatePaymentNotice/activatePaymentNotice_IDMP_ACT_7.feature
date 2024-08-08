Feature: semantic check for activatePaymentNotice regarding idempotency 1073

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter useIdempotency set to true
    And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 1800000
    And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false

  Scenario: Execute activatePaymentNotice request
    Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr# 
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
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>$1noticeNumber</noticeNumber>
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

@runnable
  Scenario: Execute activatePaymentNotice1 request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And wait 70 seconds for expiration
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
      <fiscalCode>44444444444</fiscalCode>
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
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken1 on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice1.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken1 on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken2 on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken2 on db nodo_online under macro NewMod3
    And apply new restore initial configurations