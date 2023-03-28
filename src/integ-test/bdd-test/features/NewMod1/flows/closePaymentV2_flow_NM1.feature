Feature: flow tests for closePaymentV2

    Background:
        Given systems up

    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "302#iuv#"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "302#iuv1#"
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
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
            <noticeNumber>302$iuv</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
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
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
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

    Scenario: paGetPayment KO
        Given initial XML paGetPayment
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

    Scenario: closePaymentV2 with 2 paymentToken request
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2_1Response.paymentToken",
                    "$activatePaymentNoticeV2_2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 22,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """

    Scenario: closePaymentV2 request
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2_1Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """

    Scenario: closePaymentV2 with 3 paymentToken request
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2_1Response.paymentToken",
                    "$activatePaymentNoticeV2_2Response.paymentToken",
                    "1hf395ksn50snc3xpajk5ls0nd4jskfd"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 22,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """

    Scenario: closePaymentV2 with 2 paymentToken (1 from DB) request
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$tokenDB",
                    "$activatePaymentNoticeV2_2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 22,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
                }
            }
            """

    Scenario: activatePaymentNoticeV2 with iuv
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And idempotencyKey with None in activatePaymentNoticeV2
        And expirationTime with None in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPayment request in paGetPayment_1Request

    Scenario: activatePaymentNoticeV2 with iuv1
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And idempotencyKey with None in activatePaymentNoticeV2
        And expirationTime with None in activatePaymentNoticeV2
        And noticeNumber with 302$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 02$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPayment request in paGetPayment_2Request

    Scenario: activatePaymentNoticeV2 with iuv and idempotencyKey
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: activatePaymentNoticeV2 with iuv and paGetPayment KO
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And idempotencyKey with None in activatePaymentNoticeV2
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPayment KO scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request

    Scenario: activatePaymentNoticeV2 with iuv1 and expirationTime
        Given the activatePaymentNoticeV2 request scenario executed successfully
        And idempotencyKey with None in activatePaymentNoticeV2
        And noticeNumber with 302$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 02$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPayment request in paGetPayment_2Request

    # FLUSSO_NM1_CP_01

    Scenario: FLUSSO_NM1_CP_01 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test @giovanni
    Scenario: FLUSSO_NM1_CP_01 (part 2)
        Given the FLUSSO_NM1_CP_01 (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYMENT_ACCEPTED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        # PM_METADATA
        And checks the value Token,Token,Tipo versamento,key of the record at column KEY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,TPAY,$psp_transaction_id of the record at column VALUE of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2 of the record at column INSERTED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1
        And checks the value closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2 of the record at column UPDATED_BY of the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

    # FLUSSO_NM1_CP_02

    Scenario: FLUSSO_NM1_CP_02 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test
    Scenario: FLUSSO_NM1_CP_02 (part 2)
        Given the FLUSSO_NM1_CP_02 (part 1) scenario executed successfully
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

    # FLUSSO_NM1_CP_03

    Scenario: FLUSSO_NM1_CP_03 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test
    Scenario: FLUSSO_NM1_CP_03 (part 2)
        Given the FLUSSO_NM1_CP_03 (part 1) scenario executed successfully
        And wait 2 seconds for expiration
        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response

    # FLUSSO_NM1_CP_03.1

    Scenario: FLUSSO_NM1_CP_03.1 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test
    Scenario: FLUSSO_NM1_CP_03.1 (part 2)
        Given the FLUSSO_NM1_CP_03.1 (part 1) scenario executed successfully
        And wait 2 seconds for expiration
        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response

    # FLUSSO_NM1_CP_03.2

    Scenario: FLUSSO_NM1_CP_03.2 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test
    Scenario: FLUSSO_NM1_CP_03.2 (part 2)
        Given the FLUSSO_NM1_CP_03.2 (part 1) scenario executed successfully
        And wait 2 seconds for expiration
        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response

    # FLUSSO_NM1_CP_03.3

    Scenario: FLUSSO_NM1_CP_03.3 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @test
    Scenario: FLUSSO_NM1_CP_03.3 (part 2)
        Given the FLUSSO_NM1_CP_03.3 (part 1) scenario executed successfully
        And wait 2 seconds for expiration
        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response

    # FLUSSO_NM1_CP_04
    @test
    Scenario: FLUSSO_NM1_CP_04
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 with 3 paymentToken request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is Unknown token of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

    # FLUSSO_NM1_CP_05

    Scenario: FLUSSO_NM1_CP_05 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 and expirationTime scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
    @test
    Scenario: FLUSSO_NM1_CP_05 (part 2)
        Given the FLUSSO_NM1_CP_05 (part 1) scenario executed successfully
        And wait 3 seconds for expiration
        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_STATUS_SNAPSHOT
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione on db nodo_online under macro NewMod1

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1

    # FLUSSO_NM1_CP_06
    @test
    Scenario: FLUSSO_NM1_CP_06
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And the activatePaymentNoticeV2 with iuv scenario executed successfully

    # FLUSSO_NM1_CP_06.1
    @test
    Scenario: FLUSSO_NM1_CP_06.1
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully

        # POSITION_ACTIVATE
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

        And the closePaymentV2 with 2 paymentToken request scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And the activatePaymentNoticeV2 with iuv and idempotencyKey scenario executed successfully

    # FLUSSO_NM1_CP_07
    @test
    Scenario: FLUSSO_NM1_CP_07
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 with iuv and paGetPayment KO scenario executed successfully
        And the activatePaymentNoticeV2 with iuv1 scenario executed successfully
        And execution query notice_id_first_activatev2 to get value on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query notice_id_first_activatev2 retrieve param PAYMENT_TOKEN at position 0 and save it under the key tokenDB
        And the closePaymentV2 with 2 paymentToken (1 from DB) request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response