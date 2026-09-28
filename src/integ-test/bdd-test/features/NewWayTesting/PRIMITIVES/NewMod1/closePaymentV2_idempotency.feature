Feature: NM1 closePaymentV2 with idempotency

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_1 @after
    Scenario: closePaymentV2 idempotency - OK with payment already acquired (same transactionId, same payload -> cache HIT)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP    | idBrokerPSP | idChannel      | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | AGID_01  | 97735020584 | 97735020584_09 | #password# | #creditor_institution_code# | 302#iuv#     | 6000           | 10.00  |
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
            | idPSP                 | AGID_01                                       |
            | idBrokerPSP           | 97735020584                                   |
            | idChannel             | 97735020584_02                                |
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
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | AGID_01                                       |
            | idBrokerPSP           | 97735020584                                   |
            | idChannel             | 97735020584_02                                |
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
            | timestampOperation1   | 2021-07-09T17:15:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # IDEMPOTENCY_CACHE: un solo record nonostante le 2 chiamate (hash identico -> risposta da cache)
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID                 | NotNone                                       |
            | PRIMITIVA          | closePaymentV2                                |
            | PSP_ID             | AGID_01                                       |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber         |
            | IDEMPOTENCY_KEY    | $transaction_id                               |
            | TOKEN               | $activatePaymentNoticeV2Response.paymentToken |
            | HASH_REQUEST       | NotNone                                       |
            | RESPONSE           | NotNone                                       |
            | VALID_TO           | NotNone                                       |
            | INSERTED_TIMESTAMP | NotNone                                       |
            | UPDATED_TIMESTAMP  | NotNone                                       |
            | INSERTED_BY        | closePaymentV2                                |
            | UPDATED_BY         | closePaymentV2                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values     |
            | IDEMPOTENCY_KEY | $transaction_id  |
            | PSP_ID          | AGID_01          |
            | PRIMITIVA       | closePaymentV2   |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values     |
            | IDEMPOTENCY_KEY | $transaction_id  |
            | PSP_ID          | AGID_01          |
            | PRIMITIVA       | closePaymentV2   |
        # POSITION_PAYMENT: la posizione risulta chiusa con il transactionId corretto
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | TRANSACTION_ID | $transaction_id                       |


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_2 @after
    Scenario: closePaymentV2 idempotency - ppt_error_idempotency (same transactionId, different payload -> 409 Conflict)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP    | idBrokerPSP | idChannel      | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | AGID_01  | 97735020584 | 97735020584_09 | #password# | #creditor_institution_code# | 303#iuv#     | 6000           | 10.00  |
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
            | idPSP                 | AGID_01                                       |
            | idBrokerPSP           | 97735020584                                   |
            | idChannel             | 97735020584_09                                |
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
            | idPSP                 | AGID_01                                       |
            | idBrokerPSP           | 97735020584                                   |
            | idChannel             | 97735020584_09                                |
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
        # TODO: confermare il testo esatto restituito dall'ambiente e decommentare, in analogia a quanto fatto per
        # activatePaymentNotice/sendPaymentOutcome (faultCode PPT_ERRORE_IDEMPOTENZA)
        # And check description is <ppt_error_idempotency description> of v2/closepayment response
        # Il record in cache resta quello della prima chiamata (nessuna sovrascrittura)
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values     |
            | IDEMPOTENCY_KEY | $transaction_id  |
            | PSP_ID          | AGID_01          |
            | PRIMITIVA       | closePaymentV2   |


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_3 @after
    Scenario: closePaymentV2 idempotency - unknown token (404 NO cache write)
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAEE     |
            | outcome               | KO                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #psp#                                |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is The indicated payment does not exist of v2/closepayment response
        # Nessun record in cache: gli errori client (4xx per token sconosciuto) non scrivono cache
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values     |
            | IDEMPOTENCY_KEY | $transaction_id  |
            | PSP_ID          | #psp#            |
            | PRIMITIVA       | closePaymentV2   |


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_4 @after
    Scenario: closePaymentV2 idempotency - outcome already acquired (422 WITH cache write)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 304#iuv#     | 6000           | 10.00  |
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
        # Prima chiamata: chiude regolarmente il pagamento (outcome acquisito) con transactionId A
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
        # Seconda chiamata sullo STESSO token gia' chiuso, ma con un NUOVO transactionId B (#transaction_id# rigenera un nuovo valore)
        # -> KO genuino "Outcome already acquired": la cache viene comunque scritta per il transactionId B
        Given from body with datatable vertical closePaymentV2Body_full initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | KO                                            |
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
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response
        # $transaction_id ora vale il transactionId B (ultimo generato dalla seconda chiamata)
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values     |
            | IDEMPOTENCY_KEY | $transaction_id  |
            | PSP_ID          | #psp#            |
            | PRIMITIVA       | closePaymentV2   |


    @ALL @PRIMITIVE @NM1 @CLOSE_IDMP_5 @after
    Scenario: closePaymentV2 idempotency - syntax error on paymentTokens (400 NO cache write)
        # paymentTokens senza le parentesi quadre -> errore di sintassi rilevato dal validatore del contratto
        Given from body with datatable vertical closePaymentV2Body_BPAY_token_without_brackets initial json v2/closepayment
            | token1                | a3738f8bff1f4a32998fc197bd0a6b05     |
            | outcome               | OK                                   |
            | idPSP                 | #psp#                                |
            | idBrokerPSP           | #psp#                                |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid paymentTokens of v2/closepayment response
        # Nessun record in cache: gli errori di sintassi (400) non scrivono cache
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values     |
            | IDEMPOTENCY_KEY | $transaction_id  |
            | PSP_ID          | #psp#            |
            | PRIMITIVA       | closePaymentV2   |
