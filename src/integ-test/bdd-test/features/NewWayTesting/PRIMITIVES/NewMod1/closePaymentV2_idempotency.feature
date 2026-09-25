Feature: NM1 closePaymentV2 with idempotency

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_1
    Scenario: closePaymentV2 idempotency - same transactionId same payload
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter idempotency.closeV2.duration.days on configuration keys with value 30
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv      | 6000           | 12.00  |
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
            | token1               | $activatePaymentNoticeV2Response.paymentToken |
            | outcome              | OK                                            |
            | idPSP                | #psp#                                         |
            | idBrokerPSP          | #psp#                                         |
            | idChannel            | #canale_versione_primitive_2#                 |
            | paymentMethod        | TPAY                                          |
            | transactionId        | #transaction_id#                              |
            | totalAmountExt       | 14                                            |
            | feeExt               | 2                                             |
            | primaryCiIncurredFee | 1                                             |
            | idBundle             | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle           | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId              | #transaction_id#                              |
            | outPaymentGateway    | 00                                            |
            | totalAmount1         | 14                                            |
            | fee1                 | 2                                             |
            | timestampOperation1  | 2021-07-09T17:06:03                           |
            | authorizationCode    | 123456                                        |
            | paymentGateway       | 00                                            |
        And <elem> with <value> in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                  |
            | IDEMPOTENCY_KEY | #transaction_id#              |
            | PSP_ID          | #psp#                         |
            | PRIMITIVA       | closePaymentV2                |
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                  |
            | TRANSACTION_ID | #transaction_id#              |
            | PSP_ID         | #psp#                         |
        Examples:
            | elem         | value |
            | totalAmount  | 14.0  |


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_2
    Scenario: closePaymentV2 idempotency - same transactionId different payload
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter idempotency.closeV2.duration.days on configuration keys with value 30
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv      | 6000           | 12.00  |
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
            | token1               | $activatePaymentNoticeV2Response.paymentToken |
            | outcome              | OK                                            |
            | idPSP                | #psp#                                         |
            | idBrokerPSP          | #psp#                                         |
            | idChannel            | #canale_versione_primitive_2#                 |
            | paymentMethod        | TPAY                                          |
            | transactionId        | #transaction_id#                              |
            | totalAmountExt       | 14                                            |
            | feeExt               | 2                                             |
            | primaryCiIncurredFee | 1                                             |
            | idBundle             | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle           | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId              | #transaction_id#                              |
            | outPaymentGateway    | 00                                            |
            | totalAmount1         | 14                                            |
            | fee1                 | 2                                             |
            | timestampOperation1  | 2021-07-09T17:06:03                           |
            | authorizationCode    | 123456                                        |
            | paymentGateway       | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1               | $activatePaymentNoticeV2Response.paymentToken |
            | outcome              | OK                                            |
            | idPSP                | #psp#                                         |
            | idBrokerPSP          | #psp#                                         |
            | idChannel            | #canale_versione_primitive_2#                 |
            | paymentMethod        | TPAY                                          |
            | transactionId        | #transaction_id#                              |
            | totalAmountExt       | 15                                            |
            | feeExt               | 2                                             |
            | primaryCiIncurredFee | 1                                             |
            | idBundle             | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle           | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId              | #transaction_id#                              |
            | outPaymentGateway    | 00                                            |
            | totalAmount1         | 15                                            |
            | fee1                 | 2                                             |
            | timestampOperation1  | 2021-07-09T17:06:03                           |
            | authorizationCode    | 123456                                        |
            | paymentGateway       | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 409
        And check outcome is KO of v2/closepayment response

