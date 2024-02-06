Feature: flow checks for mod3CancelV2 in NM1 937

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

    Scenario: activatePaymentNoticeV2
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
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>310$iuv</noticeNumber>
            </qrCode>
            <expirationTime>120000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
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

    Scenario: pspNotifyPaymentV2 timeout
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

    Scenario: pspNotifyPaymentV2 malformata
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

    Scenario: sendPaymentOutcomeV2
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

    # FLUSSO_NM1_M3CV2_01
    Scenario: FLUSSO_NM1_M3CV2_01 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1

    Scenario: FLUSSO_NM1_M3CV2_01 (part 2)
        Given the FLUSSO_NM1_M3CV2_01 (part 1) scenario executed successfully
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
    @test
    Scenario: FLUSSO_NM1_M3CV2_01 (part 3)
        Given the FLUSSO_NM1_M3CV2_01 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1


    # FLUSSO_NM1_M3CV2_02
    Scenario: FLUSSO_NM1_M3CV2_02 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1

    Scenario: FLUSSO_NM1_M3CV2_02 (part 2)
        Given the FLUSSO_NM1_M3CV2_02 (part 1) scenario executed successfully
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
    @test
    Scenario: FLUSSO_NM1_M3CV2_02 (part 3)
        Given the FLUSSO_NM1_M3CV2_02 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 malformata scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1


    # FLUSSO_NM1_M3CV2_03
    Scenario: FLUSSO_NM1_M3CV2_03 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1

    Scenario: FLUSSO_NM1_M3CV2_03 (part 2)
        Given the FLUSSO_NM1_M3CV2_03 (part 1) scenario executed successfully
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2

    Scenario: FLUSSO_NM1_M3CV2_03 (part 3)
        Given the FLUSSO_NM1_M3CV2_03 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
    @test
    Scenario: FLUSSO_NM1_M3CV2_03 (part 4)
        Given the FLUSSO_NM1_M3CV2_03 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 0 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1


    # FLUSSO_NM1_M3CV2_04
    Scenario: FLUSSO_NM1_M3CV2_04 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1

    Scenario: FLUSSO_NM1_M3CV2_04 (part 2)
        Given the FLUSSO_NM1_M3CV2_04 (part 1) scenario executed successfully
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2

    Scenario: FLUSSO_NM1_M3CV2_04 (part 3)
        Given the FLUSSO_NM1_M3CV2_04 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
    @test
    Scenario: FLUSSO_NM1_M3CV2_04 (part 4)
        Given the FLUSSO_NM1_M3CV2_04 (part 3) scenario executed successfully
        When job mod3CancelV2 triggered after 0 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1


    # FLUSSO_NM1_M3CV2_05
    Scenario: FLUSSO_NM1_M3CV2_05 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 16000
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1

    Scenario: FLUSSO_NM1_M3CV2_05 (part 2)
        Given the FLUSSO_NM1_M3CV2_05 (part 1) scenario executed successfully
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2

    Scenario: FLUSSO_NM1_M3CV2_05 (part 3)
        Given the FLUSSO_NM1_M3CV2_05 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
    @test
    Scenario: FLUSSO_NM1_M3CV2_05 (part 4)
        Given the FLUSSO_NM1_M3CV2_05 (part 3) scenario executed successfully
        When job mod3CancelV2 triggered after 2 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        # NMU_CANCEL_UTILITY
        And verify 0 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        # POSITION & PAYMENT STATUS
        # attivazione 1
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        # attivazione 2
        And verify 2 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # FLUSSO_NM1_M3CV2_06
    Scenario: FLUSSO_NM1_M3CV2_06 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 16000
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1

    Scenario: FLUSSO_NM1_M3CV2_06 (part 2)
        Given the FLUSSO_NM1_M3CV2_06 (part 1) scenario executed successfully
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2

    Scenario: FLUSSO_NM1_M3CV2_06 (part 3)
        Given the FLUSSO_NM1_M3CV2_06 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
    @test
    Scenario: FLUSSO_NM1_M3CV2_06 (part 4)
        Given the FLUSSO_NM1_M3CV2_06 (part 3) scenario executed successfully
        And updates through the query update_noticeid_pa_ver2 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
        And updates through the query update_noticeid1_pa_ver2 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        # NMU_CANCEL_UTILITY
        And verify 0 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        # POSITION & PAYMENT STATUS
        # attivazione 1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        # attivazione 2
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1


    # FLUSSO_NM1_M3CV2_07
    Scenario: FLUSSO_NM1_M3CV2_07 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 16000
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1

    Scenario: FLUSSO_NM1_M3CV2_07 (part 2)
        Given the FLUSSO_NM1_M3CV2_07 (part 1) scenario executed successfully
        And noticeNumber with 310$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 10$iuv1 in paGetPaymentV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2

    Scenario: FLUSSO_NM1_M3CV2_07 (part 3)
        Given the FLUSSO_NM1_M3CV2_07 (part 2) scenario executed successfully
        And the pspNotifyPaymentV2 timeout scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
    @test
    Scenario: FLUSSO_NM1_M3CV2_07 (part 4)
        Given the FLUSSO_NM1_M3CV2_07 (part 3) scenario executed successfully
        And updates through the query update_noticeid_pa_ver2 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 3 seconds for expiration
        And nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 3600000
        # NMU_CANCEL_UTILITY
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And under macro NewMod1 on db nodo_online with the query transactionid verify the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKENS of table NMU_CANCEL_UTILITY
        And checks the value 2 of the record at column NUM_TOKEN of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And execution query transactionid to get value on the table NMU_CANCEL_UTILITY, with the columns VALID_TO under macro NewMod1 with db name nodo_online
        And execution query select_activatev2 to get value on the table POSITION_ACTIVATE, with the columns TOKEN_VALID_TO under macro NewMod1 with db name nodo_online
        And with the query transactionid check assert beetwen elem VALID_TO in position 0 and elem TOKEN_VALID_TO with position 0 of the query select_activatev2
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2 of the record at column INSERTED_BY of the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1
        # POSITION & PAYMENT STATUS
        # attivazione 1
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        And checks the value PAID of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2_1 on db nodo_online under macro NewMod1
        # attivazione 2
        And verify 1 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYMENT_UNKNOWN of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1