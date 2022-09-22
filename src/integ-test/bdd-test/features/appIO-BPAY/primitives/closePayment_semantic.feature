Feature: semantic checks for closePayment

    Background:
        Given systems up

    Scenario: closePayment
        Given initial JSON v1/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc1976d0a6b05"
                ],
                "outcome": "OK",
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

    # paymentToken unknown [SEM_CP_01]
    Scenario: Check unknown paymentToken
        Given the closePayment scenario executed successfully
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Il Pagamento indicato non esiste of v1/closepayment response

    # identificativoPsp value check
    Scenario Outline: Check semantic error on identificativoPsp
        Given the closePayment scenario executed successfully
        And <elem> with <value> in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Il PSP indicato non esiste of v1/closepayment response
        Examples:
            | elem              | value       | soapUI test |
            | identificativoPsp | 12345678987 | SEM_CP_03   |
            | identificativoPsp | NOT_ENABLED | SEM_CP_04   |

    # identificativoIntermediario value check
    Scenario Outline: Check semantic error on identificativoIntermediario
        Given the closePayment scenario executed successfully
        And <elem> with <value> in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is L'Intermediario indicato non esiste of v1/closepayment response
        Examples:
            | elem                        | value           | soapUI test |
            | identificativoIntermediario | 12545678987     | SEM_CP_05   |
            | identificativoIntermediario | INT_NOT_ENABLED | SEM_CP_06   |

    # identificativoCanale value check
    Scenario Outline: Check semantic error on identificativoCanale
        Given the closePayment scenario executed successfully
        And <elem> with <value> in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Il Canale indicato non esiste of v1/closepayment response
        Examples:
            | elem                 | value              | soapUI test |
            | identificativoCanale | 12345671234_09     | SEM_CP_07   |
            | identificativoCanale | CANALE_NOT_ENABLED | SEM_CP_08   |

    # identificativoCanale not associated to BPAY [SEM_SPO_09]
    Scenario: Check identificativoCanale not associated to BPAY
        Given the closePayment scenario executed successfully
        And identificativoCanale with 60000000001_06 in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Configurazione psp-canale-tipoVersamento non corretta of v1/closepayment response

    # identificativoCanale with Modello di pagamento = ATTIVATO PRESSO PSP [SEM_SPO_10]
    Scenario: Check identificativoCanale ATTIVATO_PRESSO_PSP
        Given the closePayment scenario executed successfully
        And identificativoCanale with #canale_ATTIVATO_PRESSO_PSP# in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 400
        And check esito is KO of v1/closepayment response
        And check descrizione is Modello pagamento non valido of v1/closepayment response

    # identificativoIntermediario-identificativoCanale-identificativoPsp not associated [SEM_SPO_11]
    Scenario: Check "esito":"KO" on identificativoPsp not associated to identificativoIntermediario and identificativoCanale
        Given the closePayment scenario executed successfully
        And identificativoPsp with IDPSPFNZ in v1/closepayment
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 404
        And check esito is KO of v1/closepayment response
        And check descrizione is Configurazione psp-canale non corretta of v1/closepayment response