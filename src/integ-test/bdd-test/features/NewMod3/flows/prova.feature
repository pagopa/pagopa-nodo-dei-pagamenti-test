Feature: PAG-1976

  Background:
    Given systems up

  @test
  Scenario: spov1
    Given initial xml sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd" xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>60000000001</idPSP>
      <idBrokerPSP>60000000001</idBrokerPSP>
      <idChannel>60000000001_01</idChannel>
      <password>pwdpwdpwd</password>
      <paymentToken>6e2e2e6dfda8440ebe3116a385b252fc</paymentToken>
      <outcome>KO</outcome>
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
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response