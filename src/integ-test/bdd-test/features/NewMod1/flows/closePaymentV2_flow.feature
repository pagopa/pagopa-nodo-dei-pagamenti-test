Feature: flow checks for closePaymentV2

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
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>311#iuv#</noticeNumber>
         </qrCode>
         <amount>10.00</amount>
         <dueDate>2021-12-31</dueDate>
         <paymentNote>causale</paymentNote>
         </nod:activatePaymentNoticeV2Request>
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
         <creditorReferenceId>11$iuv</creditorReferenceId>
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
         <transferAmount>3.00</transferAmount>
         <fiscalCodePA>66666666666</fiscalCodePA>
         <IBAN>IT45R0760103200000000001016</IBAN>
         <remittanceInformation>testPaGetPayment</remittanceInformation>
         <transferCategory>paGetPaymentTest</transferCategory>
         </transfer>
         <transfer>
         <idTransfer>2</idTransfer>
         <transferAmount>3.00</transferAmount>
         <fiscalCodePA>66666666666</fiscalCodePA>
         <IBAN>IT45R0760103200000000001016</IBAN>
         <remittanceInformation>testPaGetPayment</remittanceInformation>
         <transferCategory>paGetPaymentTest</transferCategory>
         </transfer>
         <transfer>
         <idTransfer>3</idTransfer>
         <transferAmount>4.00</transferAmount>
         <fiscalCodePA>66666666666</fiscalCodePA>
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

   @skip
   Scenario: closePaymentV2
      Given initial JSON v2/closepayment
         """
         {
            "paymentTokens": [
               "$activatePaymentNoticeV2Response.paymentToken"
            ],
            "outcome": "OK",
            "idPSP": "#psp#",
            "idBrokerPSP": "60000000001",
            "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
            "paymentMethod": "TPAY",
            "transactionId": "#transaction_id#",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2033-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "key": "#psp_transaction_id#"
            },
            "transactionDetails": {
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
         </details>
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   Scenario: FLUSSO_CP_01 (part 1)
      Given the activatePaymentNoticeV2 scenario executed successfully
      When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNoticeV2 response

   Scenario: FLUSSO_CP_01 (part 3)
      Given the FLUSSO_CP_01 (part 1) scenario executed successfully
      And the closePaymentV2 scenario executed successfully
      When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v2/closepayment response is 200
      And check outcome is OK of v2/closepayment response
      And wait 2 seconds for expiration

   Scenario: FLUSSO_CP_01 (part 4)
      Given the FLUSSO_CP_01 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response