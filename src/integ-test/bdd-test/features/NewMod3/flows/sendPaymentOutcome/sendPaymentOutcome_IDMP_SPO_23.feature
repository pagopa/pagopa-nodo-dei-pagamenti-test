Feature: sendPaymentOutcome_IDMP_SPO_23

Background:
    Given systems up

  # Activate Phase
  Scenario: 1. Execute activatePaymentNotice request
    Given nodo-dei-pagamenti has config parameter useIdempotency set to true
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
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>$1noticeNumber</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And saving activatePaymentNotice request in activatePaymentNotice1

  # Send payment outcome Phase 1
  Scenario: 2. Execute sendPaymentOutcome request
    Given the 1. Execute activatePaymentNotice request scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>$activatePaymentNotice.idempotencyKey</idempotencyKey>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      <outcome>OK</outcome>
      <details>
      <paymentMethod>creditCard</paymentMethod>
      <paymentChannel>app</paymentChannel>
      <fee>2.00</fee>
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>John Doe</fullName>
      <streetName>street</streetName>
      <civicNumber>12</civicNumber>
      <postalCode>89020</postalCode>
      <city>city</city>
      <stateProvinceRegion>MI</stateProvinceRegion>
      <country>IT</country>
      <e-mail>john.doe@test.it</e-mail>
      </payer>
      <applicationDate>2021-10-01</applicationDate>
      <transferDate>2021-10-02</transferDate>
      </details>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    And saving sendPaymentOutcome request in sendPaymentOutcome1
    Then check outcome is OK of sendPaymentOutcome response

Scenario: Execute second activatePaymentNotice
    Given the 2. Execute sendPaymentOutcome request scenario executed successfully
    And generate 2 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XMl activatePaymentNotice
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
      <amount>10.00</amount>
      <paymentNote>responseFull</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
    """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And saving activatePaymentNotice request in activatePaymentNotice2

Scenario: Execute second sendPaymentOutcome
    Given the Execute second activatePaymentNotice scenario executed successfully
    And idempotencyKey with $activatePaymentNotice.idempotencyKey in sendPaymentOutcome
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And saving sendPaymentOutcome request in sendPaymentOutcome2
    And wait 5 seconds for expiration
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_1 on db nodo_online under macro NewMod3
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_2 on db nodo_online under macro NewMod3
    And update through the query idempotency_update with date 1minuteLater under macro update_query on db nodo_online
    And replace sendPaymentOutcome content with $sendPaymentOutcome1 content
    And update through the query idempotency_update with date 1minuteLater under macro update_query on db nodo_online
    
    
Scenario: Trigger idempotencyCacheClean
    Given the Execute second sendPaymentOutcome scenario executed successfully
    When job idempotencyCacheClean triggered after 75 seconds
    And wait 20 seconds for expiration
    Then verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_1 on db nodo_online under macro NewMod3
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_2 on db nodo_online under macro NewMod3

@runnable @dependentread @lazy
Scenario: execute third sendPaymentOutcome [IDMP_SPO_23]
    Given the Trigger idempotencyCacheClean scenario executed successfully
    And saving sendPaymentOutcome2 request in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
    And restore initial configurations