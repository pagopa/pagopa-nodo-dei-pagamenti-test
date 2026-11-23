Feature: NM1 closePaymentV2 with idempotency

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_1 @after
    Scenario: closePaymentV2 idempotency - OK with payment already acquired (same transactionId, same payload -> cache HIT)
        #Given insert into table CONFIGURATION_KEYS with datatable horizontal on db nodo_cfg if not exists
        #    | column_name        | value                                 |
        #    | CONFIG_CATEGORY    | GLOBAL                                |
        #    | CONFIG_KEY         | idempotency.closeV2.ok.duration.days  |
        #    | CONFIG_VALUE       | 1                                     |
        #    | CONFIG_DESCRIPTION | cache validity days closeV2           |
        Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '1' on db nodo_cfg with where datatable horizontal
            | where_keys      | where_values                          |
            | CONFIG_KEY      | idempotency.closeV2.ok.duration.days  |
            | CONFIG_CATEGORY | GLOBAL                                |
        And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys      | where_values   |
            | CONFIG_KEY      | useIdempotency |
            | CONFIG_CATEGORY | GLOBAL         |
        And waiting after triggered refresh job ALL
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
        # Prima chiamata closePaymentV2: crea il record in IDEMPOTENCY_CACHE
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # Seconda chiamata: STESSO transactionId (riuso $transaction_id) e STESSO payload byte-per-byte -> cache HIT
        # Il pagamento risulta gia' acquisito (chiuso dalla prima chiamata) ma la risposta e' 200 OK dalla cache di idempotenza
        # NB: si riusa closePaymentV2Body_full_reuse_key (key additionalPaymentInformations.key = $psp_transaction_id) per garantire
        # un payload byte-per-byte identico alla prima chiamata, dato che closePaymentV2Body_full genera un valore random ad ogni chiamata
        Given from body with datatable vertical closePaymentV2Body_full_reuse_key initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
            | transactionId         | $transaction_id                               |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | $transaction_id                               |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        

    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_2 @after
    Scenario: closePaymentV2 idempotency - ppt_error_idempotency (same transactionId, different payload -> 409 Conflict)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 10.00  |
        and update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '1' on db nodo_cfg with where datatable horizontal
            | where_keys      | where_values                          |
            | CONFIG_KEY      | idempotency.closeV2.ok.duration.days  |
            | CONFIG_CATEGORY | GLOBAL                                |
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
        # Prima chiamata: totalAmountExt=12 -> 200 OK, scrive la cache
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # Seconda chiamata: STESSO transactionId ($transaction_id) ma totalAmountExt=13 -> hash diverso -> 409 Conflict
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
            | transactionId         | $transaction_id                               |
            | totalAmountExt        | 13                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | $transaction_id                               |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 13                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 409
        And check outcome is KO of v2/closepayment response
        

    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_3 @after
    Scenario: closePaymentV2 idempotency - OK with payment already acquired (same transactionId, same payload -> cache HIT)
        #Given insert into table CONFIGURATION_KEYS with datatable horizontal on db nodo_cfg if not exists
        #    | column_name        | value                                 |
        #    | CONFIG_CATEGORY    | GLOBAL                                |
        #    | CONFIG_KEY         | idempotency.closeV2.ok.duration.days  |
        #    | CONFIG_VALUE       | 1                                     |
        #    | CONFIG_DESCRIPTION | cache validity days closeV2           |
        Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '0' on db nodo_cfg with where datatable horizontal
            | where_keys      | where_values                          |
            | CONFIG_KEY      | idempotency.closeV2.ok.duration.days  |
            | CONFIG_CATEGORY | GLOBAL                                |
        And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'true' on db nodo_cfg with where datatable horizontal
            | where_keys      | where_values   |
            | CONFIG_KEY      | useIdempotency |
            | CONFIG_CATEGORY | GLOBAL         |
        And waiting after triggered refresh job ALL
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
        # Prima chiamata closePaymentV2: crea il record in IDEMPOTENCY_CACHE
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # Seconda chiamata: STESSO transactionId (riuso $transaction_id) e STESSO payload byte-per-byte -> cache HIT
        # Il pagamento risulta gia' acquisito (chiuso dalla prima chiamata) ma la risposta e' 200 OK dalla cache di idempotenza
        # NB: si riusa closePaymentV2Body_full_reuse_key (key additionalPaymentInformations.key = $psp_transaction_id) per garantire
        # un payload byte-per-byte identico alla prima chiamata, dato che closePaymentV2Body_full genera un valore random ad ogni chiamata
        Given from body with datatable vertical closePaymentV2Body_full_reuse_key initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | TPAY                                          |
            | transactionId         | $transaction_id                               |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | $transaction_id                               |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response


    