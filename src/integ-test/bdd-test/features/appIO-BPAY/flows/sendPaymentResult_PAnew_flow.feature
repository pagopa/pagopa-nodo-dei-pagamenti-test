Feature: flow checks for sendPaymentResult

   Background:
      Given systems up
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>311#iuv#</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML paVerifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paVerifyPaymentNoticeRes>
         <outcome>OK</outcome>
         <paymentList>
         <paymentOptionDescription>
         <amount>1.00</amount>
         <options>EQ</options>
         <!--Optional:-->
         <dueDate>2021-12-31</dueDate>
         <!--Optional:-->
         <detailDescription>descrizione dettagliata lato PA</detailDescription>
         <!--Optional:-->
         <allCCP>false</allCCP>
         </paymentOptionDescription>
         </paymentList>
         <!--Optional:-->
         <paymentDescription>/RFB/00202200000217527/5.00/TXT/</paymentDescription>
         <!--Optional:-->
         <fiscalCodePA>$verifyPaymentNotice.fiscalCode</fiscalCodePA>
         <!--Optional:-->
         <companyName>company PA</companyName>
         <!--Optional:-->
         <officeName>office PA</officeName>
         </paf:paVerifyPaymentNoticeRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   @skip
   Scenario: activateIOPayment
      Given initial XML activateIOPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activateIOPaymentReq>
         <idPSP>#psp_AGID#</idPSP>
         <idBrokerPSP>#broker_AGID#</idBrokerPSP>
         <idChannel>#canale_AGID#</idChannel>
         <password>#password#</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>311$iuv</noticeNumber>
         </qrCode>
         <expirationTime>60000</expirationTime>
         <amount>10.00</amount>
         <paymentNote>responseFull</paymentNote>
         </nod:activateIOPaymentReq>
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
         <transferAmount>10.00</transferAmount>
         <fiscalCodePA>$activateIOPayment.fiscalCode</fiscalCodePA>
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
   Scenario: closePayment
      Given initial json v1/closepayment
         """
         {
            "paymentTokens": [
               "$activateIOPaymentResponse.paymentToken"
            ],
            "outcome": "OK",
            "identificativoPsp": "#psp#",
            "tipoVersamento": "BPAY",
            "identificativoIntermediario": "#id_broker_psp#",
            "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
            "pspTransactionId": "#psp_transaction_id#",
            "totalAmount": 12,
            "fee": 2,
            "timestampOperation": "2012-04-23T18:25:43Z",
            "additionalPaymentInformations": {
               "transactionId": "#transaction_id#",
               "outcomePaymentGateway": "EFF",
               "authorizationCode": "resOK"
            }
         }
         """

   @skip
   Scenario: sendPaymentOutcome
      Given initial XML sendPaymentOutcome
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
         <outcome>OK</outcome>
         <!--Optional:-->
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <!--Optional:-->
         <paymentChannel>app</paymentChannel>
         <fee>5.00</fee>
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


   # T_SPR_01
   Scenario: T_SPR_01 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And save activateIOPayment response in activateIOPaymentResponse
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And check the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_01 (part 2)
      Given the T_SPR_01 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_01 (part 3)
      Given the T_SPR_01 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When PM sends closePayment to nodo-dei-pagamenti
      Then check esito is OK of closePayment response
      And check faultCode is 200 of closePayment response
      And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
      And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
