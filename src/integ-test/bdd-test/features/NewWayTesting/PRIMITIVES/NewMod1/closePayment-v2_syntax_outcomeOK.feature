Feature: syntax checks for closePaymentV2 outcome OK 965

    Background:
        Given systems up


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_1
    # syntax check - Invalid field
    Scenario Outline: Check syntax error on invalid body element value
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_versione_primitive_2#        |
            | paymentMethod         | TPAY                                 |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00        |
            | transId               | #transaction_id#                     |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  | 2                                    |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid <elem> of v2/closepayment response
        Examples:
            | elem                          | value                                                                                                                                                                                                                                                            | soapUI test   |
            | paymentTokens                 | None                                                                                                                                                                                                                                                             | SIN_CPV2_01   |
            | outcome                       | None                                                                                                                                                                                                                                                             | SIN_CPV2_04   |
            | outcome                       | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_05   |
            | outcome                       | OO                                                                                                                                                                                                                                                               | SIN_CPV2_06   |
            | idPSP                         | None                                                                                                                                                                                                                                                             | SIN_CPV2_07   |
            | idPSP                         | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_08   |
            | idPSP                         | 700000000017000000000170000000001700                                                                                                                                                                                                                             | SIN_CPV2_09   |
            | paymentMethod                 | None                                                                                                                                                                                                                                                             | SIN_CPV2_10   |
            | paymentMethod                 | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_11   |
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
            | totalAmount                   | 12.321                                                                                                                                                                                                                                                           | SIN_CPV2_25.1 |
            | totalAmount                   | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CPV2_26   |
            | fee                           | None                                                                                                                                                                                                                                                             | SIN_CPV2_27   |
            | fee                           | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_28   |
            | fee                           | 12.321                                                                                                                                                                                                                                                           | SIN_CPV2_30.1 |
            | fee                           | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CPV2_31   |
            | timestampOperation            | None                                                                                                                                                                                                                                                             | SIN_CPV2_32   |
            | timestampOperation            | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_33   |
            | timestampOperation            | 2012-04-23                                                                                                                                                                                                                                                       | SIN_CPV2_34   |
            | timestampOperation            | 2012-04-23T18:25:43                                                                                                                                                                                                                                              | SIN_CPV2_34   |
            | timestampOperation            | 2012-04-23T18:25                                                                                                                                                                                                                                                 | SIN_CPV2_34   |
            | additionalPaymentInformations | None                                                                                                                                                                                                                                                             | SIN_CPV2_35   |
            | additionalPaymentInformations | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_36   |
            | transactionDetails            | Empty                                                                                                                                                                                                                                                            | PAG-2120      |
            | primaryCiIncurredFee          | Empty                                                                                                                                                                                                                                                            | PAG-2444      |
            | idBundle                      | Empty                                                                                                                                                                                                                                                            | PAG-2444      |
            | idCiBundle                    | Empty                                                                                                                                                                                                                                                            | PAG-2444      |


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_2
    # syntax check - Invalid field - paymentToken
    Scenario Outline: Check syntax error on invalid body element value - paymentToken
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_versione_primitive_2#        |
            | paymentMethod         | TPAY                                 |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00        |
            | transId               | #transaction_id#                     |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  | 2                                    |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid paymentTokens of v2/closepayment response
        Examples:
            | elem         | value                                 | soapUI test |
            | paymentToken | None                                  | SIN_CPV2_02 |
            | paymentToken | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CPV2_03 |


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_3
    # syntax check - Invalid field - additionalPaymentInformations [SIN_CPV2_37]
    Scenario: Check syntax error on invalid body element value - additionalPaymentInformations
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_versione_primitive_2#        |
            | paymentMethod         | TPAY                                 |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00        |
            | transId               | #transaction_id#                     |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  | 2                                    |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        And key with Empty in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response



    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_4
    Scenario Outline: check closePaymentV2 OK outline
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 12.00  |
        And from body with datatable vertical paGetPayment_3transfer_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 12.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 4.00                                |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 14                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 14                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Examples:
            | elem                 | value                         | soapUI test   |
            | totalAmount          | 14.0                          | SIN_CPV2_25   |
            | totalAmount          | 14                            | SIN_CPV2_25.2 |
            | fee                  | 2.0                           | SIN_CPV2_30   |
            | fee                  | 2                             | SIN_CPV2_30.2 |
            | timestampOperation   | 2033-04-23T18:25:43.372+01:00 | SIN_CPV2_34.1 |
            | transactionDetails   | None                          | PAG-2120      |
            | paymentMethod        | CP                            | PAG-2383      |
            | primaryCiIncurredFee | None                          | PAG-2444      |
            | idBundle             | None                          | PAG-2444      |
            | idCiBundle           | None                          | PAG-2444      |



    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_5
    Scenario: Check syntax error on fee greater than totalAmount
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 12.00  |
        And from body with datatable vertical paGetPayment_3transfer_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 12.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 4.00                                |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 14                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 14                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        And fee with 20 in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Mismatched amount of v2/closepayment response



    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_6
    Scenario: check closePaymentV2 without brackets in paymentTokens
        Given from body with datatable vertical closePaymentV2Body_BPAY_token_without_brackets initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | BPAY                                 |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00        |
            | transId               | #transaction_id#                     |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  | 2                                    |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid paymentTokens of v2/closepayment response



    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_7
    Scenario Outline: check closePaymentV2 OK outline
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 12.00  |
        And from body with datatable vertical paGetPayment_3transfer_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 12.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 4.00                                |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 14                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 14                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        And paymentMethod with <value> in v2/closepayment
        And idChannel with #canale_IMMEDIATO_MULTIBENEFICIARIO# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Examples:
            | value | soapUI test |
            | AD    | PAG-2482    |
            | BBT   | PAG-2482    |
            | BP    | PAG-2482    |
            | OBEP  | PAG-2482    |
            | PO    | PAG-2482    |
            | JIF   | PAG-2482    |
            | MYBK  | PAG-2482    |
            | BPAY  | PAG-2482    |
            | PPAL  | PAG-2482    |



    Scenario: closePaymentV2 PAG-2555
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
                "paymentMethod": "CP",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "rrn": "11223344",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "timestampOperation": "2021-07-09T17:06:03",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """

    Scenario: closePaymentV2 PAG-2555 with timeZone Z
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
                "paymentMethod": "CP",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2023-12-05T09:20:32Z",
                "additionalPaymentInformations": {
                    "rrn": "11223344",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "timestampOperation": "2023-12-05T09:20:32Z",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """

    Scenario: closePaymentV2 PAG-2555 with timeZone +
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
                "paymentMethod": "CP",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "primaryCiIncurredFee": 1,
                "idBundle": "0bf0c282-3054-11ed-af20-acde48001122",
                "idCiBundle": "0bf0c35e-3054-11ed-af20-acde48001122",
                "timestampOperation": "2023-11-30T12:46:46.554+01:00",
                "additionalPaymentInformations": {
                    "rrn": "11223344",
                    "outcomePaymentGateway": "00",
                    "totalAmount": "12",
                    "fee": "2",
                    "timestampOperation": "2023-11-30T12:46:46.554+01:00",
                    "authorizationCode": "123456",
                    "paymentGateway": "00"
                }
            }
            """


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_8 @after
    Scenario Outline: check closePaymentV2 PAG-2555 KO outline
        Given update for table CANALI_NODO with parameter FLAG_TRAVASO = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values |
            | OBJ_ID     | 16649        |
        And waiting after triggered refresh job ALL
        And from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | CP                                   |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2033-04-23T18:25:43Z                 |
            | rrn                   | 11223344                             |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  | 2                                    |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response
        Examples:
            | elem                  | value                                |
            | rrn                   | None                                 |
            | rrn                   | Empty                                |
            | outcomePaymentGateway | None                                 |
            | outcomePaymentGateway | Empty                                |
            | authorizationCode     | None                                 |
            | authorizationCode     | Empty                                |
            | authorizationCode     | aaaaaaa                              |
            | paymentGateway        | Empty                                |
            | paymentGateway        | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa |


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_9
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount None
        Given from body with datatable vertical closePaymentV2Body_CP_without_totalAmount initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | CP                                   |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2033-04-23T18:25:43Z                 |
            | rrn                   | 11223344                             |
            | outPaymentGateway     | 00                                   |
            | fee1                  | 2                                    |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response

    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_10
    Scenario: check closePaymentV2 PAG-2555 KO totalAmount Empty
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | CP                                   |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2033-04-23T18:25:43Z                 |
            | rrn                   | 11223344                             |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          |                                      |
            | fee1                  | 2                                    |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_11
    Scenario: check closePaymentV2 PAG-2555 KO fee None
        Given from body with datatable vertical closePaymentV2Body_CP_without_fee initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | CP                                   |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2033-04-23T18:25:43Z                 |
            | rrn                   | 11223344                             |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response



    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_12
    Scenario: check closePaymentV2 PAG-2555 KO fee Empty
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | CP                                   |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2033-04-23T18:25:43Z                 |
            | rrn                   | 11223344                             |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  |                                      |
            | timestampOperation1   | 2021-07-09T17:06:03                  |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_13
    Scenario: check closePaymentV2 PAG-2555 KO timestampOperation None
        Given from body with datatable vertical closePaymentV2Body_CP_without_timestampOperation initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | CP                                   |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2033-04-23T18:25:43Z                 |
            | rrn                   | 11223344                             |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  | 2                                    |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_OK @NMU_CLOSE_SYN_BPAY_OK_14
    Scenario: check closePaymentV2 PAG-2555 KO timestampOperation Empty
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #id_broker_psp#                      |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | paymentMethod         | CP                                   |
            | transactionId         | #transaction_id#                     |
            | totalAmountExt        | 12                                   |
            | feeExt                | 2                                    |
            | primaryCiIncurredFee  | 1                                    |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122 |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122 |
            | timestampOperationExt | 2033-04-23T18:25:43Z                 |
            | rrn                   | 11223344                             |
            | outPaymentGateway     | 00                                   |
            | totalAmount1          | 12                                   |
            | fee1                  | 2                                    |
            | timestampOperation1   |                                      |
            | authorizationCode     | 123456                               |
            | paymentGateway        | 00                                   |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid additionalPaymentInformations of v2/closepayment response