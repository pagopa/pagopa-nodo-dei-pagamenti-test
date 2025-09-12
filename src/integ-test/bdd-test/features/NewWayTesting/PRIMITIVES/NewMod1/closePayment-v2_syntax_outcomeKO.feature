Feature: syntax checks for closePaymentV2 outcome KO 964

    Background:
        Given systems up


    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_KO @NMU_CLOSE_SYN_BPAY_KO_1
    Scenario Outline: check closePaymentV2 OK
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | KO                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
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
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
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
            | totalAmount                   | 12.0                                                                                                                                                                                                                                                             | SIN_CPV2_25   |
            | totalAmount                   | 12.321                                                                                                                                                                                                                                                           | SIN_CPV2_25.1 |
            | totalAmount                   | 12                                                                                                                                                                                                                                                               | SIN_CPV2_25.2 |
            | totalAmount                   | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CPV2_26   |
            | fee                           | None                                                                                                                                                                                                                                                             | SIN_CPV2_27   |
            | fee                           | Empty                                                                                                                                                                                                                                                            | SIN_CPV2_28   |
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



    # syntax check - different keys [SIN_CPV2_38.1]
    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_KO @NMU_CLOSE_SYN_BPAY_KO_2
    Scenario: closePaymentV2 with different keys
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_different_keys initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | KO                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | TPAY                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response



    # syntax check - No error with only fields paymentTokens and outcome [SIN_CP_41]
    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_KO @NMU_CLOSE_SYN_BPAY_KO_3
    Scenario: check closePaymentV2 OK with paymentTokens and outcome
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_BPAY_with_paymentTokens_outcome initial json v2/closepayment
            | token1  | $activatePaymentNoticeV2Response.paymentToken |
            | outcome | KO                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response




    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_KO @NMU_CLOSE_SYN_BPAY_KO_4
    # syntax check - Invalid field - paymentToken
    Scenario Outline: Check syntax error on invalid body element value - paymentToken
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
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
        And check description is Invalid paymentTokens of v2/closepayment response
        Examples:
            | elem          | value                                 | soapUI test |
            | paymentTokens | None                                  | SIN_CPV2_01 |
            | paymentToken  | None                                  | SIN_CPV2_02 |
            | paymentToken  | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CPV2_03 |




    @ALL @PRIMITIVE @NMU @NMU_CLOSE_SYN_BPAY_KO @NMU_CLOSE_SYN_BPAY_KO_5
    Scenario: check closePaymentV2 without brackets in paymentTokens
        Given from body with datatable vertical closePaymentV2Body_BPAY_token_without_brackets initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #psp#                                |
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