Feature: flow checks for sendPaymentResult with PA new

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
         <noticeNumber>302#iuv#</noticeNumber>
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
         <noticeNumber>302$iuv</noticeNumber>
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
         <creditorReferenceId>02$iuv</creditorReferenceId>
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

   Scenario: pspNotifyPayment timeout
      Given initial XML pspNotifyPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <pfn:pspNotifyPaymentRes>
         <delay>10000</delay>
         </pfn:pspNotifyPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

   Scenario: pspNotifyPayment malformata
      Given initial XML pspNotifyPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <pfn:pspNotifyPaymentRes>
         <outcome>OO</outcome>
         </pfn:pspNotifyPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

   Scenario: pspNotifyPayment KO
      Given initial XML pspNotifyPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <pfn:pspNotifyPaymentRes>
         <outcome>KO</outcome>
         <!--Optional:-->
         <fault>
         <faultCode>CANALE_SEMANTICA</faultCode>
         <faultString>Errore semantico dal psp</faultString>
         <id>1</id>
         <!--Optional:-->
         <description>Errore dal psp</description>
         </fault>
         </pfn:pspNotifyPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

   Scenario: pspNotifyPayment irraggiungibile
      Given initial XML pspNotifyPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <pfn:pspNotifyPaymentRes>
         <irraggiungibile/>
         </pfn:pspNotifyPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment


   # T_SPR_01
   Scenario: T_SPR_01 (part 1)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_01 (part 2)
      Given the T_SPR_01 (part 1) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200
   @test
   Scenario: T_SPR_01 (part 3)
      Given the T_SPR_01 (part 2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
      And verify 1 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value OK


   # T_SPR_02
   Scenario: T_SPR_02 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_02 (informazioniPagamento)
      Given the T_SPR_02 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_02 (closePayment)
      Given the T_SPR_02 (informazioniPagamento) scenario executed successfully
      And the pspNotifyPayment timeout scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 15 seconds for expiration
   @test
   Scenario: T_SPR_02 (sendPaymentOutcome)
      Given the T_SPR_02 (closePayment) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And wait 5 seconds for expiration
      And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value OK


   # T_SPR_03
   Scenario: T_SPR_03 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_03 (informazioniPagamento)
      Given the T_SPR_03 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_03 (closePayment)
      Given the T_SPR_03 (informazioniPagamento) scenario executed successfully
      And the pspNotifyPayment malformata scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: T_SPR_03 (sendPaymentOutcome)
      Given the T_SPR_03 (closePayment) scenario executed successfully
      And the sendPaymentOutcome scenario executed successfully
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And wait 5 seconds for expiration
      And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 3 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value OK


   # T_SPR_04
   Scenario: T_SPR_04 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_04 (informazioniPagamento)
      Given the T_SPR_04 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200
   @test
   Scenario: T_SPR_04 (closePayment)
      Given the T_SPR_04 (informazioniPagamento) scenario executed successfully
      And the pspNotifyPayment KO scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
      And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value KO


   # T_SPR_05
   Scenario: T_SPR_05 (activateIOPayment)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
      And wait 5 seconds for expiration
      And the activateIOPayment scenario executed successfully
      And expirationTime with 10000 in activateIOPayment
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_05 (informazioniPagamento)
      Given the T_SPR_05 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_05 (closePayment)
      Given the T_SPR_05 (informazioniPagamento) scenario executed successfully
      And the pspNotifyPayment timeout scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: T_SPR_05 (mod3CancelV2)
      Given the T_SPR_05 (closePayment) scenario executed successfully
      When job mod3CancelV2 triggered after 20 seconds
      Then verify the HTTP status code of mod3CancelV2 response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
      And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value KO


   # T_SPR_06
   Scenario: T_SPR_06 (activateIOPayment)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
      And wait 5 seconds for expiration
      And the activateIOPayment scenario executed successfully
      And expirationTime with 10000 in activateIOPayment
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_06 (informazioniPagamento)
      Given the T_SPR_06 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_06 (closePayment)
      Given the T_SPR_06 (informazioniPagamento) scenario executed successfully
      And the pspNotifyPayment malformata scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: T_SPR_06 (mod3CancelV2)
      Given the T_SPR_06 (closePayment) scenario executed successfully
      When job mod3CancelV2 triggered after 5 seconds
      Then verify the HTTP status code of mod3CancelV2 response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
      And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value KO


   # T_SPR_07
   Scenario: T_SPR_07 (activateIOPayment)
      Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
      And wait 5 seconds for expiration
      And the activateIOPayment scenario executed successfully
      And expirationTime with 10000 in activateIOPayment
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_07 (informazioniPagamento)
      Given the T_SPR_07 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_07 (closePayment)
      Given the T_SPR_07 (informazioniPagamento) scenario executed successfully
      And the pspNotifyPayment irraggiungibile scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
      And wait 5 seconds for expiration
   @test
   Scenario: T_SPR_07 (mod3CancelV2)
      Given the T_SPR_07 (closePayment) scenario executed successfully
      When job mod3CancelV2 triggered after 5 seconds
      Then verify the HTTP status code of mod3CancelV2 response is 200
      And wait 5 seconds for expiration
      And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
      And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value KO


   # T_SPR_08
   Scenario: T_SPR_08 (activateIOPayment)
      Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000
      And wait 5 seconds for expiration
      And the activateIOPayment scenario executed successfully
      And expirationTime with 2000 in activateIOPayment
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_08 (informazioniPagamento)
      Given the T_SPR_08 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_08 (mod3CancelV2)
      Given the T_SPR_08 (informazioniPagamento) scenario executed successfully
      When job mod3CancelV2 triggered after 3 seconds
      Then verify the HTTP status code of mod3CancelV2 response is 200
      And wait 5 seconds for expiration
   @test
   Scenario: T_SPR_08 (closePayment)
      Given the T_SPR_08 (mod3CancelV2) scenario executed successfully
      And the closePayment scenario executed successfully
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 400
      And check esito is KO of v1/closepayment response
      And check descrizione is Esito non accettabile a token scaduto of v1/closepayment response
      And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000
      And wait 5 seconds for expiration
      And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
      And verify 2 record for the table RE retrived by the query select_sprV1_new on db re under macro AppIO
      And execution query select_sprV1_new to get value on the table RE, with the columns PAYLOAD under macro AppIO with db name re
      And through the query select_sprV1_new convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
      And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
      And checking value $XML_RE.pspTransactionId is equal to value $psp_transaction_id
      And checking value $XML_RE.outcome is equal to value KO


   # T_SPR_09
   Scenario: T_SPR_09 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_09 (informazioniPagamento)
      Given the T_SPR_09 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_09 (closePayment)
      Given the T_SPR_09 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_2KO in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test @newfix
   Scenario: T_SPR_09 (retry spr)
      Given the T_SPR_09 (closePayment) scenario executed successfully
      When job positionRetrySendPaymentResult triggered after 65 seconds
      And wait 15 seconds for expiration
      Then verify 0 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO


   # T_SPR_10
   Scenario: T_SPR_10 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_10 (informazioniPagamento)
      Given the T_SPR_10 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_10 (closePayment)
      Given the T_SPR_10 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_400 in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: T_SPR_10 (retry spr)
      Given the T_SPR_10 (closePayment) scenario executed successfully
      When job positionRetrySendPaymentResult triggered after 65 seconds
      And wait 15 seconds for expiration
      Then verify 1 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value resSPR_400 of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value v1 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column REQUEST of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO


   # T_SPR_11
   Scenario: T_SPR_11 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_11 (informazioniPagamento)
      Given the T_SPR_11 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_11 (closePayment)
      Given the T_SPR_11 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_404 in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: T_SPR_11 (retry spr)
      Given the T_SPR_11 (closePayment) scenario executed successfully
      When job positionRetrySendPaymentResult triggered after 65 seconds
      And wait 15 seconds for expiration
      Then verify 1 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value resSPR_404 of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value v1 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column REQUEST of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO


   # T_SPR_12
   Scenario: T_SPR_12 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_12 (informazioniPagamento)
      Given the T_SPR_12 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_12 (closePayment)
      Given the T_SPR_12 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_408 in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: T_SPR_12 (retry spr)
      Given the T_SPR_12 (closePayment) scenario executed successfully
      When job positionRetrySendPaymentResult triggered after 65 seconds
      And wait 15 seconds for expiration
      Then verify 1 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value resSPR_408 of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value v1 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column REQUEST of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO


   # T_SPR_13
   Scenario: T_SPR_13 (activateIOPayment)
      Given the activateIOPayment scenario executed successfully
      When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO
      And checks the value #psp_AGID# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro AppIO

   Scenario: T_SPR_13 (informazioniPagamento)
      Given the T_SPR_13 (activateIOPayment) scenario executed successfully
      When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
      Then verify the HTTP status code of informazioniPagamento response is 200

   Scenario: T_SPR_13 (closePayment)
      Given the T_SPR_13 (informazioniPagamento) scenario executed successfully
      And the closePayment scenario executed successfully
      And pspTransactionId with resSPR_422 in v1/closepayment
      When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
      Then verify the HTTP status code of v1/closepayment response is 200
      And check esito is OK of v1/closepayment response
   @test
   Scenario: T_SPR_13 (retry spr)
      Given the T_SPR_13 (closePayment) scenario executed successfully
      When job positionRetrySendPaymentResult triggered after 65 seconds
      And wait 15 seconds for expiration
      Then verify 1 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value resSPR_422 of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value $activateIOPaymentResponse.paymentToken of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value closePayment-v1 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value sendPaymentResult-v1 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value v1 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO
      And checks the value NotNone of the record at column REQUEST of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO


# T_SPR_14 - Test non eseguibile perché il payload di request della SPR usato nel retry viene creato alla prima chiamata della SPR, quindi il pspTransactionId sarà sempre resSPR_422
# Scenario: T_SPR_14 (end retry spr)
#    Given the T_SPR_13 (retry spr) scenario executed successfully
#    And updates through the query update_retry_spr of the table POSITION_RETRY_SENDPAYMENTRESULT the parameter PSP_TRANSACTION_ID with resSPR_200 under macro AppIO on db nodo_online
#    When job positionRetrySendPaymentResult triggered after 65 seconds
#    And wait 15 seconds for expiration
#    Then verify 0 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query retry_spr on db nodo_online under macro AppIO