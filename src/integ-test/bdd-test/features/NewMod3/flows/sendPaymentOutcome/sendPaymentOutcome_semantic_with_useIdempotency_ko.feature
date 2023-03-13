Feature: semantic check for sendPaymentOutcomeReq regarding idempotency - use idempotency

  Background:
    Given systems up

  # Activate Phase
  Scenario: 1. Execute activatePaymentNotice request
    Given nodo-dei-pagamenti has config parameter useIdempotency set to true
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
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And call the paymentToken of activatePaymentNotice response as paymentTokenPhase1

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

  @runnable
  # Send payment outcome Phase 2 [IDMP_SPO_16.1]
  Scenario: 3. Execute again sendPaymentOutcome request with different idPSP-idBrokerPSP-idChannel before idempotencyKey expires
    Given the 2. Execute sendPaymentOutcome request scenario executed successfully
    And idPSP with 40000000001 in sendPaymentOutcome
    And idBrokerPSP with 40000000001 in sendPaymentOutcome
    And idChannel with 40000000001_01 in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response

  @runnable
  # Send payment outcome Phase 2
  Scenario Outline: 4. Execute again sendPaymentOutcome request with same idempotencyKey before it expires
    Given the 2. Execute sendPaymentOutcome request scenario executed successfully
    And <elem> with <value> in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcome response
    Examples:
      | elem          | value | soapUI test   |
      | paymentMethod | cash  | IDMP_SPO_16.2 |
      | streetName    | road  | IDMP_SPO_16.3 |

  @runnable
  # Send payment outcome Phase 2 [IDMP_SPO_17]
  Scenario: 5. Execute sendPaymentOutcome request after idempotencyKey has expired
    Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
    And the 2. Execute sendPaymentOutcome request scenario executed successfully
    # settare idempotencykey validity
    And update through the query idempotency_update with date 1minuteLater under macro update_query on db nodo_online
    And wait 70 seconds for expiration
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
    And restore initial configurations

  # @runnable
  #   # Send payment outcome Phase 2 - different paymentMethod [IDMP_SPO_24]
  #   Scenario: 8. Execute sendPaymentOutcome request with different paymentMethod, after waiting 130 seconds
  #     Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
  #     And the 2. Execute sendPaymentOutcome request scenario executed successfully
  #     And idempotencyKey valid for 60 seconds
  #     And paymentMethod with cash in sendPaymentOutcome
  #     And PSP waits 180 seconds for expiration
  #     When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
  #     Then check outcome is KO of sendPaymentOutcome response
  #     And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response

  # Send payment outcome Phase 1 - no idempotencyKey [IDMP_SPO_26]
  Scenario: 9. Execute sendPaymentOutcome request without idempotencyKey
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
    And idempotencyKey with None in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @runnable
  # Send payment outcome Phase 2 [IDMP_SPO_26]
  Scenario: 10. Execute again the same sendPaymentOutcome request
    Given the 9. Execute sendPaymentOutcome request without idempotencyKey scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response

  @runnable
  # Send payment outcome Phase 2 - different idempotencyKey [IDMP_SPO_27]
  Scenario: 11. Execute again the same sendPaymentOutcome request with a different idempotencyKey
    Given the 2. Execute sendPaymentOutcome request scenario executed successfully
    And random idempotencyKey having #psp# as idPSP in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
  #And check description is Esito concorde: {"applicationDate":"$sendPaymentOutcome.applicationDate","fee":$sendPaymentOutcome.fee,"outcome":"$sendPaymentOutcome.outcome","payerEntityUniqueIdentifierValue":"$sendPaymentOutcome.payerEntityUniqueIdentifierValue","paymentChannel":"$sendPaymentOutcome.paymentChannel","paymentMethod":"$sendPaymentOutcome.paymentMethod","paymentToken":"$sendPaymentOutcome.paymentToken","transferDate":"$sendPaymentOutcome.transferDate"} of sendPaymentOutcome response

  # Send payment outcome Phase 1 - outcome KO [IDMP_SPO_28]
  Scenario: 12. Execute sendPaymentOutcome request with outcome KO
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
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @runnable
  # Send payment outcome Phase 2 - different idempotencyKey [IDMP_SPO_28]
  Scenario: 13. Execute again the same sendPaymentOutcome request with outcome KO with a different idempotencyKey
    Given the 12. Execute sendPaymentOutcome request with outcome KO scenario executed successfully
    And random idempotencyKey having #psp# as idPSP in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
    And check description is Esito concorde: {"applicationDate":"$sendPaymentOutcome.applicationDate","fee":$sendPaymentOutcome.fee,"outcome":"$sendPaymentOutcome.outcome","payerEntityUniqueIdentifierValue":"$sendPaymentOutcome.entityUniqueIdentifierValue","paymentChannel":"$sendPaymentOutcome.paymentChannel","paymentMethod":"$sendPaymentOutcome.paymentMethod","paymentToken":"$sendPaymentOutcome.paymentToken","transferDate":"$sendPaymentOutcome.transferDate"} of sendPaymentOutcome response

  @runnable
  # Send payment outcome Phase 2 - different idempotencyKey [IDMP_SPO_29]
  Scenario: 14. Execute again the same sendPaymentOutcome request with a different idempotencyKey
    Given the 2. Execute sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    And random idempotencyKey having #psp# as idPSP in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
  #And check description is Esito discorde: {"applicationDate":"$sendPaymentOutcome.applicationDate","fee":$sendPaymentOutcome.fee,"outcome":"KO","payerEntityUniqueIdentifierValue":"$sendPaymentOutcome.entityUniqueIdentifierValue","paymentChannel":"$sendPaymentOutcome.paymentChannel","paymentMethod":"$sendPaymentOutcome.paymentMethod","paymentToken":"$sendPaymentOutcome.paymentToken","transferDate":"$sendPaymentOutcome.transferDate"} of sendPaymentOutcome response

  # Send payment outcome Phase 1 - outcome KO [IDMP_SPO_30]
  Scenario: 15. Execute sendPaymentOutcome request with outcome KO
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
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @runnable
  # Send payment outcome Phase 2 - different idempotencyKey [IDMP_SPO_30]
  Scenario: 16. Execute again the same sendPaymentOutcome request with outcome OK with a different idempotencyKey
    Given the Execute sendPaymentOutcome request with outcome KO scenario executed successfully
    And outcome with OK in sendPaymentOutcome
    And random idempotencyKey having #psp# as idPSP in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
  #And check description is Esito discorde: {"applicationDate":"$sendPaymentOutcome.applicationDate","fee":$sendPaymentOutcome.fee,"outcome":"KO","payerEntityUniqueIdentifierValue":"$sendPaymentOutcome.entityUniqueIdentifierValue","paymentChannel":"$sendPaymentOutcome.paymentChannel","paymentMethod":"$sendPaymentOutcome.paymentMethod","paymentToken":"$sendPaymentOutcome.paymentToken","transferDate":"$sendPaymentOutcome.transferDate"} of sendPaymentOutcome response

  # Mod3Cancel Phase [IDMP_SPO_31]
  Scenario: 17. Execute mod3Cancel poller
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
      <expirationTime>6000</expirationTime>
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    And save activatePaymentNotice response in activatePaymentNotice1
    And job mod3CancelV2 triggered after 8 seconds
    And wait 10 seconds for expiration
    Then check outcome is OK of activatePaymentNotice response
    And verify the HTTP status code of mod3CancelV2 response is 200

  # Activate Phase 2 [IDMP_SPO_31]
  Scenario: 18. Execute again activatePaymentNotice request
    Given the Execute mod3Cancel poller scenario executed successfully
    And expirationTime with None in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send payment outcome Phase 1 [IDMP_SPO_31]
  Scenario: 19. Execute sendPaymentOutcome request on token of Activate Phase 2
    Given the Execute again activatePaymentNotice request scenario executed successfully
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
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @runnable
  # Send payment outcome Phase 2 [IDMP_SPO_31]
  Scenario: 20. Execute sendPaymentOutcome request on token of Activate Phase and different idempotencyKey
    Given the Execute sendPaymentOutcome request on token of Activate Phase 2 scenario executed successfully
    And paymentToken with $activatePaymentNotice1Response.paymentToken in sendPaymentOutcome
    And outcome with KO in sendPaymentOutcome
    And random idempotencyKey having #psp# as idPSP in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcome response
    And restore initial configurations

