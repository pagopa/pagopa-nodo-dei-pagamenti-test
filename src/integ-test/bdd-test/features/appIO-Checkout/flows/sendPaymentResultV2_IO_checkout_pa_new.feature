Feature: flow tests for sendPaymentResultV2

    Background:
        Given systems up

    Scenario: verifyPaymentNotice
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp_AGID#</idPSP>
            <idBrokerPSP>#broker_AGID#</idBrokerPSP>
            <idChannel>#canale_AGID#</idChannel>
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
            <idempotencyKey>#idempotency_key#</idempotencyKey>
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
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: activateIOPayment with 2 seconds expirationTime
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
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
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
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    Scenario: nodoChiediInformazioniPagamento
        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: closePaymentV2 request
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activateIOPaymentResponse.paymentToken"
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
                    "key": "#psp_transaction_id#"
                }
            }
            """

    Scenario: pspNotifyPaymentV2 timeout response
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <delay>10000</delay>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    Scenario: pspNotifyPaymentV2 malformata response
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <outcome>OO</outcome>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    Scenario: pspNotifyPaymentV2 KO response
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <outcome>KO</outcome>
            <!--Optional:-->
            <fault>
            <faultCode>CANALE_SEMANTICA</faultCode>
            <faultString>Errore semantico dal psp</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>Errore dal psp</description>
            </fault>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    Scenario: pspNotifyPaymentV2 irraggiungibile response
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <irraggiungibile/>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    Scenario: pspNotifyPayment timeout response
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

    Scenario: pspNotifyPayment malformata response
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

    Scenario: pspNotifyPayment KO response
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

    Scenario: pspNotifyPayment irraggiungibile response
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

    Scenario: sendPaymentOutcome request
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

    Scenario: sendPaymentOutcomeV2 request
        Given initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_versione_primitive_2#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activateIOPaymentResponse.paymentToken</paymentToken>
            </paymentTokens>
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
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    # FLUSSO_SPR_01_IO

    Scenario: FLUSSO_SPR_01_IO (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test
    Scenario: FLUSSO_SPR_01_IO (part 2)
        Given the FLUSSO_SPR_01_IO (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value 5 of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And execution query select_activateio to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activateIOPaymentResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activateIOPayment.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value #canale_versione_primitive_2#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_02_IO

    Scenario: FLUSSO_SPR_02_IO (part 1)
        Given current date generation
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_SPR_02_IO (part 2)
        Given the FLUSSO_SPR_02_IO (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When job mod3CancelV2 triggered after 0 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_03_IO

    Scenario: FLUSSO_SPR_03_IO (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_SPR_03_IO (part 2)
        Given the FLUSSO_SPR_03_IO (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And execution query select_activateio to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activateIOPaymentResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activateIOPayment.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value #canale_versione_primitive_2#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_04_IO
    @test 
    Scenario: FLUSSO_SPR_04_IO
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 KO response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_05_IO
    @test 
    Scenario: FLUSSO_SPR_05_IO
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 irraggiungibile response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_06_IO

    Scenario: FLUSSO_SPR_06_IO (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test 
    Scenario: FLUSSO_SPR_06_IO (part 2)
        Given the FLUSSO_SPR_06_IO (part 1) scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 5 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activateio on db re under macro NewMod1

    # FLUSSO_SPR_07_IO

    Scenario: FLUSSO_SPR_07_IO (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test 
    Scenario: FLUSSO_SPR_07_IO (part 2)
        Given the FLUSSO_SPR_07_IO (part 1) scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 5 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activateio on db re under macro NewMod1

    # FLUSSO_SPR_08_IO

    Scenario: FLUSSO_SPR_08_IO (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_400_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_SPR_08_IO (part 2)
        Given the FLUSSO_SPR_08_IO (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value 5 of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And execution query select_activateio to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activateIOPaymentResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activateIOPayment.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value #canale_versione_primitive_2#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_09_IO

    Scenario: FLUSSO_SPR_09_IO (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_404_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_SPR_09_IO (part 2)
        Given the FLUSSO_SPR_09_IO (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_404_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value 5 of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_404_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And execution query select_activateio to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activateIOPaymentResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activateIOPayment.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value #canale_versione_primitive_2#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_10_IO

    Scenario: FLUSSO_SPR_10_IO (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_408_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_SPR_10_IO (part 2)
        Given the FLUSSO_SPR_10_IO (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_408_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value 5 of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_408_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And execution query select_activateio to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activateIOPaymentResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activateIOPayment.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value #canale_versione_primitive_2#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # FLUSSO_SPR_11_IO

    Scenario: FLUSSO_SPR_11_IO (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_422_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_SPR_11_IO (part 2)
        Given the FLUSSO_SPR_11_IO (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_422_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value 5 of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value resSPR_422_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value $paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId,$paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken,$activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode,$activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station#,#id_station#,#id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activateio on db nodo_online under macro NewMod1
        And execution query select_activateio to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve xml XML at position 0 and save it under the key XML_DB
        And check value $XML_DB.idPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idBrokerPA is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.idStation is equal to value #id_station#
        And check value $XML_DB.receiptId is equal to value $activateIOPaymentResponse.paymentToken
        And check value $XML_DB.noticeNumber is equal to value $activateIOPayment.noticeNumber
        And check value $XML_DB.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And check value $XML_DB.outcome is equal to value $sendPaymentOutcome.outcome
        And check value $XML_DB.creditorReferenceId is equal to value $paGetPayment.creditorReferenceId
        And check value $XML_DB.paymentAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.description is equal to value $paGetPayment.description
        And check value $XML_DB.companyName is equal to value $paGetPayment.companyName
        And check value $XML_DB.entityUniqueIdentifierType is equal to value $paGetPayment.entityUniqueIdentifierType
        And check value $XML_DB.entityUniqueIdentifierValue is equal to value $paGetPayment.entityUniqueIdentifierValue
        And check value $XML_DB.fullName is equal to value $paGetPayment.fullName
        And check value $XML_DB.streetName is equal to value $paGetPayment.streetName
        And check value $XML_DB.civicNumber is equal to value $paGetPayment.civicNumber
        And check value $XML_DB.postalCode is equal to value $paGetPayment.postalCode
        And check value $XML_DB.city is equal to value $paGetPayment.city
        And check value $XML_DB.stateProvinceRegion is equal to value $paGetPayment.stateProvinceRegion
        And check value $XML_DB.country is equal to value $paGetPayment.country
        And check value $XML_DB.idTransfer is equal to value $paGetPayment.idTransfer
        And check value $XML_DB.transferAmount is equal to value $activateIOPayment.amount
        And check value $XML_DB.fiscalCodePA is equal to value $paGetPayment.fiscalCodePA
        And check value $XML_DB.IBAN is equal to value $paGetPayment.IBAN
        And check value $XML_DB.remittanceInformation is equal to value $paGetPayment.remittanceInformation
        And check value $XML_DB.transferCategory is equal to value $paGetPayment.transferCategory
        And check value $XML_DB.idPSP is equal to value $sendPaymentOutcome.idPSP
        And check value $XML_DB.pspFiscalCode is equal to value CF60000000006
        And check value $XML_DB.PSPCompanyName is equal to value PSP Paolo
        And check value $XML_DB.idChannel is equal to value #canale_versione_primitive_2#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_01
    @test 
    Scenario: T_SPR_V2_01
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activateio on db re under macro NewMod1

    # T_SPR_V2_02

    Scenario: T_SPR_V2_02 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPayment timeout response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: T_SPR_V2_02 (part 2)
        Given the T_SPR_V2_02 (part 1) scenario executed successfully
        And wait 12 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_03

    Scenario: T_SPR_V2_03 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPayment malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: T_SPR_V2_03 (part 2)
        Given the T_SPR_V2_03 (part 1) scenario executed successfully
        And wait 10 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_04
    @test 
    Scenario: T_SPR_V2_04
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPayment KO response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_05
    @test 
    Scenario: T_SPR_V2_05
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPayment irraggiungibile response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_06

    Scenario: T_SPR_V2_06 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPayment malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
    @test 
    Scenario: T_SPR_V2_06 (part 2)
        Given the T_SPR_V2_06 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 0 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_07

    Scenario: T_SPR_V2_07 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment with 2 seconds expirationTime scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPayment malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: T_SPR_V2_07 (part 2)
        Given the T_SPR_V2_07 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_08

    Scenario: T_SPR_V2_08 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment with 2 seconds expirationTime scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test 
    Scenario: T_SPR_V2_08 (part 2)
        Given the T_SPR_V2_08 (part 1) scenario executed successfully
        And wait 3 seconds for expiration
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activateio on db re under macro NewMod1

    # T_SPR_V2_09

    Scenario: T_SPR_V2_09 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        And transactionId with resSPR_2KO_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @newfix
    Scenario: T_SPR_V2_09 (part 2)
        Given the T_SPR_V2_09 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        # And verify 0 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_10

    Scenario: T_SPR_V2_10 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        And transactionId with resSPR_400_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_10 (part 2)
        Given the T_SPR_V2_10 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
    @test 
    Scenario: T_SPR_V2_10 (part 3)
        Given the T_SPR_V2_10 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_11

    Scenario: T_SPR_V2_11 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        And transactionId with resSPR_404_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_11 (part 2)
        Given the T_SPR_V2_11 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
    @test 
    Scenario: T_SPR_V2_11 (part 3)
        Given the T_SPR_V2_11 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_404_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_404_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_12

    Scenario: T_SPR_V2_12 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        And transactionId with resSPR_408_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_12 (part 2)
        Given the T_SPR_V2_12 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
    @test 
    Scenario: T_SPR_V2_12 (part 3)
        Given the T_SPR_V2_12 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_408_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_408_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_13

    Scenario: T_SPR_V2_13 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        And transactionId with resSPR_422_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_13 (part 2)
        Given the T_SPR_V2_13 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
    @test 
    Scenario: T_SPR_V2_13 (part 3)
        Given the T_SPR_V2_13 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_422_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_422_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_14

    Scenario: T_SPR_V2_14 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        And transactionId with resSPR_400_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_14 (part 2)
        Given the T_SPR_V2_14 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
    @test 
    Scenario: T_SPR_V2_14 (part 3)
        Given the T_SPR_V2_14 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spo on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spo to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spo convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcome.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_01_V2
    @test 
    Scenario: T_SPR_V2_01_V2
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activateio on db re under macro NewMod1

    # T_SPR_V2_02_V2

    Scenario: T_SPR_V2_02_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 timeout response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
    @test 
    Scenario: T_SPR_V2_02_V2 (part 2)
        Given the T_SPR_V2_02_V2 (part 1) scenario executed successfully
        And wait 12 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_03_V2

    Scenario: T_SPR_V2_03_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
    @test 
    Scenario: T_SPR_V2_03_V2 (part 2)
        Given the T_SPR_V2_03_V2 (part 1) scenario executed successfully
        And wait 10 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_04_V2
    @test 
    Scenario: T_SPR_V2_04_V2
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 KO response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_05_V2
    @test 
    Scenario: T_SPR_V2_05_V2
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 irraggiungibile response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_06_V2

    Scenario: T_SPR_V2_06_V2 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $transaction_id,$transaction_id,$transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
    @test 
    Scenario: T_SPR_V2_06_V2 (part 2)
        Given the T_SPR_V2_06_V2 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 0 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_07_V2

    Scenario: T_SPR_V2_07_V2 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment with 2 seconds expirationTime scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: T_SPR_V2_07_V2 (part 2)
        Given the T_SPR_V2_07_V2 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activateio to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activateio convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE.paymentToken is equal to value $activateIOPaymentResponse.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_08_V2

    Scenario: T_SPR_V2_08_V2 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 1000
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment with 2 seconds expirationTime scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test 
    Scenario: T_SPR_V2_08_V2 (part 2)
        Given the T_SPR_V2_08_V2 (part 1) scenario executed successfully
        And wait 3 seconds for expiration
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activateio on db re under macro NewMod1

    # T_SPR_V2_09_V2

    Scenario: T_SPR_V2_09_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_2KO_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @newfix
    Scenario: T_SPR_V2_09_V2 (part 2)
        Given the T_SPR_V2_09_V2 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        # And verify 0 record for the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_10_V2

    Scenario: T_SPR_V2_10_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_400_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_10_V2 (part 2)
        Given the T_SPR_V2_10_V2 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @test 
    Scenario: T_SPR_V2_10_V2 (part 3)
        Given the T_SPR_V2_10_V2 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_11_V2

    Scenario: T_SPR_V2_11_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_404_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_11_V2 (part 2)
        Given the T_SPR_V2_11_V2 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @test 
    Scenario: T_SPR_V2_11_V2 (part 3)
        Given the T_SPR_V2_11_V2 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_404_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_404_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_12_V2

    Scenario: T_SPR_V2_12_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_408_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_12_V2 (part 2)
        Given the T_SPR_V2_12_V2 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @test 
    Scenario: T_SPR_V2_12_V2 (part 3)
        Given the T_SPR_V2_12_V2 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_408_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_408_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_13_V2

    Scenario: T_SPR_V2_13_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_422_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_13_V2 (part 2)
        Given the T_SPR_V2_13_V2 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @test 
    Scenario: T_SPR_V2_13_V2 (part 3)
        Given the T_SPR_V2_13_V2 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_422_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_422_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName

    # T_SPR_V2_14_V2

    Scenario: T_SPR_V2_14_V2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the nodoChiediInformazioniPagamento scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And transactionId with resSPR_400_$transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: T_SPR_V2_14_V2 (part 2)
        Given the T_SPR_V2_14_V2 (part 1) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @test 
    Scenario: T_SPR_V2_14_V2 (part 3)
        Given the T_SPR_V2_14_V2 (part 2) scenario executed successfully
        When job positionRetrySendPaymentResult triggered after 65 seconds
        Then verify the HTTP status code of positionRetrySendPaymentResult response is 200
        And wait 15 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_RETRY_SENDPAYMENTRESULT
        And checks the value NotNone of the record at column ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column PSP_TRANSACTION_ID of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value resSPR_400_$transaction_id of the record at column ID_SESSIONE_ORIGINALE of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column RETRY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column INSERTED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentResult-v2 of the record at column UPDATED_BY of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column VERSION of the table POSITION_RETRY_SENDPAYMENTRESULT retrived by the query PAYMENT_TOKEN_spov2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $sendPaymentOutcomeV2.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPayment.description
        And checking value $XML_RE.fiscalCode is equal to value $activateIOPayment.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPayment.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPayment.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPayment.officeName