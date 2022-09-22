Feature: flux / semantic checks for sendPaymentOutcomeV2

    Background:
        Given systems up

    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "311#iuv#"
                    },
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "311#iuv1#"
                    }
                ]
            }
            """
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    @skip
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
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
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
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                }
            }
            """

    @skip
    Scenario: closePaymentV2 with 2 paymentToken
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2Response.paymentToken",
                    "$activatePaymentNoticeV2NewResponse.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "transactionId": "#transaction_id#",
                "totalAmount": 22,
                "fee": 2,
                "timestampOperation": "2012-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
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

    @skip
    Scenario: sendPaymentOutcomeV2 with 2 paymentToken
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
            <paymentToken>$activatePaymentNoticeV2NewResponse.paymentToken</paymentToken>
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

    # SEM_SPO_7.1

    # Scenario: SEM_SPO_7.1
    #     Given idChannel with 70000000001_08 in sendPaymentOutcomeV2
    #     When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    #     Then check outcome is OK of sendPaymentOutcomeV2 response

    # SEM_SPO_9.1

    Scenario: SEM_SPO_9.1 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_9.1 (part 2)
        Given the SEM_SPO_9.1 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_9.1 (part 3)
        Given the SEM_SPO_9.1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: SEM_SPO_9.1 (part 4)
        Given the SEM_SPO_9.1 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response

    # SEM_SPO_13
    @wip
    Scenario: SEM_SPO_13 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And updates through the query update_activatev2 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
        And updates through the query update_activatev2 of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online
    @wip
    Scenario: SEM_SPO_13 (part 2)
        Given the SEM_SPO_13 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
    @wip
    Scenario: SEM_SPO_13 (part 3)
        Given the SEM_SPO_13 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And paymentToken with $activatePaymentNoticeV2_2Response.paymentToken in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
    @wip
    Scenario: SEM_SPO_13 (part 4)
        Given the SEM_SPO_13 (part 3) scenario executed successfully
        And paymentToken with $activatePaymentNoticeV2_1Response.paymentToken in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

    # SEM_SPO_13.1

    Scenario: SEM_SPO_13.1 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And updates through the query update_activatev2 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
        And updates through the query update_activatev2 of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_13.1 (part 2)
        Given the SEM_SPO_13.1 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_13.1 (part 3)
        Given the SEM_SPO_13.1 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

    # SEM_SPO_21

    Scenario: SEM_SPO_21 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_21 (part 2)
        Given the SEM_SPO_21 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: SEM_SPO_21 (part 3)
        Given the SEM_SPO_21 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    # SEM_SPO_23

    Scenario: SEM_SPO_23 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_23 (part 2)
        Given the SEM_SPO_23 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: SEM_SPO_23 (part 3)
        Given the SEM_SPO_23 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    Scenario: SEM_SPO_23 (part 4)
        Given the SEM_SPO_23 (part 3) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And check description contains Esito concorde of sendPaymentOutcomeV2 response

    # SEM_SPO_23.1

    Scenario: SEM_SPO_23.1 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_23.1 (part 2)
        Given the SEM_SPO_23.1 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_23.1 (part 3)
        Given the SEM_SPO_23.1 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: SEM_SPO_23.1 (part 4)
        Given the SEM_SPO_23.1 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    Scenario: SEM_SPO_23.1 (part 5)
        Given the SEM_SPO_23.1 (part 4) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And check description contains Esito concorde of sendPaymentOutcomeV2 response

    # SEM_SPO_28

    Scenario: SEM_SPO_28 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_28 (part 2)
        Given the SEM_SPO_28 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: SEM_SPO_28 (part 3)
        Given the SEM_SPO_28 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And outcome with KO in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome KO non accettabile of sendPaymentOutcomeV2 response

    # SEM_SPO_29

    Scenario: SEM_SPO_29 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_29 (part 2)
        Given the SEM_SPO_29 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: SEM_SPO_29 (part 3)
        Given the SEM_SPO_29 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        And fee with 3.00 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response

    # SEM_SPO_30

    Scenario: SEM_SPO_30 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_30 (part 2)
        Given the SEM_SPO_30 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_30 (part 3)
        Given the SEM_SPO_30 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: SEM_SPO_30 (part 4)
        Given the SEM_SPO_30 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT the parameter OUTCOME with OO under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_30 (part 5)
        Given the SEM_SPO_30 (part 4) scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Esiti acquisiti parziali o discordi of sendPaymentOutcomeV2 response

    # SEM_SPO_31

    Scenario: SEM_SPO_31 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_31 (part 2)
        Given the SEM_SPO_31 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_31 (part 3)
        Given the SEM_SPO_31 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_activatev2 of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 311011451292109621 under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_31 (part 4)
        Given the SEM_SPO_31 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_SCONOSCIUTO of sendPaymentOutcomeV2 response
        And updates through the query update_noticeidrandom of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with $activatePaymentNoticeV2.noticeNumber under macro NewMod1 on db nodo_online

    # SEM_SPO_32

    Scenario: SEM_SPO_32 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_32 (part 2)
        Given the SEM_SPO_32 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_32 (part 3)
        Given the SEM_SPO_32 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_32 (part 4)
        Given the SEM_SPO_32 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcomeV2 response

    # SEM_SPO_33

    Scenario: SEM_SPO_33 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_33 (part 2)
        Given the SEM_SPO_33 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_33 (part 3)
        Given the SEM_SPO_33 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_ACCEPTED under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_ACCEPTED under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_33 (part 4)
        Given the SEM_SPO_33 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    # SEM_SPO_33.1

    Scenario: SEM_SPO_33.1 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_33.1 (part 2)
        Given the SEM_SPO_33.1 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_33.1 (part 3)
        Given the SEM_SPO_33.1 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_UNKNOWN under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_UNKNOWN under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_33.1 (part 4)
        Given the SEM_SPO_33.1 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And verify 0 record for the table NMU_CANCEL_UTILITY retrived by the query transactionid on db nodo_online under macro NewMod1

    # SEM_SPO_35

    Scenario: SEM_SPO_35 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_35 (part 2)
        Given the SEM_SPO_35 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_35 (part 3)
        Given the SEM_SPO_35 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SENT under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_RESERVED under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_35 (part 4)
        Given the SEM_SPO_35 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_35.1

    Scenario: SEM_SPO_35.1 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_35.1 (part 2)
        Given the SEM_SPO_35.1 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_35.1 (part 3)
        Given the SEM_SPO_35.1 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And wait 5 seconds for expiration
        And check outcome is OK of v2/closepayment response
        And updates through the query update_activatev2 of the table POSITION_STATUS_SNAPSHOT the parameter ACTIVATION_PENDING with Y under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_35.1 (part 4)
        Given the SEM_SPO_35.1 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_35.2

    Scenario: SEM_SPO_35.2 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_35.2 (part 2)
        Given the SEM_SPO_35.2 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_35.2 (part 3)
        Given the SEM_SPO_35.2 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYING under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYING under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_35.2 (part 4)
        Given the SEM_SPO_35.2 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_35.3

    Scenario: SEM_SPO_35.3 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_35.3 (part 2)
        Given the SEM_SPO_35.3 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_35.3 (part 3)
        Given the SEM_SPO_35.3 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_RESERVED under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_RESERVED under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_35.3 (part 4)
        Given the SEM_SPO_35.3 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_35.4

    Scenario: SEM_SPO_35.4 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_35.4 (part 2)
        Given the SEM_SPO_35.4 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_35.4 (part 3)
        Given the SEM_SPO_35.4 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SENT under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SENT under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_35.4 (part 4)
        Given the SEM_SPO_35.4 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_35.5

    Scenario: SEM_SPO_35.5 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_35.5 (part 2)
        Given the SEM_SPO_35.5 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_35.5 (part 3)
        Given the SEM_SPO_35.5 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SEND_ERROR under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_SEND_ERROR under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_35.5 (part 4)
        Given the SEM_SPO_35.5 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_35.6

    Scenario: SEM_SPO_35.6 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_35.6 (part 2)
        Given the SEM_SPO_35.6 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_35.6 (part 3)
        Given the SEM_SPO_35.6 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_REFUSED under macro NewMod1 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYMENT_REFUSED under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_35.6 (part 4)
        Given the SEM_SPO_35.6 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

    # SEM_SPO_36

    Scenario: SEM_SPO_36 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_36 (part 2)
        Given the SEM_SPO_36 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_36 (part 3)
        Given the SEM_SPO_36 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
        And updates through the query update_noticeid1_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_36 (part 4)
        Given the SEM_SPO_36 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

    # SEM_SPO_36.1

    Scenario: SEM_SPO_36.1 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: SEM_SPO_36.1 (part 2)
        Given the SEM_SPO_36.1 (part 1) scenario executed successfully
        And noticeNumber with 311$iuv1 in activatePaymentNoticeV2
        And creditorReferenceId with 11$iuv1 in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: SEM_SPO_36.1 (part 3)
        Given the SEM_SPO_36.1 (part 2) scenario executed successfully
        And the closePaymentV2 with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration
        And updates through the query update_noticeid_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online
        And updates through the query update_noticeid1_pa of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online

    Scenario: SEM_SPO_36.1 (part 4)
        Given the SEM_SPO_36.1 (part 3) scenario executed successfully
        And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response