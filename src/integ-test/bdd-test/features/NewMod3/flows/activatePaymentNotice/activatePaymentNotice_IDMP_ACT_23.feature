Feature: semantic check for activatePaymentNotice regarding idempotency

  Background:
    Given systems up

  Scenario: Execute activatePaymentNotice request
    Given nodo-dei-pagamenti has config parameter useIdempotency set to true
    And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr#
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
      <expirationTime>6000</expirationTime>
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
  
  Scenario: Execute activatePaymentNotice2 request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And generate 2 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
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
      <noticeNumber>$2noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>6000</expirationTime>
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
  @runnable
  Scenario: DB check + idempotencyCacheClean
    Given the Execute activatePaymentNotice2 request scenario executed successfully
    When job idempotencyCacheClean triggered after 15 seconds
    And wait 30 seconds for expiration
    Then verify the HTTP status code of idempotencyCacheClean response is 200
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken1 on db nodo_online under macro NewMod3
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_paymentToken2 on db nodo_online under macro NewMod3
    And restore initial configurations