Feature: semantic check for sendPaymentOutcomeReq regarding idempotency

  Background:
    Given systems up

  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    Given  initial XML activatePaymentNotice
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
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And nodo-dei-pagamenti has config parameter useIdempotency set to true
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
  
  @runnable @dependentread @dependentwrite
  # Send payment outcome Phase
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
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
      <idempotencyKey>#idempotency_key#</idempotencyKey>
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
    Then check outcome is OK of sendPaymentOutcome response
    And check datetime plus number of date 2 of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value sendPaymentOutcome of the record at column PRIMITIVA of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column TOKEN of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column HASH_REQUEST of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column RESPONSE of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache on db nodo_online under macro NewMod3
    And restore initial configurations