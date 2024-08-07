Feature: semantic check for sendPaymentOutcomeReq regarding idempotency 1269

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  # Activate Phase
  Scenario: Execute activatePaymentNotice1 request
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
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <expirationTime>15000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And saving activatePaymentNotice request in activatePaymentNotice1

  Scenario: Execute activatePaymentNotice2 request
    Given the Execute activatePaymentNotice1 request scenario executed successfully
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
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <expirationTime>15000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And saving activatePaymentNotice request in activatePaymentNotice2
    And save activatePaymentNotice response in activatePaymentNotice2
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_1 on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_2 on db nodo_online under macro NewMod3
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

@runnable
  # Send payment outcome Phase
  Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice2 request scenario executed successfully
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
      <paymentToken>$activatePaymentNotice2Response.paymentToken</paymentToken>
      <outcome>KO</outcome>
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
    And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_1 on db nodo_online under macro NewMod3
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query idempotency_cache_psp_2 on db nodo_online under macro NewMod3
    And apply new restore initial configurations