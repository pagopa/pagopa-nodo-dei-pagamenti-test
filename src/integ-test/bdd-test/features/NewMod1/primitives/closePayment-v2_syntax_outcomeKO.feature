Feature: syntax checks for closePaymentV2 outcome KO

    Background:
        Given systems up

    Scenario: closePaymentV2
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "KO",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
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

    Scenario: check activatePaymentNoticeV2 OK
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV21
    @test @independent
    # No error
    Scenario Outline: check closePaymentV2 OK
        Given the check activatePaymentNoticeV2 OK scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activatePaymentNoticeV21Response.paymentToken in v2/closepayment
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Examples:
            | elem                          | value                                                                                                                                                                                                                                                            | soapUI test   |
            | idPSP                         | None                                                                                                                                                                                                                                                             | SIN_CPV2_07   |
            | idPSP                         | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_08   |
            | idPSP                         | 700000000017000000000170000000001700                                                                                                                                                                                                                             | SIN_CPV2_09   |
            | paymentMethod                 | None                                                                                                                                                                                                                                                             | SIN_CPV2_10   |
            | paymentMethod                 | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_11   |
            | paymentMethod                 | OBEP                                                                                                                                                                                                                                                             | SIN_CPV2_12   |
            | paymentMethod                 | CP                                                                                                                                                                                                                                                               | SIN_CPV2_12   |
            | paymentMethod                 | AD                                                                                                                                                                                                                                                               | PAG-2482      |
            | paymentMethod                 | BBT                                                                                                                                                                                                                                                              | PAG-2482      |
            | paymentMethod                 | BP                                                                                                                                                                                                                                                               | PAG-2482      |
            | paymentMethod                 | PO                                                                                                                                                                                                                                                               | PAG-2482      |
            | paymentMethod                 | JIF                                                                                                                                                                                                                                                              | PAG-2482      |
            | paymentMethod                 | MYBK                                                                                                                                                                                                                                                             | PAG-2482      |
            | paymentMethod                 | BPAY                                                                                                                                                                                                                                                             | PAG-2482      |
            | paymentMethod                 | PPAL                                                                                                                                                                                                                                                             | PAG-2482      |
            | idBrokerPSP                   | None                                                                                                                                                                                                                                                             | SIN_CPV2_13   |
            | idBrokerPSP                   | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_14   |
            | idBrokerPSP                   | 700000000017000000000170000000001700                                                                                                                                                                                                                             | SIN_CPV2_15   |
            | idChannel                     | None                                                                                                                                                                                                                                                             | SIN_CPV2_16   |
            | idChannel                     | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_17   |
            | idChannel                     | 70000000001_0370000000001_0370000000                                                                                                                                                                                                                             | SIN_CPV2_18   |
            | transactionId                 | None                                                                                                                                                                                                                                                             | SIN_CPV2_19   |
            | transactionId                 | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_20   |
            | transactionId                 | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CPV2_21   |
            | totalAmount                   | None                                                                                                                                                                                                                                                             | SIN_CPV2_22   |
            | totalAmount                   | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_23   |
            # | totalAmount                 | 12,21 | SIN_CPV2_24   |    test non eseguibile in python: non sono ammessi dei numeri separati da virgola
            | totalAmount                   | 12.0                                                                                                                                                                                                                                                             | SIN_CPV2_25   |
            | totalAmount                   | 12.321                                                                                                                                                                                                                                                           | SIN_CPV2_25.1 |
            | totalAmount                   | 12                                                                                                                                                                                                                                                               | SIN_CPV2_25.2 |
            | totalAmount                   | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CPV2_26   |
            | fee                           | None                                                                                                                                                                                                                                                             | SIN_CPV2_27   |
            | fee                           | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_28   |
            # | fee                         | 12,32 | SIN_CPV2_29   |    test non eseguibile in python: non sono ammessi dei numeri separati da virgola
            | fee                           | 2.0                                                                                                                                                                                                                                                              | SIN_CPV2_30   |
            | fee                           | 12.321                                                                                                                                                                                                                                                           | SIN_CPV2_30.1 |
            | fee                           | 2                                                                                                                                                                                                                                                                | SIN_CPV2_30.2 |
            | fee                           | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CPV2_31   |
            | fee                           | 20                                                                                                                                                                                                                                                               | SIN_CPV2_31.1 |
            | timestampOperation            | None                                                                                                                                                                                                                                                             | SIN_CPV2_32   |
            | timestampOperation            | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_33   |
            | timestampOperation            | 2012-04-23                                                                                                                                                                                                                                                       | SIN_CPV2_34   |
            | timestampOperation            | 2012-04-23T18:25:43                                                                                                                                                                                                                                              | SIN_CPV2_34   |
            | timestampOperation            | 2012-04-23T18:25                                                                                                                                                                                                                                                 | SIN_CPV2_34   |
            | timestampOperation            | 2033-04-23T18:25:43.372+01:00                                                                                                                                                                                                                                    | SIN_CPV2_34.3 |
            | additionalPaymentInformations | None                                                                                                                                                                                                                                                             | SIN_CPV2_35   |
            | additionalPaymentInformations | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_36   |
            | transactionDetails            | None                                                                                                                                                                                                                                                             | PAG-2120      |
            | transactionDetails            | Empty                                                                                                                                                                                                                                                            | PAG-2120      |
            | key                           | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_37   |
            | key                           | Valore                                                                                                                                                                                                                                                           | SIN_CPV2_40   |
            | primaryCiIncurredFee          | None                                                                                                                                                                                                                                                             | PAG-2444      |
            | primaryCiIncurredFee          | Empty                                                                                                                                                                                                                                                            | PAG-2444      |
            | idBundle                      | None                                                                                                                                                                                                                                                             | PAG-2444      |
            | idBundle                      | Empty                                                                                                                                                                                                                                                            | PAG-2444      |
            | idCiBundle                    | None                                                                                                                                                                                                                                                             | PAG-2444      |
            | idCiBundle                    | Empty                                                                                                                                                                                                                                                            | PAG-2444      |

    # No error with fee 0 [SIN_CPV2_31.2]
    Scenario: check activatePaymentNoticeV2 OK 2
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV21
    @test @independent
    Scenario: check closePaymentV2 OK with fee 0
        Given the check activatePaymentNoticeV2 OK 2 scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activatePaymentNoticeV21Response.paymentToken in v2/closepayment
        And totalAmount with 10 in v2/closepayment
        And fee with 0 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    # No error - keys repeated [SIN_CPV2_38]
    Scenario: check activatePaymentNoticeV2 OK 2
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV21

    Scenario: closePaymentV2 with keys repeated
        Given the check activatePaymentNoticeV2 OK 2 scenario executed successfully
        And initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV21Response.paymentToken"
                ],
                "outcome": "KO",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "11435230",
                    "outcomePaymentGateway": "EFF",
                    "authorizationCode": "resOK"
                }
            }
            """
    @test @independent
    Scenario: check closePaymentV2 OK with keys repeated
        Given the closePaymentV2 with keys repeated scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    # syntax check - different keys [SIN_CPV2_38.1]
    Scenario: check activatePaymentNoticeV2 OK 5
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV21

    Scenario: closePaymentV2 with different keys
        Given the check activatePaymentNoticeV2 OK 5 scenario executed successfully
        And initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV21Response.paymentToken"
                ],
                "outcome": "KO",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "11435230",
                    "outcomePaymentGateway": "EFF",
                    "authorizationCode": "resOK",
                    "key": "114352304",
                    "valore": "EFF",
                    "chiave": "resOK",
                    "campo": "114352305",
                    "field": "EFF",
                    "tag": "resOK",
                    "key1": "EFF",
                    "prova": "resOK"
                }
            }
            """
    @test @independent
    Scenario: check closePaymentV2 OK with different keys
        Given the closePaymentV2 with different keys scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    # No error - key transactionId [SIN_CPV2_39]
    Scenario: check activatePaymentNoticeV2 OK 3
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV21

    Scenario: closePaymentV2 with key transactionId
        Given the check activatePaymentNoticeV2 OK 3 scenario executed successfully
        And initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV21Response.paymentToken"
                ],
                "outcome": "KO",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "TPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#"
                }
            }
            """
    @test @independent
    Scenario: check closePaymentV2 OK with key transactionId
        Given the closePaymentV2 with key transactionId scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    # syntax check - No error with only fields paymentTokens and outcome [SIN_CP_41]
    Scenario: check activatePaymentNoticeV2 OK 2
        Given the activatePaymentNoticeV2 scenario executed successfully
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV21

    Scenario: closePaymentV2 with paymentTokens and outcome
        Given the check activatePaymentNoticeV2 OK 2 scenario executed successfully
        And initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "KO"
            }
            """
    @test @independent
    Scenario: check closePaymentV2 OK with paymentTokens and outcome
        Given the closePaymentV2 with paymentTokens and outcome scenario executed successfully
        And paymentToken with $activatePaymentNoticeV21Response.paymentToken in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    @test @independent
    # syntax check - Invalid field - paymentToken
    Scenario Outline: Check syntax error on invalid body element value - paymentToken
        Given the closePaymentV2 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid paymentTokens of v2/closepayment response
        Examples:
            | elem          | value                                 | soapUI test |
            | paymentTokens | None                                  | SIN_CPV2_01 |
            | paymentToken  | None                                  | SIN_CPV2_02 |
            | paymentToken  | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CPV2_03 |




    Scenario: closePaymentV2 without brackets in paymentTokens [SIN_CPV2_03.1]
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": "a3738f8bff1f4a32998fc197bd0a6b05",
                "outcome": "KO",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BPAY",
                "identificativoIntermediario": "#id_broker_psp#",
                "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "pspTransactionId": "#psp_transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "EFF",
                    "authorizationCode": "resOK"
                }
            }
            """
    @test @independent
    Scenario: check closePaymentV2 without brackets in paymentTokens
        Given the closePaymentV2 without brackets in paymentTokens [SIN_CPV2_03.1] scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid paymentTokens of v2/closepayment response