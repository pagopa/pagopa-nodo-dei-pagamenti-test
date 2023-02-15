Feature: PAG-1976

  Background:
    Given systems up

  Scenario: activatePaymentNotice request
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
      <noticeNumber>302#iuv#</noticeNumber>
      </qrCode>
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <paf:paGetPaymentRes>
      <outcome>OK</outcome>
      <data>
      <creditorReferenceId>02$iuv</creditorReferenceId>
      <paymentAmount>10.00</paymentAmount>
      <dueDate>2021-12-31</dueDate>
      <!--Optional:-->
      <retentionDate>2021-12-31T12:12:12</retentionDate>
      <!--Optional:-->
      <lastPayment>1</lastPayment>
      <description>description</description>
      <!--Optional:-->
      <companyName>company</companyName>
      <!--Optional:-->
      <officeName>office</officeName>
      <debtor>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>paGetPaymentName</fullName>
      <!--Optional:-->
      <streetName>paGetPaymentStreet</streetName>
      <!--Optional:-->
      <civicNumber>paGetPayment99</civicNumber>
      <!--Optional:-->
      <postalCode>20155</postalCode>
      <!--Optional:-->
      <city>paGetPaymentCity</city>
      <!--Optional:-->
      <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
      <!--Optional:-->
      <country>IT</country>
      <!--Optional:-->
      <e-mail>paGetPayment@test.it</e-mail>
      </debtor>
      <!--Optional:-->
      <transferList>
      <!--1 to 5 repetitions:-->
      <transfer>
      <idTransfer>1</idTransfer>
      <transferAmount>10.00</transferAmount>
      <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      </transferList>
      <!--Optional:-->
      <metadata>
      <!--1 to 10 repetitions:-->
      <mapEntry>
      <key>1</key>
      <value>22</value>
      </mapEntry>
      </metadata>
      </data>
      </paf:paGetPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paGetPayment

  Scenario: mod3CancelV2
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200

  Scenario: sendPaymentOutcome request
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

  Scenario: sendPaymentOutcome with unknown token request
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
      <paymentToken>token</paymentToken>
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

  Scenario: sendPaymentOutcomeV2 request
    Given initial XML sendPaymentOutcomeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeV2Request>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>#password#</password>
      <paymentTokens>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      </paymentTokens>
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
      </nod:sendPaymentOutcomeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: sendPaymentOutcomeV2 with unknown token request
    Given initial XML sendPaymentOutcomeV2
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeV2Request>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>#password#</password>
      <paymentTokens>
      <paymentToken>token</paymentToken>
      </paymentTokens>
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
      </nod:sendPaymentOutcomeV2Request>
      </soapenv:Body>
      </soapenv:Envelope>
      """

  ##########################################################################################

  Scenario: Posizione ancora pagabile spov1 OK (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione ancora pagabile spov1 OK (part 2)
    Given the Posizione ancora pagabile spov1 OK (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response
    And wait 5 seconds for expiration

    And checks the value PAYING,CANCELLED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 4 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  Scenario: Posizione non pagabile spov1 OK (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1

  Scenario: Posizione non pagabile spov1 OK (part 2)
    Given the Posizione non pagabile spov1 OK (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And expirationTime with None in activatePaymentNotice
    And random idempotencyKey having #psp# as idPSP in activatePaymentNotice
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione non pagabile spov1 OK (part 3)
    Given the Posizione non pagabile spov1 OK (part 2) scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And paymentToken with $activatePaymentNotice1Response.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcome response

    And checks the value PAYING,CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED,PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  @test
  Scenario: Token sconosciuto spov1 KO
    Given the sendPaymentOutcome with unknown token request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response

  ##########################################################################################

  Scenario: Esito già acquisito spov1 KO (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  Scenario: Esito già acquisito spov1 KO (part 2)
    Given the Esito già acquisito spov1 KO (part 1) scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

  @test
  Scenario: Esito già acquisito spov1 KO (part 3)
    Given the Esito già acquisito spov1 KO (part 2) scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response

    And checks the value PAYING,FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  Scenario: Posizione ancora pagabile spov1 KO (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione ancora pagabile spov1 KO (part 2)
    Given the Posizione ancora pagabile spov1 KO (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response

    And checks the value PAYING,CANCELLED,FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  Scenario: Posizione non pagabile spov1 KO (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1

  Scenario: Posizione non pagabile spov1 KO (part 2)
    Given the Posizione non pagabile spov1 KO (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And expirationTime with None in activatePaymentNotice
    And random idempotencyKey having #psp# as idPSP in activatePaymentNotice
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione non pagabile spov1 KO (part 3)
    Given the Posizione non pagabile spov1 KO (part 2) scenario executed successfully
    And the sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    And paymentToken with $activatePaymentNotice1Response.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response

    And checks the value PAYING,CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED,PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  Scenario: Posizione ancora pagabile spov2 OK (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione ancora pagabile spov2 OK (part 2)
    Given the Posizione ancora pagabile spov2 OK (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And the sendPaymentOutcomeV2 request scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcomeV2 response
    And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcomeV2 response
    And wait 5 seconds for expiration

    And checks the value PAYING,CANCELLED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 4 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  Scenario: Posizione non pagabile spov2 OK (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1

  Scenario: Posizione non pagabile spov2 OK (part 2)
    Given the Posizione non pagabile spov2 OK (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And expirationTime with None in activatePaymentNotice
    And random idempotencyKey having #psp# as idPSP in activatePaymentNotice
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione non pagabile spov2 OK (part 3)
    Given the Posizione non pagabile spov2 OK (part 2) scenario executed successfully
    And the sendPaymentOutcomeV2 request scenario executed successfully
    And paymentToken with $activatePaymentNotice1Response.paymentToken in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcomeV2 response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

    And checks the value PAYING,CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED,PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  @test
  Scenario: Token sconosciuto spov2 KO
    Given the sendPaymentOutcomeV2 with unknown token request scenario executed successfully
    And outcome with KO in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcomeV2 response
    And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response

  ##########################################################################################

  Scenario: Esito già acquisito spov2 KO (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  Scenario: Esito già acquisito spov2 KO (part 2)
    Given the Esito già acquisito spov2 KO (part 1) scenario executed successfully
    And the sendPaymentOutcomeV2 request scenario executed successfully
    And outcome with KO in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response

  @test
  Scenario: Esito già acquisito spov2 KO (part 3)
    Given the Esito già acquisito spov2 KO (part 2) scenario executed successfully
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcomeV2 response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response

    And checks the value PAYING,FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  Scenario: Posizione ancora pagabile spov2 KO (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione ancora pagabile spov2 KO (part 2)
    Given the Posizione ancora pagabile spov2 KO (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And the sendPaymentOutcomeV2 request scenario executed successfully
    And outcome with KO in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcomeV2 response
    And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcomeV2 response

    And checks the value PAYING,CANCELLED,FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

  ##########################################################################################

  Scenario: Posizione non pagabile spov2 KO (part 1)
    Given the activatePaymentNotice request scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And save activatePaymentNotice response in activatePaymentNotice1

  Scenario: Posizione non pagabile spov2 KO (part 2)
    Given the Posizione non pagabile spov2 KO (part 1) scenario executed successfully
    And the mod3CancelV2 scenario executed successfully
    And expirationTime with None in activatePaymentNotice
    And random idempotencyKey having #psp# as idPSP in activatePaymentNotice
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @test
  Scenario: Posizione non pagabile spov2 KO (part 3)
    Given the Posizione non pagabile spov2 KO (part 2) scenario executed successfully
    And the sendPaymentOutcomeV2 request scenario executed successfully
    And outcome with KO in sendPaymentOutcomeV2
    And paymentToken with $activatePaymentNotice1Response.paymentToken in sendPaymentOutcomeV2
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcomeV2 response
    And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcomeV2 response

    And checks the value PAYING,CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value CANCELLED,PAYING of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING,INSERTED,PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 3 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1