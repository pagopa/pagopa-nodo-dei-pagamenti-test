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
         <!--Optional:-->
         <metadata>
         <!--1 to 10 repetitions:-->
         <mapEntry>
         <key>1</key>
         <value>22</value>
         </mapEntry>
         </metadata>
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

   @skip
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
            "additionalPMInfo": {
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

   @skip
   Scenario: Define MDB
      Given MDB generation
         """
         <marcaDaBollo xmlns="http://www.agenziaentrate.gov.it/2014/MarcaDaBollo" xmlns:ns2="http://www.w3.org/2000/09/xmldsig#">
         <PSP>
         <CodiceFiscale>CF60000000006</CodiceFiscale>
         <Denominazione>#psp#</Denominazione>
         </PSP>
         <IUBD>$iubd</IUBD>
         <OraAcquisto>2022-02-06T15:00:44.659+01:00</OraAcquisto>
         <Importo>10.00</Importo>
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

   @skip
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
         <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
         <idTransfer>1</idTransfer>
         <MBDAttachment></MBDAttachment>
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

   Scenario: execute sendPaymentOutcomeV2 1
      Given the execute closePaymentV2 1 scenario executed successfully
      And the Define MDB scenario executed successfully
      When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response







#DA ELIMINARE
# Scenario: Psp with MARCA_BOLLO_DIGITALE != 1
#    Given updates through the query update_id_psp of the table PSP the parameter MARCA_BOLLO_DIGITALE with 0 under macro NewMod1 on db nodo_cfg
#    And refresh job PSP triggered after 10 seconds
#    And the closePaymentV2 scenario executed successfully
#    When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#    Then verify the HTTP status code of v2/closepayment response is 400
#    And check outcome is KO of v2/closepayment response
#    And check description is Invalid PSP/Canale for MBD of v2/closepayment response
#    And updates through the query update_id_psp of the table PSP the parameter MARCA_BOLLO_DIGITALE with 1 under macro NewMod1 on db nodo_cfg
#    And refresh job PSP triggered after 10 seconds