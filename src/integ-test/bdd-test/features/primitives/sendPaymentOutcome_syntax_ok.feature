Feature: syntax checks for sendPaymentOutcome - OK

  Background:
    Given systems up
    And initial XML sendPaymentOutcome soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:sendPaymentOutcomeReq>
                 <idPSP>70000000001</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_01</idChannel>
                 <password>pwdpwdpwd</password>
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
    And EC new version

  # element value check
 Scenario Outline: Check sendPaymentOutcome response with missing optional fields
    Given <element> with <value> in sendPaymentOutcomeReq
    When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    
    Examples:
      | elem                | value                               | soapUI test |
      | paymentChannel      | None                                | SIN_SPO_26  |
      | payer               | None                                | SIN_SPO_35  |
      | streetName          | None                                | SIN_SPO_51  |
      | civicNumber         | None                                | SIN_SPO_54  |
      | postalCode          | None                                | SIN_SPO_57  |
      | city                | None                                | SIN_SPO_60  |
      | stateProvinceRegion | None                                | SIN_SPO_63  |
      | country             | None                                | SIN_SPO_66  |
      | e-mail              | None                                | SIN_SPO_70  |
      | idempotencyKey      | None                                | SIN_SPO_80  |
      
      
      
      