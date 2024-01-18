Feature: flow tests for closePaymentV2 143

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

    Scenario: activateIOPayment with paGetPayment KO
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
            <paymentNote>responseKO</paymentNote>
            </nod:activateIOPaymentReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paGetPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentRes>
            <outcome>KO</outcome>
            <!--Optional:-->
            <fault>
            <faultCode>PAA_SEMANTICA</faultCode>
            <faultString>chiamata rifiutata</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>chiamata rifiutata</description>
            </fault>
            </paf:paGetPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is KO of activateIOPayment response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of activateIOPayment response

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
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """

    Scenario: closePaymentV2 with arbitrary paymentToken request
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "token"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """

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

    Scenario: sendPaymentOutcome with arbitrary paymentToken request
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
            <paymentToken>token</paymentToken>
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

    # FLUSSO_CP_01

    Scenario: FLUSSO_CP_01 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_01 (part 2)
        Given the FLUSSO_CP_01 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_01 (part 3)
        Given the FLUSSO_CP_01 (part 2) scenario executed successfully
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # FLUSSO_CP_02

    Scenario: FLUSSO_CP_02 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_02 (part 2)
        Given the FLUSSO_CP_02 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test  
    Scenario: FLUSSO_CP_02 (part 3)
        Given the FLUSSO_CP_02 (part 2) scenario executed successfully
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

        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Esito discorde of sendPaymentOutcome response

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

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

    # FLUSSO_CP_03

    Scenario: FLUSSO_CP_03 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_03 (part 2)
        Given the FLUSSO_CP_03 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_03 (part 3)
        Given the FLUSSO_CP_03 (part 2) scenario executed successfully
        And wait 5 seconds for expiration

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response
        And check description is token unknown of sendPaymentOutcome response

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

    # FLUSSO_CP_04

    Scenario: FLUSSO_CP_04 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_04 (part 2)
        Given the FLUSSO_CP_04 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_04 (part 3)
        Given the FLUSSO_CP_04 (part 2) scenario executed successfully
        And wait 5 seconds for expiration

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response
        And check description is token unknown of sendPaymentOutcome response

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

    # FLUSSO_CP_05

    Scenario: FLUSSO_CP_05 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_05 (part 2)
        Given the FLUSSO_CP_05 (part 1) scenario executed successfully
        And the pspNotifyPayment timeout scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_05 (part 3)
        Given the FLUSSO_CP_05 (part 2) scenario executed successfully
        And wait 12 seconds for expiration

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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # FLUSSO_CP_06

    Scenario: FLUSSO_CP_06 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_06 (part 2)
        Given the FLUSSO_CP_06 (part 1) scenario executed successfully
        And the pspNotifyPayment malformata scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_06 (part 3)
        Given the FLUSSO_CP_06 (part 2) scenario executed successfully
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # FLUSSO_CP_07

    Scenario: FLUSSO_CP_07 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_07 (part 2)
        Given the FLUSSO_CP_07 (part 1) scenario executed successfully
        And the pspNotifyPayment timeout scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_07 (part 3)
        Given the FLUSSO_CP_07 (part 2) scenario executed successfully
        And wait 12 seconds for expiration

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

        When job mod3CancelV2 triggered after 0 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 5 seconds for expiration
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

    # FLUSSO_CP_08

    Scenario: FLUSSO_CP_08 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 2000
        And current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_08 (part 2)
        Given the FLUSSO_CP_08 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test 
    Scenario: FLUSSO_CP_08 (part 3)
        Given the FLUSSO_CP_08 (part 2) scenario executed successfully
        And wait 3 seconds for expiration
        And the pspNotifyPayment timeout scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 12 seconds for expiration
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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

    # FLUSSO_CP_09

    Scenario: FLUSSO_CP_09 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 2000
        And current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_09 (part 2)
        Given the FLUSSO_CP_09 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @pippoalf
    Scenario: FLUSSO_CP_09 (part 3)
        Given the FLUSSO_CP_09 (part 2) scenario executed successfully
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

        And nodo-dei-pagamenti has config parameter default_durata_token_IO set to 3600000

    # FLUSSO_CP_10

    Scenario: FLUSSO_CP_10 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 2000
        And current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_10 (part 2)
        Given the FLUSSO_CP_10 (part 1) scenario executed successfully
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test 
    Scenario: FLUSSO_CP_10 (part 3)
        Given the FLUSSO_CP_10 (part 2) scenario executed successfully
        And wait 3 seconds for expiration
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

    # FLUSSO_CP_11

    Scenario: FLUSSO_CP_11 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_11 (part 2)
        Given the FLUSSO_CP_11 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_CP_11 (part 3)
        Given the FLUSSO_CP_11 (part 2) scenario executed successfully
        And execution query transactionid to get value on the table PM_METADATA, with the columns * under macro NewMod1 with db name nodo_online
        And through the query transactionid retrieve param TRANSACTION_ID at position 1 in the row 0 and save it under the key temp_transaction_id
        And through the query transactionid retrieve param VALUE at position 3 in the row 2 and save it under the key temp_psp_transaction_id
        And the closePaymentV2 request scenario executed successfully
        And transactionId with $temp_transaction_id in v2/closepayment
        And key with $temp_psp_transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_11 (part 4)
        Given the FLUSSO_CP_11 (part 3) scenario executed successfully
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
        And checks the value $temp_transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $temp_transaction_id,$temp_transaction_id,$temp_transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$temp_psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1

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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value $temp_transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # FLUSSO_CP_12

    Scenario: FLUSSO_CP_12 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_12 (part 2)
        Given the FLUSSO_CP_12 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

    Scenario: FLUSSO_CP_12 (part 3)
        Given the FLUSSO_CP_12 (part 2) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_12 (part 4)
        Given the FLUSSO_CP_12 (part 3) scenario executed successfully
        And wait 5 seconds for expiration

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

    # FLUSSO_CP_13

    Scenario: FLUSSO_CP_13 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_13 (part 2)
        Given the FLUSSO_CP_13 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_CP_13 (part 3)
        Given the FLUSSO_CP_13 (part 2) scenario executed successfully
        And execution query transactionid to get value on the table PM_METADATA, with the columns * under macro NewMod1 with db name nodo_online
        And through the query transactionid retrieve param TRANSACTION_ID at position 1 in the row 0 and save it under the key temp_transaction_id
        And through the query transactionid retrieve param VALUE at position 3 in the row 2 and save it under the key temp_psp_transaction_id
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        And transactionId with $temp_transaction_id in v2/closepayment
        And key with $temp_psp_transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_13 (part 4)
        Given the FLUSSO_CP_13 (part 3) scenario executed successfully
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
        And checks the value $temp_transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value $temp_transaction_id,$temp_transaction_id,$temp_transaction_id of the record at column TRANSACTION_ID of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken,TPAY,$temp_psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query temptransactionid on db nodo_online under macro NewMod1

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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value $temp_transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # FLUSSO_CP_14

    Scenario: FLUSSO_CP_14 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_14 (part 2)
        Given the FLUSSO_CP_14 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

    Scenario: FLUSSO_CP_14 (part 3)
        Given the FLUSSO_CP_14 (part 2) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_14 (part 4)
        Given the FLUSSO_CP_14 (part 3) scenario executed successfully
        And wait 10 seconds for expiration

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

    # FLUSSO_CP_15

    Scenario: FLUSSO_CP_15 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_15 (part 2)
        Given the FLUSSO_CP_15 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_CP_15 (part 3)
        Given the FLUSSO_CP_15 (part 2) scenario executed successfully
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

        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Esito discorde of sendPaymentOutcome response
    @test  
    Scenario: FLUSSO_CP_15 (part 4)
        Given the FLUSSO_CP_15 (part 3) scenario executed successfully
        And outcome with OK in sendPaymentOutcome
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # FLUSSO_CP_16

    Scenario: FLUSSO_CP_16 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_16 (part 2)
        Given the FLUSSO_CP_16 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_CP_16 (part 3)
        Given the FLUSSO_CP_16 (part 2) scenario executed successfully
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value
    @test 
    Scenario: FLUSSO_CP_16 (part 4)
        Given the FLUSSO_CP_16 (part 3) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
        And check faultString is L'esito del pagamento risulta già acquisito dal sistema pagoPA. of sendPaymentOutcome response

    # FLUSSO_CP_17

    Scenario: FLUSSO_CP_17 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_17 (part 2)
        Given the FLUSSO_CP_17 (part 1) scenario executed successfully
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value

    # FLUSSO_CP_18

    Scenario: FLUSSO_CP_18 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_18 (part 2)
        Given the FLUSSO_CP_18 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_CP_18 (part 3)
        Given the FLUSSO_CP_18 (part 2) scenario executed successfully
        And wait 2 seconds for expiration

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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And check value $XML_DB.idChannel is equal to value #canale_IMMEDIATO_MULTIBENEFICIARIO#
        And check value $XML_DB.channelDescription is equal to value WISP
        And check value $XML_DB.paymentMethod is equal to value TPAY
        And check value $XML_DB.fee is equal to value 2.00
        And check value $XML_DB.applicationDate is equal to value $sendPaymentOutcome.applicationDate
        And check value $XML_DB.transferDate is equal to value $sendPaymentOutcome.transferDate
        And check value $XML_DB.key is equal to value $paGetPayment.key
        And check value $XML_DB.value is equal to value $paGetPayment.value
    @test @prova
    Scenario: FLUSSO_CP_18 (part 4)
        Given the FLUSSO_CP_18 (part 3) scenario executed successfully
        And execution query transactionid to get value on the table PM_METADATA, with the columns * under macro NewMod1 with db name nodo_online
        And through the query transactionid retrieve param TRANSACTION_ID at position 1 in the row 0 and save it under the key temp_transaction_id
        And through the query transactionid retrieve param VALUE at position 3 in the row 2 and save it under the key temp_psp_transaction_id
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        And transactionId with $temp_transaction_id in v2/closepayment
        And key with $temp_psp_transaction_id in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response

    # FLUSSO_CP_19

    Scenario: FLUSSO_CP_19 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_19 (part 2)
        Given the FLUSSO_CP_19 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_19 (part 3)
        Given the FLUSSO_CP_19 (part 2) scenario executed successfully
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

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET avanzamentoPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200

    # FLUSSO_CP_20

    Scenario: FLUSSO_CP_20 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_20 (part 2)
        Given the FLUSSO_CP_20 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_20 (part 3)
        Given the FLUSSO_CP_20 (part 2) scenario executed successfully
        And wait 5 seconds for expiration

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And random idempotencyKey having #psp# as idPSP in activateIOPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    # FLUSSO_CP_21

    Scenario: FLUSSO_CP_21 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_21 (part 2)
        Given the FLUSSO_CP_21 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_21 (part 3)
        Given the FLUSSO_CP_21 (part 2) scenario executed successfully
        And wait 5 seconds for expiration

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response

    # FLUSSO_CP_22

    Scenario: FLUSSO_CP_22 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment with paGetPayment KO scenario executed successfully
        And execution query select_activateio to get value on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve param PAYMENT_TOKEN at position 0 and save it under the key temp_payment_token
        When PM sends REST GET informazioniPagamento?idPagamento=$temp_payment_token to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 404
        And check error is Il pagamento non esiste of informazioniPagamento response

    Scenario: FLUSSO_CP_22 (part 2)
        Given the FLUSSO_CP_22 (part 1) scenario executed successfully
        And the closePaymentV2 with arbitrary paymentToken request scenario executed successfully
        And paymentToken with $temp_payment_token in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is The indicated payment does not exist of v2/closepayment response
    @test  
    Scenario: FLUSSO_CP_22 (part 3)
        Given the FLUSSO_CP_22 (part 2) scenario executed successfully
        And the sendPaymentOutcome with arbitrary paymentToken request scenario executed successfully
        And paymentToken with $temp_payment_token in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response

    # FLUSSO_CP_23

    Scenario: FLUSSO_CP_23 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment with paGetPayment KO scenario executed successfully
        And execution query select_activateio to get value on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activateio retrieve param PAYMENT_TOKEN at position 0 and save it under the key temp_payment_token
        When PM sends REST GET informazioniPagamento?idPagamento=$temp_payment_token to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 404
        And check error is Il pagamento non esiste of informazioniPagamento response

    Scenario: FLUSSO_CP_23 (part 2)
        Given the FLUSSO_CP_23 (part 1) scenario executed successfully
        And the closePaymentV2 with arbitrary paymentToken request scenario executed successfully
        And paymentToken with $temp_payment_token in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is The indicated payment does not exist of v2/closepayment response
    @test  
    Scenario: FLUSSO_CP_23 (part 3)
        Given the FLUSSO_CP_23 (part 2) scenario executed successfully
        And the sendPaymentOutcome with arbitrary paymentToken request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        And paymentToken with $temp_payment_token in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response

    # FLUSSO_CP_24

    Scenario: FLUSSO_CP_24 (part 1)
        Given current date generation
        And the verifyPaymentNotice scenario executed successfully
        And the activateIOPayment scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        When PM sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200

    Scenario: FLUSSO_CP_24 (part 2)
        Given the FLUSSO_CP_24 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        And idPSP with None in v2/closepayment
        And paymentMethod with None in v2/closepayment
        And idBrokerPSP with None in v2/closepayment
        And idChannel with None in v2/closepayment
        And transactionId with None in v2/closepayment
        And totalAmount with None in v2/closepayment
        And fee with None in v2/closepayment
        And timestampOperation with None in v2/closepayment
        And additionalPaymentInformations with None in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test 
    Scenario: FLUSSO_CP_24 (part 3)
        Given the FLUSSO_CP_24 (part 2) scenario executed successfully
        And wait 5 seconds for expiration

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1

        And the sendPaymentOutcome request scenario executed successfully
        And outcome with KO in sendPaymentOutcome
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcome response
        And check description is token unknown of sendPaymentOutcome response

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

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
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
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And verify 0 record for the table POSITION_SUBJECT retrived by the query position_subject_spo on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query select_activateio on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activateIOPaymentResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1
        And checks the value $activateIOPayment.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query select_activateio on db nodo_online under macro NewMod1