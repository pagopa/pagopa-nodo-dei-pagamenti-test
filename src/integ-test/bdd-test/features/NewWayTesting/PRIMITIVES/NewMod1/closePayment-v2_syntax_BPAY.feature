Feature: syntax checks for closePaymentV2 - BPAY 963

    Background:
        Given systems up


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY @NMU_CLOSE_SYN_BPAY_1
    Scenario Outline: check closePaymentV2 PAG-2555 KO outline
        Given from body with datatable vertical closePaymentV2Body_BPAY initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05             |
            | outcome               | OK                                           |
            | idPSP                 | #psp#                                        |
            | idBrokerPSP           | #psp#                                        |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO_TRAVASO# |
            | paymentMethod         | BPAY                                         |
            | transactionId         | #transaction_id#                             |
            | totalAmountExt        | 12                                           |
            | feeExt                | 2                                            |
            | primaryCiIncurredFee  | 1                                            |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122         |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122         |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                |
            | transId               | #transaction_id#                             |
            | outPaymentGateway     | 00                                           |
            | totalAmount1          | 12                                           |
            | fee1                  | 2                                            |
            | timestampOperation1   | 2021-07-09T17:06:03                          |
            | authorizationCode     | 123456                                       |
            | paymentGateway        | 00                                           |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response
        Examples:
            | elem                  | value                                |
            | outcomePaymentGateway | None                                 |
            | outcomePaymentGateway | Empty                                |
            | authorizationCode     | None                                 |
            | authorizationCode     | Empty                                |
            | authorizationCode     | aaaaaaa                              |
            | paymentGateway        | Empty                                |
            | paymentGateway        | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |



    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY @NMU_CLOSE_SYN_BPAY_2
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount None
        Given from body with datatable vertical closePaymentV2Body_BPAY_without_totalamount initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05             |
            | outcome               | OK                                           |
            | idPSP                 | #psp#                                        |
            | idBrokerPSP           | #psp#                                        |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO_TRAVASO# |
            | paymentMethod         | BPAY                                         |
            | transactionId         | #transaction_id#                             |
            | totalAmountExt        | 12                                           |
            | feeExt                | 2                                            |
            | primaryCiIncurredFee  | 1                                            |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122         |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122         |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                |
            | transId               | #transaction_id#                             |
            | outPaymentGateway     | 00                                           |
            | fee1                  | 2                                            |
            | timestampOperation1   | 2021-07-09T17:06:03                          |
            | authorizationCode     | 123456                                       |
            | paymentGateway        | 00                                           |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY @NMU_CLOSE_SYN_BPAY_3
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount oversize
        Given from body with datatable vertical closePaymentV2Body_BPAY initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05              |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO_TRAVASO#  |
            | paymentMethod         | BPAY                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 9999999999.99                                 |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @ALL @PRIMITIVE @NMU
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount null
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": null,
                    "fee": "2",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @ALL @PRIMITIVE @NMU
    Scenario: check closePaymentV2 PAG-2555 KO fee None
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @ALL @PRIMITIVE @NMU
    Scenario: check closePaymentV2 PAG-2555 KO fee oversize
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "9999999999.99",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @ALL @PRIMITIVE @NMU
    Scenario: check closePaymentV2 PAG-2555 KO fee null
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": null,
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @ALL @PRIMITIVE @NMU
    Scenario: check closePaymentV2 PAG-2555 KO timestampOperation None
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @ALL @PRIMITIVE @NMU
    Scenario: check closePaymentV2 PAG-2555 KO timestampOperation null
        Given initial JSON v2/closepayment
            """
            {
                "paymentTokens": [
                    "a3738f8bff1f4a32998fc197bd0a6b05"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "idBrokerPSP": "#psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "paymentMethod": "BPAY",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "transactionId": "#transaction_id#",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "timestampOperation": null,
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @ALL @PRIMITIVE @NMU
    Scenario: check closePaymentV2 PAG-2555 OK
        Given the check activatePaymentNoticeV2 OK scenario executed successfully
        And the closePaymentV2 PAG-2555 scenario executed successfully
        And paymentToken with $activatePaymentNoticeV21Response.paymentToken in v2/closepayment
        And paymentGateway with None in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

    @ALL @PRIMITIVE @NMU
    Scenario: update DB
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'N', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds