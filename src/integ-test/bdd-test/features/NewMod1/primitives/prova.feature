Feature: syntax checks for closePaymentV2 outcome OK

    Background:
        Given systems up

    # No error with fee 0 [SIN_CPV2_31.2]
    Scenario: activatePaymentNoticeV2
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
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>302#iuv#</noticeNumber>
            </qrCode>
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
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>66666666666</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>3.00</transferAmount>
            <fiscalCodePA>66666666666</fiscalCodePA>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>testPaGetPayment</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            </transfer>
            <transfer>
            <idTransfer>3</idTransfer>
            <transferAmount>4.00</transferAmount>
            <fiscalCodePA>66666666666</fiscalCodePA>
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

    Scenario: closePaymentV2
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_versione_primitive_2#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "#psp_transaction_id#"
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
                    },
                    "walletItem": {
                        "idWallet": 1234,
                        "walletType": "CARD",
                        "enableableFunctions": [],
                        "pagoPa": false,
                        "onboardingChannel": "",
                        "favourite": false,
                        "createDate": "",
                        "info": {
                            "type": "",
                            "blurredNumber": "",
                            "holder": "Mario Rossi",
                            "expireMonth": "",
                            "expireYear": "",
                            "brand": "",
                            "issuerAbi": "",
                            "issuerName": "Intesa",
                            "label": "********234"
                        },
                        "authRequest": {
                            "authOutcome": "KO",
                            "guid": "77e1c83b-7bb0-437b-bc50-a7a58e5660ac",
                            "correlationId": "f864d987-3ae2-44a3-bdcb-075554495841",
                            "error": "Not Authorized",
                            "auth_code": "99"
                        }
                    }
                }
            }
            """

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

    Scenario: check activatePaymentNoticeV2 OK
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response


    Scenario: check closePaymentV2 OK
        Given the check activatePaymentNoticeV2 OK scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    @test
    Scenario: check spo ok
        Given the check closePaymentV2 OK scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 scenario executed successfully
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response