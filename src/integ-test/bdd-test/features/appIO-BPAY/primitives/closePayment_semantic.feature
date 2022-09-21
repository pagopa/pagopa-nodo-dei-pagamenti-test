Feature: semantic checks for closePayment

    Background:
        Given systems up

    Scenario: closePayment
        Given initial JSON v1/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
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
        And check descrizione is L'intermediario indicato non esiste of v1/closepayment response
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






    # # paymentToken value check: paymentToken not in db [SEM_CP_01]
    # Scenario: Check "esito":"KO" on unknown paymentToken
    #     Given paymentToken with random string, not present in DB, in closePayment-v1 request
    #     When PM sends closePayment-v1 to nodo-dei-pagamenti
    #     Then check esito is KO
    #     And check descrizione is 'Il Pagamento indicato non esiste'
    #     And check errorCode is 404

    # # identificativoCanale value check: identificativoCanale not enableb to BPAY [SEM_SPO_09]
    # Scenario: Check "esito":"KO" on identificativoCanale not enableb to BPAY
    #     Given identificativoCanale with 70000000001_06 in closePayment-v1 request
    #     When PM sends closePayment-v1 to nodo-dei-pagamenti
    #     Then check esito is KO
    #     And check descrizione is 'Configurazione psp-canale-tipoVersamento non corretta'
    #     And check errorCode is 404

    # # identificativoCanale value check: identificativoCanale with Modello di pagamento = ATTIVATO PRESSO PSP [SEM_SPO_10]
    # Scenario: Check "esito":"KO" on identificativoCanale with Modello di pagamento = ATTIVATO_PRESSO_PSP
    #     Given identificativoCanale with 70000000001_01 in closePayment-v1 request
    #     When PM sends closePayment-v1 to nodo-dei-pagamenti
    #     Then check esito is KO
    #     And check descrizione is 'Modello pagamento non valido'
    #     And check errorCode is 400

    # # identificativoIntermediario-identificativoCanale-identificativoPsp value check: not associated [SEM_SPO_11]
    # Scenario: Check "esito":"KO" on identificativoPsp not associated to identificativoIntermediario and identificativoCanale
    #     Given identificativoPsp with IDPSPFNZ in closePayment-v1 request
    #     When PM sends closePayment-v1 to nodo-dei-pagamenti
    #     Then check esito is KO
    #     And check descrizione is 'Configurazione psp-canale non corretta'
    #     And check errorCode is 404