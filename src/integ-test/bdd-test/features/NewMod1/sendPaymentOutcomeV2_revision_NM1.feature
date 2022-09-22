Feature: revision checks for sendPaymentOutcomeV2

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
                "timestampOperation": "2033-04-23T18:25:43Z",
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

    # REV_SPO_03

    Scenario: REV_SPO_03 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

    Scenario: REV_SPO_03 (part 2)
        Given the REV_SPO_03 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 5 seconds for expiration

    Scenario: REV_SPO_03 (part 3)
        Given the REV_SPO_03 (part 2) scenario executed successfully
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        # And checks the value NotNone of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value $sendPaymentOutcomeV2.e-mail of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        # And verify 1 record for the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
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
        And checks the value $v2/closepayment.transactionId of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_PAYMENT of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value test of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value company of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value office of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
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
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.idChannel of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $paGetPayment.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RECEIPT_XML of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NOTICE_GENERATED,NOTICE_SENT,NOTIFIED,None of the record at column STATUS of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

# REV_SPO_04

# Scenario: REV_SPO_04 (part 1)
#     Given the activatePaymentNoticeV2 scenario executed successfully
#     And amount with 3.00 in activatePaymentNoticeV2
#     When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of activatePaymentNoticeV2 response
#     And save activatePaymentNoticeV2 response in activatePaymentNoticeV2Response

# Scenario: REV_SPO_04 (part 2)
#     Given the REV_SPO_04 (part 1) scenario executed successfully
#     And the closePaymentV2 scenario executed successfully
#     And totalAmount with 5.00 in closePaymentV2
#     When PM sends closePaymentV2 to nodo-dei-pagamenti
#     Then check outcome is OK of closePaymentV2 response
#     And check faultCode is 200 of closePaymentV2 response
#     And wait 25 seconds for expiration

# Scenario: REV_SPO_04 (part 3)
#     Given the REV_SPO_04 (part 2) scenario executed successfully
#     And the sendPaymentOutcomeV2 scenario executed successfully
#     When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
#     Then check outcome is OK of sendPaymentOutcomeV2 response
#     And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
#     And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1



#              "position_subject": "SELECT columns FROM table_name WHERE ENTITY_UNIQUE_IDENTIFIER_VALUE = '$sendPaymentOutcomeV2.entityUniqueIdentifierValue' and INSERTED_TIMESTAMP > TO_DATE ('$date','YYYY-MM-DD HH24:MI:SS')"}