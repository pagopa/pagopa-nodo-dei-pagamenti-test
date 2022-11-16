Feature: flow tests for sendPaymentResultV2

    Background:
        Given systems up

    @skip
    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "310#iuv#"
                    }
                ]
            }
            """
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    @skip
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

    @skip
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
            <!--Optional:-->
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

    @skip
    Scenario: closePaymentV2 request
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

    @skip
    Scenario: closePaymentV2 request with 2 paymentToken
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

    @skip
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

    # FLUSSO_SPR_01

    Scenario: FLUSSO_SPR_01 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_01 (part 2)
        Given the FLUSSO_SPR_01 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_01 (part 3)
        Given the FLUSSO_SPR_01 (part 2) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_02

    Scenario: FLUSSO_SPR_02 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_02 (part 2)
        Given the FLUSSO_SPR_02 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_02 (part 3)
        Given the FLUSSO_SPR_02 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_02 (part 4)
        Given the FLUSSO_SPR_02 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_03

    Scenario: FLUSSO_SPR_03 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_03 (part 2)
        Given the FLUSSO_SPR_03 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_03 (part 3)
        Given the FLUSSO_SPR_03 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_03 (part 4)
        Given the FLUSSO_SPR_03 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_04

    Scenario: FLUSSO_SPR_04 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_04 (part 2)
        Given the FLUSSO_SPR_04 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_04 (part 3)
        Given the FLUSSO_SPR_04 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    # aggiungere DB check

    # FLUSSO_SPR_05

    Scenario: FLUSSO_SPR_05 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_05 (part 2)
        Given the FLUSSO_SPR_05 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_05 (part 3)
        Given the FLUSSO_SPR_05 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    # aggiungere DB check

    # FLUSSO_SPR_06

    Scenario: FLUSSO_SPR_06 (part 1)
        Given nodo-dei-pagamenti DEV has config parameter default_durata_estensione_token_IO set to 1000
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_06 (part 2)
        Given the FLUSSO_SPR_06 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_06 (part 3)
        Given the FLUSSO_SPR_06 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_06 (part 4)
        Given the FLUSSO_SPR_06 (part 3) scenario executed successfully
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 5 seconds for expiration
        And nodo-dei-pagamenti DEV has config parameter default_durata_estensione_token_IO set to 3600000

    # aggiungere DB check

    # FLUSSO_SPR_07

    Scenario: FLUSSO_SPR_07 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 3000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_07 (part 2)
        Given the FLUSSO_SPR_07 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_07 (part 3)
        Given the FLUSSO_SPR_07 (part 2) scenario executed successfully
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

    Scenario: FLUSSO_SPR_07 (part 4)
        Given the FLUSSO_SPR_07 (part 3) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_08

    Scenario: FLUSSO_SPR_08 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with 3000 in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_08 (part 2)
        Given the FLUSSO_SPR_08 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_08 (part 3)
        Given the FLUSSO_SPR_08 (part 2) scenario executed successfully
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200

    Scenario: FLUSSO_SPR_08 (part 4)
        Given the FLUSSO_SPR_08 (part 3) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_09

    Scenario: FLUSSO_SPR_09 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_09 (part 2)
        Given the FLUSSO_SPR_09 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_09 (part 3)
        Given the FLUSSO_SPR_09 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        And transactionId with resSPR_400 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_09 (part 4)
        Given the FLUSSO_SPR_09 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_10

    Scenario: FLUSSO_SPR_10 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_10 (part 2)
        Given the FLUSSO_SPR_10 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_10 (part 3)
        Given the FLUSSO_SPR_10 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        And transactionId with resSPR_404 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_10 (part 4)
        Given the FLUSSO_SPR_10 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_11

    Scenario: FLUSSO_SPR_11 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_11 (part 2)
        Given the FLUSSO_SPR_11 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_11 (part 3)
        Given the FLUSSO_SPR_11 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        And transactionId with resSPR_408 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_11 (part 4)
        Given the FLUSSO_SPR_11 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

    # aggiungere DB check

    # FLUSSO_SPR_12

    Scenario: FLUSSO_SPR_12 (part 1)
        Given the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And expirationTime with None in activatePaymentNoticeV2
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

    Scenario: FLUSSO_SPR_12 (part 2)
        Given the FLUSSO_SPR_12 (part 1) scenario executed successfully
        And random idempotencyKey having $activatePaymentNoticeV2.idPSP as idPSP in activatePaymentNoticeV2
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2New

    Scenario: FLUSSO_SPR_12 (part 3)
        Given the FLUSSO_SPR_12 (part 2) scenario executed successfully
        And the closePaymentV2 request with 2 paymentToken scenario executed successfully
        And transactionId with resSPR_422 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    Scenario: FLUSSO_SPR_12 (part 4)
        Given the FLUSSO_SPR_12 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request with 2 paymentToken scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration

# aggiungere DB check