Feature:  semantic checks for sendPaymentOutcomeReq - stesso esito - ko #[SEM_SPO_24]

  Background:
    Given systems up 
    And EC new version    

    # activatePaymentNoticeReq phase
    Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice soap-request
      """      
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:activatePaymentNoticeReq>
                 <idPSP>70000000001</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_01</idChannel>
                 <password>pwdpwdpwd</password>
                 <idempotencyKey>#idempotency_key#</idempotencyKey>
                 <qrCode>
                    <fiscalCode>#creditor_institution_code#</fiscalCode>
                    <noticeNumber>#notice_number#</noticeNumber>
                 </qrCode>
                 <expirationTime>60000</expirationTime>
                 <amount>10.00</amount>
              </nod:activatePaymentNoticeReq>
           </soapenv:Body>
        </soapenv:Envelope>
      """
	
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    
    # sendPaymentOutcomeReq phase
    Scenario: Execute a sendPaymentOutcome request
    Given initial XML sendPaymentOutcome soap-request
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
      When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      
    
    # sendPaymentOutcomeReq phase 2
    Scenario: Execute a new sendPaymentOutcome request
    Given sendPaymentOutcomeReq scenario executed successfully
    Given initial XML sendPaymentOutcomeReq
    And paymentMethod with cash in sendPaymentOutcomeReq
    And paymentChannel with onLine in sendPaymentOutcomeReq
    And fee with 3.00 in sendPaymentOutcomeReq
    And entityUniqueIdentifierType with F in sendPaymentOutcomeReq
    And entityUniqueIdentifierValue with CR7 in sendPaymentOutcomeReq
    And applicationDate with 2021-12-10 in sendPaymentOutcomeReq
    When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO
    And description contains 'Esito concorde:'+ JSON 