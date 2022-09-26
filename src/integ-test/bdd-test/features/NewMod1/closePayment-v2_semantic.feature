Feature: semantic checks for closePaymentV2

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

    # paymentToken unknown [SEM_CP_01]
    Scenario: Check unknown paymentToken
        Given the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check esito is KO of v2/closepayment response
        And check descrizione is Unknown token of v2/closepayment response

    # identificativoPsp value check
    Scenario Outline: Check semantic error on identificativoPsp
        Given the closePaymentV2 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check esito is KO of v2/closepayment response
        And check descrizione is The indicated PSP does not exist of v2/closepayment response
        Examples:
            | elem              | value       | soapUI test |
            | identificativoPsp | 12345678987 | SEM_CP_03   |
            | identificativoPsp | NOT_ENABLED | SEM_CP_04   |

    # identificativoIntermediario value check
    Scenario Outline: Check semantic error on identificativoIntermediario
        Given the closePaymentV2 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check esito is KO of v2/closepayment response
        And check descrizione is The indicated brokerPSP does not exist of v2/closepayment response
        Examples:
            | elem                        | value           | soapUI test |
            | identificativoIntermediario | 12545678987     | SEM_CP_05   |
            | identificativoIntermediario | INT_NOT_ENABLED | SEM_CP_06   |

    # identificativoCanale value check
    Scenario Outline: Check semantic error on identificativoCanale
        Given the closePaymentV2 scenario executed successfully
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check esito is KO of v2/closepayment response
        And check descrizione is The indicated channel does not exist of v2/closepayment response
        Examples:
            | elem                 | value              | soapUI test |
            | identificativoCanale | 12345671234_09     | SEM_CP_07   |
            | identificativoCanale | CANALE_NOT_ENABLED | SEM_CP_08   |

    # identificativoCanale not associated to BPAY [SEM_CPV2_09]
    Scenario: Check identificativoCanale not associated to BPAY
        Given the closePaymentV2 scenario executed successfully
        And identificativoCanale with 60000000001_06 in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check esito is KO of v2/closepayment response
        And check descrizione is Incorrect PSP-brokerPSP-Channel-Payment type configuration of v2/closepayment response

    # identificativoCanale with Modello di pagamento = ATTIVATO PRESSO PSP [SEM_CPV2_10]
    Scenario: Check identificativoCanale ATTIVATO_PRESSO_PSP
        Given the closePaymentV2 scenario executed successfully
        And identificativoCanale with #canale_ATTIVATO_PRESSO_PSP# in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check esito is KO of v2/closepayment response
        And check descrizione is Invalid payment type of v2/closepayment response

    # identificativoIntermediario-identificativoCanale-identificativoPsp not associated [SEM_CPV2_11]
    Scenario: Check "esito":"KO" on identificativoPsp not associated to identificativoIntermediario and identificativoCanale
        Given the closePaymentV2 scenario executed successfully
        And identificativoPsp with IDPSPFNZ in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check esito is KO of v2/closepayment response
        And check descrizione is The indicated channel does not exist of v2/closepayment response

    # other semantic checks
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
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>311#iuv#</noticeNumber>
            </qrCode>
            <amount>12.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>test</paymentNote>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>code</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>test.prova@gmail.com</e-mail>
            </payer>
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
            <transferAmount>2.00</transferAmount>
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

    # check on amount and fee [SEM_CP_12]
    Scenario: check activateIOPayment OK
        Given the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And save activateIOPayment response in activateIOPaymentResponse

    Scenario: check closePaymentV2
        Given the check activateIOPayment OK scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activateIOPaymentResponse.paymentToken in v2/closepayment
        And totalAmount with 20 in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check esito is KO of v2/closepayment response
        And check descrizione is Mismatched amount of v2/closepayment response

    # check future timestampOperation [SEM_CP_13]
    Scenario: check activateIOPayment OK 2
        Given the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And save activateIOPayment response in activateIOPaymentResponse

    Scenario: check closePaymentV2 OK 2
        Given the check activateIOPayment OK 2 scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activateIOPaymentResponse.paymentToken in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check esito is OK of v2/closepayment response

    # check past timestampOperation [SEM_CP_14]
    Scenario: check activateIOPayment OK 3
        Given the activateIOPayment scenario executed successfully
        When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
        Then check outcome is OK of activateIOPayment response
        And save activateIOPayment response in activateIOPaymentResponse

    Scenario: check closePaymentV2 OK 3
        Given the check activateIOPayment OK 3 scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And paymentToken with $activateIOPaymentResponse.paymentToken in v2/closepayment
        And timestampOperation with 2018-04-23T18:25:43Z in v2/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check esito is OK of v2/closepayment response