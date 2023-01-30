Feature: PAG-1976

  Background:
    Given systems up

  Scenario: activatePaymentNotice
    Given initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>#password#</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>#notice_number#</noticeNumber>
      </qrCode>
      <expirationTime>2000</expirationTime>
      <amount>10.00</amount>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: mod3CancelV2
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200

  Scenario: sendPaymentOutcome
    Given initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>#password#</password>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      <outcome>OK</outcome>
      <!--Optional:-->
      <details>
      <paymentMethod>creditCard</paymentMethod>
      <!--Optional:-->
      <paymentChannel>app</paymentChannel>
      <fee>2.00</fee>
      <!--Optional:-->
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>name</fullName>
      <!--Optional:-->
      <streetName>street</streetName>
      <!--Optional:-->
      <civicNumber>civic</civicNumber>
      <!--Optional:-->
      <postalCode>postal</postalCode>
      <!--Optional:-->
      <city>city</city>
      <!--Optional:-->
      <stateProvinceRegion>state</stateProvinceRegion>
      <!--Optional:-->
      <country>IT</country>
      <!--Optional:-->
      <e-mail>prova@test.it</e-mail>
      </payer>
      <applicationDate>2021-12-12</applicationDate>
      <transferDate>2021-12-11</transferDate>
      </details>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  ##########################################################################################

  Scenario: No regression posizione pagabile (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: No regression posizione pagabile (part 2)
    Given the No regression posizione pagabile (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response

  ##########################################################################################

  Scenario: No regression posizione non pagabile (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1

  Scenario: No regression posizione non pagabile (part 2)
    Given the No regression posizione non pagabile (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And expirationTime with None in activatePaymentNotice
    And random idempotencyKey having #psp# as idPSP in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: No regression posizione non pagabile (part 3)
    Given the No regression posizione non pagabile (part 2) scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And paymentToken with $activatePaymentNotice1Response.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcome response

  ##########################################################################################

  @test
  Scenario: No regression token inesistente
    Given the sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    And paymentToken with token in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response

  ##########################################################################################

  Scenario: No regression esito già acquisito (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 60000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  Scenario: No regression esito già acquisito (part 2)
    Given the No regression esito già acquisito (part 1) scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @test
  Scenario: No regression esito già acquisito (part 3)
    Given the No regression esito già acquisito (part 2) scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response

  ##########################################################################################

  Scenario: Test posizione pagabile (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Test posizione pagabile (part 2)
    Given the Test posizione pagabile (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response

  ##########################################################################################

  Scenario: Test posizione non pagabile (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1

  Scenario: Test posizione non pagabile (part 2)
    Given the Test posizione non pagabile (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And expirationTime with None in activatePaymentNotice
    And random idempotencyKey having #psp# as idPSP in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Test posizione non pagabile (part 3)
    Given the Test posizione non pagabile (part 2) scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    And paymentToken with $activatePaymentNotice1Response.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response