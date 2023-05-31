Feature: flow tests for sendPaymentOutcomeV2 - Marca da bollo
   # Reference document:
   # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/558204362/WIP+A.T.+Gestione+della+marca+da+bollo+digitale+nel+NMU
   # https://pagopa.atlassian.net/wiki/spaces/PAG/pages/534609989/Analisi+sendPaymentOutcomeV2+PSP+-+Nodo

   Background:
      Given systems up

   Scenario: activatePaymentNoticeV2
      Given initial XML activatePaymentNoticeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeV2Request>
         <idPSP>#pspEcommerce#</idPSP>
         <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
         <idChannel>#canaleEcommerce#</idChannel>
         <password>#password#</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>310#iuv#</noticeNumber>
         </qrCode>
         <expirationTime>120000</expirationTime>
         <amount>10.00</amount>
         <dueDate>2021-12-12</dueDate>
         <paymentNote>causale</paymentNote>
         </nod:activatePaymentNoticeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML paGetPaymentV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paGetPaymentV2Response>
         <outcome>OK</outcome>
         <data>
         <creditorReferenceId>10$iuv</creditorReferenceId>
         <paymentAmount>10.00</paymentAmount>
         <dueDate>2021-12-12</dueDate>
         <!--Optional:-->
         <retentionDate>2021-12-30T12:12:12</retentionDate>
         <!--Optional:-->
         <lastPayment>1</lastPayment>
         <description>test</description>
         <!--Optional:-->
         <companyName>company</companyName>
         <!--Optional:-->
         <officeName>office</officeName>
         <debtor>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
         <transferList>
         <!--1 to 5 repetitions:-->
         <transfer>
         <idTransfer>1</idTransfer>
         <transferAmount>10.00</transferAmount>
         <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
         <richiestaMarcaDaBollo>
         <hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</hashDocumento>
         <tipoBollo>01</tipoBollo>
         <provinciaResidenza>MI</provinciaResidenza>
         </richiestaMarcaDaBollo>
         <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
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
         </paf:paGetPaymentV2Response>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

   Scenario: closePaymentV2
      Given initial json v2/closepayment
         """
         {
            "paymentTokens": [
               "$activatePaymentNoticeV2Response.paymentToken"
            ],
            "outcome": "OK",
            "idPSP": "#psp#",
            "paymentMethod": "TPAY",
            "idBrokerPSP": "#id_broker_psp#",
            "idChannel": "#canale_versione_primitive_2#",
            "transactionId": "#transaction_id#",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2012-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "key": "12345678"
            },
            "transactionDetails": {
               "origin": "",
               "user": {
                  "fullName": "John Doe",
                  "type": "F",
                  "fiscalCode": "JHNDOE00A01F205N",
                  "notificationEmail": "john.doe@mail.it",
                  "userId": 1234,
                  "userStatus": 11,
                  "userStatusDescription": "REGISTERED_SPID"
               }
            }
         }
         """

   Scenario: Define MBD
      Given initial xml MB
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <PSP>
         <CodiceFiscale>CF60000000006</CodiceFiscale>
         <Denominazione>#psp#</Denominazione>
         </PSP>
         <IUBD>#iubd#</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>5.00</Importo>
         <TipoBollo>01</TipoBollo>
         <ImprontaDocumento>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
         </ImprontaDocumento>
         <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
         <SignedInfo>
         <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
         <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
         <Reference URI="">
         <Transforms>
         <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
         </Transforms>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
         </Reference>
         </SignedInfo>
         <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
         </Signature>
         </marcaDaBollo>
         """

   Scenario: sendPaymentOutcomeV2
      Given initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <paymentTokens>
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
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
         <marcheDaBollo>
         <marcaDaBollo>
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
         <idTransfer>1</idTransfer>
         <MBDAttachment>$bollo</MBDAttachment>
         </marcaDaBollo>
         </marcheDaBollo>
         </details>
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """
   
   # sunny day
   Scenario: execute activatePaymentNoticeV2 1
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response

   Scenario: execute closePaymentV2 1
      Given the execute activatePaymentNoticeV2 1 scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v2/closepayment response is 200
      And check outcome is OK of v2/closepayment response
      And wait 5 seconds for expiration
   @test 
   Scenario: execute sendPaymentOutcomeV2 1
      Given the execute closePaymentV2 1 scenario executed successfully
      And the Define MBD scenario executed successfully
      And MB generation
         """
         $MB
         """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And verify 1 record for the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value $MB.TipoBollo of the record at column TIPO_BOLLO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value BD of the record at column TIPO_ALLEGATO_RICEVUTA of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value $iubd of the record at column IUBD of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value $MB.Importo of the record at column IMPORTO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      # And checks the value $MB.OraAcquisto of the record at column ORA_ACQUISTO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ORA_ACQUISTO of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML_CONTENT of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_TRANSFER_MBD retrived by the query select_position_transfer_mbd on db nodo_online under macro NewMod1


   # check match richieste registrate con i bolli mandati dal psp
   Scenario: activatePaymentNoticeV2 3 transfers
      Given initial XML activatePaymentNoticeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
         xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeV2Request>
         <idPSP>#pspEcommerce#</idPSP>
         <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
         <idChannel>#canaleEcommerce#</idChannel>
         <password>#password#</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>310#iuv#</noticeNumber>
         </qrCode>
         <expirationTime>120000</expirationTime>
         <amount>10.00</amount>
         <dueDate>2021-12-12</dueDate>
         <paymentNote>causale</paymentNote>
         </nod:activatePaymentNoticeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML paGetPaymentV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paGetPaymentV2Response>
         <outcome>OK</outcome>
         <data>
         <creditorReferenceId>10$iuv</creditorReferenceId>
         <paymentAmount>10.00</paymentAmount>
         <dueDate>2021-12-12</dueDate>
         <!--Optional:-->
         <retentionDate>2021-12-30T12:12:12</retentionDate>
         <!--Optional:-->
         <lastPayment>1</lastPayment>
         <description>test</description>
         <!--Optional:-->
         <companyName>company</companyName>
         <!--Optional:-->
         <officeName>office</officeName>
         <debtor>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
         <transferList>
         <!--1 to 5 repetitions:-->
         <transfer>
         <idTransfer>1</idTransfer>
         <transferAmount>6.00</transferAmount>
         <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
         <richiestaMarcaDaBollo>
         <hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</hashDocumento>
         <tipoBollo>01</tipoBollo>
         <provinciaResidenza>MI</provinciaResidenza>
         </richiestaMarcaDaBollo>
         <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
         <transferCategory>paGetPaymentTest</transferCategory>
         </transfer>
         <transfer>
         <idTransfer>2</idTransfer>
         <transferAmount>2.00</transferAmount>
         <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
         <IBAN>IT45R0760103200000000001016</IBAN>
         <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
         <transferCategory>paGetPaymentTest</transferCategory>
         </transfer>
         <transfer>
         <idTransfer>3</idTransfer>
         <transferAmount>2.00</transferAmount>
         <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
         <richiestaMarcaDaBollo>
         <hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</hashDocumento>
         <tipoBollo>01</tipoBollo>
         <provinciaResidenza>MI</provinciaResidenza>
         </richiestaMarcaDaBollo>
         <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
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
         </paf:paGetPaymentV2Response>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paGetPaymentV2

   Scenario: Define MBD 2
      Given initial xml MB2
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <PSP>
         <CodiceFiscale>CF60000000006</CodiceFiscale>
         <Denominazione>#psp#</Denominazione>
         </PSP>
         <IUBD>#iubd2#</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>5.00</Importo>
         <TipoBollo>01</TipoBollo>
         <ImprontaDocumento>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <ns2:DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</ns2:DigestValue>
         </ImprontaDocumento>
         <Signature xmlns="http://www.w3.org/2000/09/xmldsig#">
         <SignedInfo>
         <CanonicalizationMethod Algorithm="http://www.w3.org/TR/2001/REC-xml-c14n-20010315" />
         <SignatureMethod Algorithm="http://www.w3.org/2001/04/xmldsig-more#rsa-sha256" />
         <Reference URI="">
         <Transforms>
         <Transform Algorithm="http://www.w3.org/2000/09/xmldsig#enveloped-signature" />
         </Transforms>
         <DigestMethod Algorithm="http://www.w3.org/2001/04/xmlenc#sha256" />
         <DigestValue>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</DigestValue>
         </Reference>
         </SignedInfo>
         <SignatureValue>tSO5SByNpadbzbPvUn5T99ajU4hHdqJLVyr4u8P8WSB5xc9K7Szmw/fo5SYXYaPS6A/DzPlchM95 fgFMZ3VYByqtA+Vc7WgX8aIOEVOrM6eXqx8+kc4g/jgm/9EQyUmXGP+RBvx2Sg0uim04aDdB7Ffd UIi6Q5vjjna1rhNvZIkBEjCV++f+wbL9qpFLt8E2N+bOq9Y0wcTUBHiICrxXvDBDUj1X7Ckbu0/Y KVRJck6cE5rpoQB6DjxdEn5DEUgmzR/UZEwtA1BK3cVRiOsaszx8bXEIwGHe4fvvzxJOHIqgL4ct jj1DoI5m2xGoobQ3rG6Pf3HEwFXLw9x83OykDA==</SignatureValue>
         </Signature>
         </marcaDaBollo>
         """

   Scenario: sendPaymentOutcomeV2 3 MBD
      Given initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <paymentTokens>
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
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
         <marcheDaBollo>
         <marcaDaBollo>
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
         <idTransfer>1</idTransfer>
         <MBDAttachment>$bollo</MBDAttachment>
         </marcaDaBollo>
         <marcaDaBollo>
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
         <idTransfer>2</idTransfer>
         <MBDAttachment>$bollo</MBDAttachment>
         </marcaDaBollo>
         <marcaDaBollo>
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
         <idTransfer>3</idTransfer>
         <MBDAttachment>$2bollo</MBDAttachment>
         </marcaDaBollo>
         </marcheDaBollo>
         </details>
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   # test 1
   Scenario: execute activatePaymentNoticeV2 2
      Given the activatePaymentNoticeV2 3 transfers scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response

   Scenario: execute closePaymentV2 2
      Given the execute activatePaymentNoticeV2 2 scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v2/closepayment response is 200
      And check outcome is OK of v2/closepayment response
      And wait 5 seconds for expiration
   @test 
   Scenario: execute sendPaymentOutcomeV2 2
      Given the execute closePaymentV2 2 scenario executed successfully
      And the Define MBD scenario executed successfully
      And MB generation
         """
         $MB
         """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Check marca da bollo of sendPaymentOutcomeV2 response

   # test 2
   Scenario: execute activatePaymentNoticeV2 3
      Given the activatePaymentNoticeV2 3 transfers scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response

   Scenario: execute closePaymentV2 3
      Given the execute activatePaymentNoticeV2 3 scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v2/closepayment response is 200
      And check outcome is OK of v2/closepayment response
      And wait 5 seconds for expiration
   @test 
   Scenario: execute sendPaymentOutcomeV2 3
      Given the execute closePaymentV2 3 scenario executed successfully
      And the Define MBD scenario executed successfully
      And MB generation
         """
         $MB
         """
      And the Define MBD 2 scenario executed successfully
      And MB2 generation
         """
         $MB2
         """
      And the sendPaymentOutcomeV2 3 MBD scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Check marca da bollo of sendPaymentOutcomeV2 response


   # test 3 - IUBD non univoco  -->  SPOV2 OK
   Scenario: execute activatePaymentNoticeV2 4
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response

   Scenario: execute closePaymentV2 4
      Given the execute activatePaymentNoticeV2 4 scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v2/closepayment response is 200
      And check outcome is OK of v2/closepayment response
      And wait 5 seconds for expiration
   @test 
   Scenario: execute sendPaymentOutcomeV2 4
      Given the execute closePaymentV2 4 scenario executed successfully
      And the Define MBD scenario executed successfully
      And IUBD with 1574213715129721 in MB
      And MB generation
         """
         $MB
         """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response


   # test 4 - Hash diverso  -->  SPOV2 OK
   Scenario: execute activatePaymentNoticeV2 5
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response

   Scenario: execute closePaymentV2 5
      Given the execute activatePaymentNoticeV2 5 scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v2/closepayment response is 200
      And check outcome is OK of v2/closepayment response
      And wait 5 seconds for expiration
   @test 
   Scenario: execute sendPaymentOutcomeV2 5
      Given the execute closePaymentV2 5 scenario executed successfully
      And the Define MBD scenario executed successfully
      And ns2:DigestValue with ciao in MB
      And MB generation
         """
         $MB
         """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response


   # test 5 - CF PSP diverso  -->  SPOV2 OK
   Scenario: execute activatePaymentNoticeV2 6
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response

   Scenario: execute closePaymentV2 6
      Given the execute activatePaymentNoticeV2 6 scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v2/closepayment response is 200
      And check outcome is OK of v2/closepayment response
      And wait 5 seconds for expiration
   @test 
   Scenario: execute sendPaymentOutcomeV2 6
      Given the execute closePaymentV2 6 scenario executed successfully
      And the Define MBD scenario executed successfully
      And CodiceFiscale with CF40000000001 in MB
      And MB generation
         """
         $MB
         """
      And the sendPaymentOutcomeV2 scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response