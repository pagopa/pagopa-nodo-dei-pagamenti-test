Feature: flow tests for sendPaymentResultV2

    Background:
        Given systems up

    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "310#iuv#"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "310#iuv1#"
                    }
                ]
            }
            """
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: activatePaymentNoticeV2 request
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 response
        Given initial XML paGetPaymentV2
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
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
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

    Scenario: closePaymentV2 request
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2_1Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                }
            }
            """

    Scenario: closePaymentV2 request with 2 paymentToken
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2_1Response.paymentToken",
                    "$activatePaymentNoticeV2_2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "transactionId": "#transaction_id#",
                "totalAmount": 22,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                }
            }
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
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken>
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

    Scenario: sendPaymentOutcomeV2 request with 2 paymentToken
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
            <paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken>
            <paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken>
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

    # FLUSSO_SPR_01

    Scenario: FLUSSO_SPR_01 (part 1)
        Given current date generation
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1

    Scenario: FLUSSO_SPR_01 (part 2)
        Given the FLUSSO_SPR_01 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @company
    Scenario: FLUSSO_SPR_01 (part 3)
        Given the FLUSSO_SPR_01 (part 2) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE.paymentToken is equal to value $activatePaymentNoticeV2_1Response.paymentToken
        And checking value $XML_RE.description is equal to value $paGetPaymentV2.description
        And checking value $XML_RE.fiscalCode is equal to value $activatePaymentNoticeV2.fiscalCode
        And checking value $XML_RE.companyName is equal to value $paGetPaymentV2.companyName
        And checking value $XML_RE.debtor is equal to value $paGetPaymentV2.entityUniqueIdentifierValue
        And checking value $XML_RE.officeName is equal to value $paGetPaymentV2.officeName

    # FLUSSO_SPR_02

    Scenario: FLUSSO_SPR_02 (part 1)
        Given current date generation
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request

    Scenario: FLUSSO_SPR_02 (part 2)
        Given the FLUSSO_SPR_02 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request

    Scenario: FLUSSO_SPR_02 (part 3)
        Given the FLUSSO_SPR_02 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @company
    Scenario: FLUSSO_SPR_02 (part 4)
        Given the FLUSSO_SPR_02 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

    # FLUSSO_SPR_03

    Scenario: FLUSSO_SPR_03 (part 1)
        Given current date generation
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request

    Scenario: FLUSSO_SPR_03 (part 2)
        Given the FLUSSO_SPR_03 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request

    Scenario: FLUSSO_SPR_03 (part 3)
        Given the FLUSSO_SPR_03 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @company
    Scenario: FLUSSO_SPR_03 (part 4)
        Given the FLUSSO_SPR_03 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_SUBJECT
        And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_RECIPIENT_STATUS
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value OK
        And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

    # FLUSSO_SPR_04

    Scenario: FLUSSO_SPR_04 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request

    Scenario: FLUSSO_SPR_04 (part 2)
        Given the FLUSSO_SPR_04 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request

    @test 
    Scenario: FLUSSO_SPR_04 (part 3)
        Given the FLUSSO_SPR_04 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 KO response scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activatev2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activatev2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

    # FLUSSO_SPR_05

    Scenario: FLUSSO_SPR_05 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request

    Scenario: FLUSSO_SPR_05 (part 2)
        Given the FLUSSO_SPR_05 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
    @test @company
    Scenario: FLUSSO_SPR_05 (part 3)
        Given the FLUSSO_SPR_05 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 irraggiungibile response scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activatev2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activatev2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

    # FLUSSO_SPR_06

    Scenario: FLUSSO_SPR_06 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request

    Scenario: FLUSSO_SPR_06 (part 2)
        Given the FLUSSO_SPR_06 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request

    Scenario: FLUSSO_SPR_06 (part 3)
        Given the FLUSSO_SPR_06 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 malformata response scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @company
    Scenario: FLUSSO_SPR_06 (part 4)
        Given the FLUSSO_SPR_06 (part 3) scenario executed successfully
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 5 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And execution query sprv2_req_activatev2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
        And through the query sprv2_req_activatev2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
        And checking value $XML_RE.outcome is equal to value KO
        And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

    # FLUSSO_SPR_07

    Scenario: FLUSSO_SPR_07 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 3000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request

    Scenario: FLUSSO_SPR_07 (part 2)
        Given the FLUSSO_SPR_07 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request

    Scenario: FLUSSO_SPR_07 (part 3)
        Given the FLUSSO_SPR_07 (part 2) scenario executed successfully
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test @company
    Scenario: FLUSSO_SPR_07 (part 4)
        Given the FLUSSO_SPR_07 (part 3) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activatev2 on db re under macro NewMod1

    # FLUSSO_SPR_08

    Scenario: FLUSSO_SPR_08 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 3000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request

    Scenario: FLUSSO_SPR_08 (part 2)
        Given the FLUSSO_SPR_08 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request

    Scenario: FLUSSO_SPR_08 (part 3)
        Given the FLUSSO_SPR_08 (part 2) scenario executed successfully
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test @company
    Scenario: FLUSSO_SPR_08 (part 4)
        Given the FLUSSO_SPR_08 (part 3) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RE
        And verify 0 record for the table RE retrived by the query sprv2_req_activatev2 on db re under macro NewMod1

# i seguenti test sono commentati perché risultano essere validi soltanto in DEV, dove è presente il mock PM, al quale si può richiedere una response particolare della sendPaymentResult-v2 tramite manipolazione del transactionId nella closePayment-v2,
# mentre risultano essere out of scope in SIT, dove è presente il PM al quale non si può richiedere una response particolare per la sendPaymentResult-v2

# # FLUSSO_SPR_09

# Scenario: FLUSSO_SPR_09 (part 1)
#     Given current date generation
#     And the checkPosition scenario executed successfully
#     And the activatePaymentNoticeV2 request scenario executed successfully
#     And expirationTime with None in activatePaymentNoticeV2
#     And the paGetPaymentV2 response scenario executed successfully
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
#     And saving paGetPaymentV2 request in paGetPaymentV2_1Request

# Scenario: FLUSSO_SPR_09 (part 2)
#     Given the FLUSSO_SPR_09 (part 1) scenario executed successfully
#     And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
#     And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
#     And creditorReferenceId with 10$iuv1 in paGetPaymentV2
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
#     And saving paGetPaymentV2 request in paGetPaymentV2_2Request

# Scenario: FLUSSO_SPR_09 (part 3)
#     Given the FLUSSO_SPR_09 (part 2) scenario executed successfully
#     And the closePaymentV2 request with 2 paymentToken scenario executed successfully
#     And transactionId with resSPR_400_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response
# @test
# Scenario: FLUSSO_SPR_09 (part 4)
#     Given the FLUSSO_SPR_09 (part 3) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
#     When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of sendPaymentOutcomeV2 response
#     And wait 5 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_SUBJECT
#     And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT
#     And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
#     And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value resSPR_400_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_XML
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT_STATUS
#     And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

# # FLUSSO_SPR_10

# Scenario: FLUSSO_SPR_10 (part 1)
#     Given current date generation
#     And the checkPosition scenario executed successfully
#     And the activatePaymentNoticeV2 request scenario executed successfully
#     And expirationTime with None in activatePaymentNoticeV2
#     And the paGetPaymentV2 response scenario executed successfully
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
#     And saving paGetPaymentV2 request in paGetPaymentV2_1Request

# Scenario: FLUSSO_SPR_10 (part 2)
#     Given the FLUSSO_SPR_10 (part 1) scenario executed successfully
#     And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
#     And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
#     And creditorReferenceId with 10$iuv1 in paGetPaymentV2
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
#     And saving paGetPaymentV2 request in paGetPaymentV2_2Request

# Scenario: FLUSSO_SPR_10 (part 3)
#     Given the FLUSSO_SPR_10 (part 2) scenario executed successfully
#     And the closePaymentV2 request with 2 paymentToken scenario executed successfully
#     And transactionId with resSPR_404_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response
# @test
# Scenario: FLUSSO_SPR_10 (part 4)
#     Given the FLUSSO_SPR_10 (part 3) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
#     When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of sendPaymentOutcomeV2 response
#     And wait 5 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_SUBJECT
#     And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT
#     And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
#     And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value resSPR_404_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_XML
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT_STATUS
#     And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

# # FLUSSO_SPR_11

# Scenario: FLUSSO_SPR_11 (part 1)
#     Given current date generation
#     And the checkPosition scenario executed successfully
#     And the activatePaymentNoticeV2 request scenario executed successfully
#     And expirationTime with None in activatePaymentNoticeV2
#     And the paGetPaymentV2 response scenario executed successfully
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
#     And saving paGetPaymentV2 request in paGetPaymentV2_1Request

# Scenario: FLUSSO_SPR_11 (part 2)
#     Given the FLUSSO_SPR_11 (part 1) scenario executed successfully
#     And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
#     And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
#     And creditorReferenceId with 10$iuv1 in paGetPaymentV2
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
#     And saving paGetPaymentV2 request in paGetPaymentV2_2Request

# Scenario: FLUSSO_SPR_11 (part 3)
#     Given the FLUSSO_SPR_11 (part 2) scenario executed successfully
#     And the closePaymentV2 request with 2 paymentToken scenario executed successfully
#     And transactionId with resSPR_408_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response
# @test
# Scenario: FLUSSO_SPR_11 (part 4)
#     Given the FLUSSO_SPR_11 (part 3) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
#     When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of sendPaymentOutcomeV2 response
#     And wait 5 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_SUBJECT
#     And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT
#     And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
#     And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value resSPR_408_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_XML
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT_STATUS
#     And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>

# # FLUSSO_SPR_12

# Scenario: FLUSSO_SPR_12 (part 1)
#     Given current date generation
#     And the checkPosition scenario executed successfully
#     And the activatePaymentNoticeV2 request scenario executed successfully
#     And expirationTime with None in activatePaymentNoticeV2
#     And the paGetPaymentV2 response scenario executed successfully
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
#     And saving paGetPaymentV2 request in paGetPaymentV2_1Request

# Scenario: FLUSSO_SPR_12 (part 2)
#     Given the FLUSSO_SPR_12 (part 1) scenario executed successfully
#     And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
#     And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
#     And creditorReferenceId with 10$iuv1 in paGetPaymentV2
#     And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#     When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
#     And saving paGetPaymentV2 request in paGetPaymentV2_2Request

# Scenario: FLUSSO_SPR_12 (part 3)
#     Given the FLUSSO_SPR_12 (part 2) scenario executed successfully
#     And the closePaymentV2 request with 2 paymentToken scenario executed successfully
#     And transactionId with resSPR_422_$transaction_id in v2/closepayment
#     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#     Then verify the HTTP status code of v2/closepayment response is 200
#     And check outcome is OK of v2/closepayment response
# @test
# Scenario: FLUSSO_SPR_12 (part 4)
#     Given the FLUSSO_SPR_12 (part 3) scenario executed successfully
#     And wait 5 seconds for expiration
#     And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
#     When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of sendPaymentOutcomeV2 response
#     And wait 5 seconds for expiration

#     # POSITION_PAYMENT_STATUS
#     And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS
#     And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_STATUS_SNAPSHOT
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_SUBJECT
#     And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value prova@test.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1

#     # POSITION_PAYMENT
#     And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     #Colonna FEE_SPO: PAG-2154 Gestione fee da closePayment/sendPaymentOutcome
#     And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE_SPO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value resSPR_422_$transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.description of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.companyName of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.officeName of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value 2 of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_XML
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT
#     And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $paGetPaymentV2.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value #stazione_versione_primitive_2# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # POSITION_RECEIPT_RECIPIENT_STATUS
#     And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

#     # RE
#     And execution query sprv2_req_spov2 to get value on the table RE, with the columns PAYLOAD under macro NewMod1 with db name re
#     And through the query sprv2_req_spov2 convert json PAYLOAD at position 0 to xml and save it under the key XML_RE
#     And checking value $XML_RE.outcome is equal to value OK
#     And checking value $XML_RE is containing value <payments><payment><paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_1Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment><payment><paymentToken>$activatePaymentNoticeV2_2Response.paymentToken</paymentToken><description>$paGetPaymentV2.description</description><fiscalCode>$activatePaymentNoticeV2.fiscalCode</fiscalCode><creditorReferenceId>$paGetPaymentV2_2Request.creditorReferenceId</creditorReferenceId><companyName>$paGetPaymentV2.companyName</companyName><debtor>$paGetPaymentV2.entityUniqueIdentifierValue</debtor><officeName>$paGetPaymentV2.officeName</officeName></payment></payments>