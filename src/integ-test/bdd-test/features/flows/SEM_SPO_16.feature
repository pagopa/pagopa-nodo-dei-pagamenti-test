Feature: 

    Given systems up
    And EC old version


    Scenario: Execute activatePaymentNotice request
        Given initial XML activatePaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <nod:verifyPaymentNoticeReq>
         <idPSP>${psp}</idPSP>
         <idBrokerPSP>${intermediarioPSP}</idBrokerPSP>
         <idChannel>${canale3}</idChannel>
         <password>${password}</password>
         <qrCode>
            <fiscalCode>${qrCodeCF}</fiscalCode>
            <noticeNumber>002${#TestCase#iuv}</noticeNumber>
         </qrCode>
      </nod:verifyPaymentNoticeReq>
   </soapenv:Body>
</soapenv:Envelope>
        """
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: Execute sendPaymentOutcome request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
   <soapenv:Header/>
   <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
         <idPSP>${psp}</idPSP>
         <idBrokerPSP>${intermediarioPSP}</idBrokerPSP>
         <idChannel>${canale3}</idChannel>
         <password>${password}</password>
         <paymentToken>8f4aa4d917404037bc3ba23130906c52</paymentToken>
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
    And api-config executes the sql QUERY_DA_INSERIRE (controlla se è PAYING)
    Then check outcome is OK of sendPaymentOutcome response
    And api-config executes the sql QUERY_DA_INSERIRE (controlla se è INSERTED)