Feature:  semantic checks for sendPaymentOutcomeReq - PPT_PAGAMENTO_SCONOSCIUTO #[SEM_SPO_27]

  Background:
    Given systems up 
    And intial XML sendPaymentOutcome soap-request
    """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:sendPaymentOutcomeReq>
                 <idPSP>70000000001</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_01</idChannel>
                 <password>pwdpwdpwd</password>
                 <paymentToken>#paymentToken#</paymentToken>
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
    
    
    # DB insert phase
    Scenario: Execute a DB insert 
    #INSERT INTO NODO_ONLINE.POSITION_ACTIVATE (PA_FISCAL_CODE, NOTICE_ID, CREDITOR_REFERENCE_ID, PSP_ID, IDEMPOTENCY_KEY, PAYMENT_TOKEN, AMOUNT, INSERTED_TIMESTAMP) VALUES ('77777777777', '311011591891198800', '011591891198800', '70000000001', '70000000001_125703rybY', '831c6575705546beb93cffbe3b212310', '10', sysdate)
      
    # sendPaymentOutcomeReq phase 
    Scenario: Execute a sendPaymentOutcome request
    Given DB insert scenario executed successfully
    Given initial XML sendPaymentOutcomeReq
    And paymentToken with value entered through insert query
    When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_PAGAMENTO_SCONOSCIUTO
    
    ## DB delete phase
    Scenario: Execute a DB delete
    #DELETE FROM NODO_ONLINE.POSITION_ACTIVATE WHERE PAYMENT_TOKEN = '831c6575705546beb93cffbe3b212310' AND NOTICE_ID = '311011591891198800'