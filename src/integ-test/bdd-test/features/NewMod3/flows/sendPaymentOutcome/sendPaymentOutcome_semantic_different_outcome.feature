Feature: Semantic checks for sendPaymentOutcome - different outcome [SEM_SPO_25]

  Background:
    Given systems up
    And EC new version    

  # activatePaymentNoticeReq phase
  Scenario: Execute activatePaymentNotice request
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
                 <expirationTime>60000</expirationTime>
                 <amount>10.00</amount>
              </nod:activatePaymentNoticeReq>
           </soapenv:Body>
        </soapenv:Envelope>
      """
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    
  # sendPaymentOutcomeReq phase
  Scenario: Execute a sendPaymentOutcome request
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
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
      
@runnable @prova    
  # sendPaymentOutcomeReq phase 2
  Scenario: Execute a new sendPaymentOutcome request
    Given the Execute a sendPaymentOutcome request scenario executed successfully
    And outcome with KO in sendPaymentOutcome
    And paymentMethod with cash in sendPaymentOutcome
    And paymentChannel with onLine in sendPaymentOutcome
    And fee with 3.00 in sendPaymentOutcome
    And entityUniqueIdentifierType with F in sendPaymentOutcome
    And entityUniqueIdentifierValue with CR7 in sendPaymentOutcome
    And applicationDate with 2021-12-10 in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
    And check description contains Esito discorde of sendPaymentOutcome response

