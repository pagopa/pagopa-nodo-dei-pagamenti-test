Feature: syntax checks for closePaymentV2 outcome OK

    Background:
        Given systems up

    Scenario: closePaymentV2
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
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

    # syntax check - Invalid field invalid
    Scenario Outline: Check syntax error on invalid body element value
        Given the closePaymentV2 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check esito is KO of v2/closepayment response
        And check descrizione is Invalid <elem> of v2/closepayment response
        Examples:
            | elem                          | value                                                                                                                                                                                                                                                            | soapUI test |
            | paymentTokens                 | None                                                                                                                                                                                                                                                             | SIN_CPV2_01 |
            | outcome                       | None                                                                                                                                                                                                                                                             | SIN_CPV2_04 |
            | outcome                       | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_05 |
            | outcome                       | OO                                                                                                                                                                                                                                                               | SIN_CPV2_06 |
            | idPsp                         | None                                                                                                                                                                                                                                                             | SIN_CPV2_07 |
            | idPsp                         | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_08 |
            | idPsp                         | 700000000017000000000170000000001700                                                                                                                                                                                                                             | SIN_CPV2_09 |
            | paymentMethod                 | None                                                                                                                                                                                                                                                             | SIN_CPV2_10 |
            | paymentMethod                 | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_11 |
            | paymentMethod                 | OBEP                                                                                                                                                                                                                                                             | SIN_CPV2_12 |
            | paymentMethod                 | CP                                                                                                                                                                                                                                                               | SIN_CPV2_12 |
            | idBrokerPSP                   | None                                                                                                                                                                                                                                                             | SIN_CPV2_13 |
            | idBrokerPSP                   | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_14 |
            | idBrokerPSP                   | 700000000017000000000170000000001700                                                                                                                                                                                                                             | SIN_CPV2_15 |
            | idChannel                     | None                                                                                                                                                                                                                                                             | SIN_CPV2_16 |
            | idChannel                     | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_17 |
            | idChannel                     | 70000000001_0370000000001_0370000000                                                                                                                                                                                                                             | SIN_CPV2_18 |
            | transactionId                 | None                                                                                                                                                                                                                                                             | SIN_CPV2_19 |
            | transactionId                 | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_20 |
            | transactionId                 | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CPV2_21 |
            | totalAmount                   | None                                                                                                                                                                                                                                                             | SIN_CPV2_22 |
            | totalAmount                   | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_23 |
            | totalAmount                   | 12.321                                                                                                                                                                                                                                                           | SIN_CPV2_25 |
            | totalAmount                   | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CPV2_26 |
            | fee                           | None                                                                                                                                                                                                                                                             | SIN_CPV2_27 |
            | fee                           | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_28 |
            | fee                           | 12.321                                                                                                                                                                                                                                                           | SIN_CPV2_30 |
            | fee                           | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CPV2_31 |
            | timestampOperation            | None                                                                                                                                                                                                                                                             | SIN_CPV2_32 |
            | timestampOperation            | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_33 |
            | timestampOperation            | 2012-04-23                                                                                                                                                                                                                                                       | SIN_CPV2_34 |
            | timestampOperation            | 2012-04-23T18:25:43                                                                                                                                                                                                                                              | SIN_CPV2_34 |
            | timestampOperation            | 2012-04-23T18:25                                                                                                                                                                                                                                                 | SIN_CPV2_34 |
            | additionalPaymentInformations | None                                                                                                                                                                                                                                                             | SIN_CPV2_35 |


            | transactionId         | None                                                                                                                                                                                                                                                             | SIN_CPV2_37 |
            | transactionId         | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_38 |
            | transactionId         | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CPV2_39 |
            | outcomePaymentGateway | None                                                                                                                                                                                                                                                             | SIN_CPV2_40 |
            | outcomePaymentGateway | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_41 |
            | outcomePaymentGateway | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CPV2_42 |
            | authorizationCode     | None                                                                                                                                                                                                                                                             | SIN_CPV2_43 |
            | authorizationCode     | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_44 |
            | authorizationCode     | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CPV2_45 |


    Scenario Outline: Check syntax error on invalid body element value - paymentToken
        Given the closePaymentV2 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check esito is KO of v2/closepayment response
        And check descrizione is Invalid paymentTokens of v2/closepayment response
        Examples:
            | elem         | value                                 | soapUI test |
            | paymentToken | None                                  | SIN_CPV2_02 |
            | paymentToken | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CPV2_03 |


    # No error with fee 0 [SIN_CPV2_31.2]
    Scenario: activatePaymentNotice
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
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
            <transferAmount>5.00</transferAmount>
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

    Scenario: check activatePaymentNotice OK
        Given the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice1

    Scenario Outline: check closePaymentV2 OK with fee 0
        Given the check activatePaymentNotice OK scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activatePaymentNotice1Response.paymentToken in v2/closepayment
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check esito is OK of v2/closepayment response
        Examples:
            | elem                          | value | soapUI test   |
            | fee                           | 0     | SIN_CPV2_31.2 |
            | additionalPaymentInformations | Empty | SIN_CPV2_36   |

    # # No error with empty additionalPaymentInformations [SIN_CPV2_36]
    # Scenario: check activatePaymentNotice OK
    #     Given the activatePaymentNotice scenario executed successfully
    #     When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    #     Then check outcome is OK of activatePaymentNotice response
    #     And save activatePaymentNotice response in activatePaymentNotice1

    # Scenario: check closePaymentV2 OK with empty additionalPaymentInformations
    #     Given the check activatePaymentNotice OK scenario executed successfully
    #     And the closePaymentV2 scenario executed successfully
    #     And paymentToken with $activatePaymentNotice1Response.paymentToken in v2/closepayment
    #     And additionalPaymentInformations with Empty in v2/closepayment
    #     When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
    #     Then verify the HTTP status code of v2/closepayment response is 200
    #     And check esito is OK of v2/closepayment response

    # syntax check - Invalid request
    Scenario Outline: Check syntax error on invalid request
        Given the closePaymentV2 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check esito is KO of v2/closepayment response
        And check descrizione is Invalid request of v2/closepayment response
        Examples:
            | elem | value | soapUI test |
    # | totalAmount                 | 12,21 | SIN_CPV2_24   |   gestione della virgola non previsto nello step when(u'{sender} sends rest {method:Method} {service} to {receiver}')
    # | fee                         | 12,32 | SIN_CPV2_29   |   gestione della virgola non previsto nello step when(u'{sender} sends rest {method:Method} {service} to {receiver}')


    # syntax check - Mismatched amount [SIN_CPV2_31.1]
    Scenario: Check syntax error on fee greater than totalAmount
        Given the closePaymentV2 scenario executed successfully
        And fee with 20 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check esito is KO of v2/closepayment response
        And check descrizione is Mismatched amount of v2/closepayment response


    # syntax check - Invalid paymentTokens with 6 tokens [SIN_CPV2_03.3]
    Scenario: check activatePaymentNotice OK 6 tokens
        Given the activatePaymentNotice scenario executed successfully
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice1

    Scenario: check activatePaymentNotice2 OK 6 tokens
        Given the check activatePaymentNotice OK 6 tokens scenario executed successfully
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNotice
        And creditorReferenceId with 11$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice2

    Scenario: check activatePaymentNotice3 OK 6 tokens
        Given the check activatePaymentNotice2 OK 6 tokens scenario executed successfully
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNotice
        And creditorReferenceId with 11$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice3

    Scenario: check activatePaymentNotice4 OK 6 tokens
        Given the check activatePaymentNotice3 OK 6 tokens scenario executed successfully
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNotice
        And creditorReferenceId with 11$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice4

    Scenario: check activatePaymentNotice5 OK 6 tokens
        Given the check activatePaymentNotice4 OK 6 tokens scenario executed successfully
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNotice
        And creditorReferenceId with 11$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice5

    Scenario: check activatePaymentNotice6 OK 6 tokens
        Given the check activatePaymentNotice5 OK 6 tokens scenario executed successfully
        And random iuv in context
        And noticeNumber with 311$iuv in activatePaymentNotice
        And creditorReferenceId with 11$iuv in paGetPayment
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice6

    Scenario: closePaymentV2 6 tokens
        Given the check activatePaymentNotice OK 6 tokens scenario executed successfully
        And the check activatePaymentNotice2 OK 6 tokens scenario executed successfully
        And the check activatePaymentNotice3 OK 6 tokens scenario executed successfully
        And the check activatePaymentNotice4 OK 6 tokens scenario executed successfully
        And the check activatePaymentNotice5 OK 6 tokens scenario executed successfully
        And the check activatePaymentNotice6 OK 6 tokens scenario executed successfully
        And initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNotice1Response.paymentToken",
                    "$activatePaymentNotice2Response.paymentToken",
                    "$activatePaymentNotice3Response.paymentToken",
                    "$activatePaymentNotice4Response.paymentToken",
                    "$activatePaymentNotice5Response.paymentToken",
                    "$activatePaymentNotice6Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "60000000001",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
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

    Scenario: check closePaymentV2 OK with 6 tokens
        Given the closePaymentV2 6 tokens scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check esito is KO of v2/closepayment response
        And check descrizione is Invalid paymentTokens of v2/closepayment response


#-----------gestione del paymentTokens senza [] non previsto nello step when(u'{sender} sends rest {method:Method} {service} to {receiver}')

# Scenario: closePaymentV2 without brackets in paymentTokens [SIN_CPV2_03.1]
#   Given initial JSON v2/closepayment
#     """
#     {
#       "paymentTokens": "a3738f8bff1f4a32998fc197bd0a6b05",
#       "outcome": "OK",
#       "identificativoPsp": "#psp#",
#       "tipoVersamento": "BPAY",
#       "identificativoIntermediario": "#id_broker_psp#",
#       "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
#       "pspTransactionId": "#psp_transaction_id#",
#       "totalAmount": 12,
#       "fee": 2,
#       "timestampOperation": "2033-04-23T18:25:43Z",
#       "additionalPaymentInformations": {
#         "transactionId": "#transaction_id#",
#         "outcomePaymentGateway": "EFF",
#         "authorizationCode": "resOK"
#       }
#     }
#     """

# Scenario: check closePaymentV2 without brackets in paymentTokens
#   Given the closePaymentV2 without brackets in paymentTokens scenario executed successfully
#   When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
#   Then verify the HTTP status code of v2/closepayment response is 400
#   And check esito is KO of v2/closepayment response
#   And check descrizione is Invalid paymentTokens of v2/closepayment response
