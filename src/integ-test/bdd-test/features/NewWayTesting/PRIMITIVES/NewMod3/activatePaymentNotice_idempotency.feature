Feature: NM3 primitives activatePaymentNotice with idempotency

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_1 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-1B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 40
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | activatePaymentNotice                       |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice.idempotencyKey       |
            | VALID_TO           | NotNone                                     |
            | HASH_REQUEST       | NotNone                                     |
            | RESPONSE           | NotNone                                     |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify datetime plus number of date default_token_duration_validity_millis of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
            | PSP_ID          | $activatePaymentNotice.idPSP          |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PSP_ID                | #psp#                                       |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | PAYMENT_METHOD        | None                                        |
            | TOUCHPOINT            | None                                        |
            | SUGGESTED_IDBUNDLE    | None                                        |
            | SUGGESTED_IDCIBUNDLE  | None                                        |
            | SUGGESTED_USER_FEE    | None                                        |
            | SUGGESTED_PA_FEE      | None                                        |
            | PAYMENT_NOTE          | responseFull                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | DESCRIPTION        | NotNone                             |
            | COMPANY_NAME       | NotNone                             |
            | OFFICE_NAME        | None                                |
            | DEBTOR_ID          | None                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                              |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice.idempotencyKey       |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | None                                |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
            | METADATA                 | None                                |
            | REQ_TIPO_BOLLO           | None                                |
            | REQ_HASH_DOCUMENTO       | None                                |
            | REQ_PROVINCIA_RESIDENZA  | None                                |
            | COMPANY_NAME_SECONDARY   | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAYING                              |
            | INSERTED_TIMESTAMP | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_2 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-2B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | activatePaymentNotice                       |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice.idempotencyKey       |
            | VALID_TO           | NotNone                                     |
            | HASH_REQUEST       | NotNone                                     |
            | RESPONSE           | NotNone                                     |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify datetime plus number of date default_idempotency_key_validity_minutes of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
            | PSP_ID          | $activatePaymentNotice.idPSP          |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PSP_ID                | #psp#                                       |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | PAYMENT_METHOD        | None                                        |
            | TOUCHPOINT            | None                                        |
            | SUGGESTED_IDBUNDLE    | None                                        |
            | SUGGESTED_IDCIBUNDLE  | None                                        |
            | SUGGESTED_USER_FEE    | None                                        |
            | SUGGESTED_PA_FEE      | None                                        |
            | PAYMENT_NOTE          | responseFull                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | DESCRIPTION        | NotNone                             |
            | COMPANY_NAME       | NotNone                             |
            | OFFICE_NAME        | None                                |
            | DEBTOR_ID          | None                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                              |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice.idempotencyKey       |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | None                                |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
            | METADATA                 | None                                |
            | REQ_TIPO_BOLLO           | None                                |
            | REQ_HASH_DOCUMENTO       | None                                |
            | REQ_PROVINCIA_RESIDENZA  | None                                |
            | COMPANY_NAME_SECONDARY   | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAYING                              |
            | INSERTED_TIMESTAMP | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_3 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-3B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 30
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | activatePaymentNotice                       |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice.idempotencyKey       |
            | VALID_TO           | NotNone                                     |
            | HASH_REQUEST       | NotNone                                     |
            | RESPONSE           | NotNone                                     |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify datetime plus number of date default_idempotency_key_validity_minutes of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
            | PSP_ID          | $activatePaymentNotice.idPSP          |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PSP_ID                | #psp#                                       |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | PAYMENT_METHOD        | None                                        |
            | TOUCHPOINT            | None                                        |
            | SUGGESTED_IDBUNDLE    | None                                        |
            | SUGGESTED_IDCIBUNDLE  | None                                        |
            | SUGGESTED_USER_FEE    | None                                        |
            | SUGGESTED_PA_FEE      | None                                        |
            | PAYMENT_NOTE          | responseFull                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | DESCRIPTION        | NotNone                             |
            | COMPANY_NAME       | NotNone                             |
            | OFFICE_NAME        | None                                |
            | DEBTOR_ID          | None                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                              |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice.idempotencyKey       |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | None                                |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
            | METADATA                 | None                                |
            | REQ_TIPO_BOLLO           | None                                |
            | REQ_HASH_DOCUMENTO       | None                                |
            | REQ_PROVINCIA_RESIDENZA  | None                                |
            | COMPANY_NAME_SECONDARY   | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAYING                              |
            | INSERTED_TIMESTAMP | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_4 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-4B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | activatePaymentNotice                       |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice.idempotencyKey       |
            | VALID_TO           | NotNone                                     |
            | HASH_REQUEST       | NotNone                                     |
            | RESPONSE           | NotNone                                     |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify datetime plus number of date minutes:60000 of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
            | PSP_ID          | $activatePaymentNotice.idPSP          |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PSP_ID                | #psp#                                       |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | PAYMENT_METHOD        | None                                        |
            | TOUCHPOINT            | None                                        |
            | SUGGESTED_IDBUNDLE    | None                                        |
            | SUGGESTED_IDCIBUNDLE  | None                                        |
            | SUGGESTED_USER_FEE    | None                                        |
            | SUGGESTED_PA_FEE      | None                                        |
            | PAYMENT_NOTE          | responseFull                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | DESCRIPTION        | NotNone                             |
            | COMPANY_NAME       | NotNone                             |
            | OFFICE_NAME        | None                                |
            | DEBTOR_ID          | None                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                              |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice.idempotencyKey       |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | None                                |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
            | METADATA                 | None                                |
            | REQ_TIPO_BOLLO           | None                                |
            | REQ_HASH_DOCUMENTO       | None                                |
            | REQ_PROVINCIA_RESIDENZA  | None                                |
            | COMPANY_NAME_SECONDARY   | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAYING                              |
            | INSERTED_TIMESTAMP | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_5 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-5B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 2
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 240000         |
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | activatePaymentNotice                       |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice.idempotencyKey       |
            | VALID_TO           | NotNone                                     |
            | HASH_REQUEST       | NotNone                                     |
            | RESPONSE           | NotNone                                     |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify datetime plus number of date default_idempotency_key_validity_minutes of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
            | PSP_ID          | $activatePaymentNotice.idPSP          |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PSP_ID                | #psp#                                       |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | PAYMENT_METHOD        | None                                        |
            | TOUCHPOINT            | None                                        |
            | SUGGESTED_IDBUNDLE    | None                                        |
            | SUGGESTED_IDCIBUNDLE  | None                                        |
            | SUGGESTED_USER_FEE    | None                                        |
            | SUGGESTED_PA_FEE      | None                                        |
            | PAYMENT_NOTE          | responseFull                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | DESCRIPTION        | NotNone                             |
            | COMPANY_NAME       | NotNone                             |
            | OFFICE_NAME        | None                                |
            | DEBTOR_ID          | None                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                              |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice.idempotencyKey       |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | None                                |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
            | METADATA                 | None                                |
            | REQ_TIPO_BOLLO           | None                                |
            | REQ_HASH_DOCUMENTO       | None                                |
            | REQ_PROVINCIA_RESIDENZA  | None                                |
            | COMPANY_NAME_SECONDARY   | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAYING                              |
            | INSERTED_TIMESTAMP | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_6 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-6B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 2
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 120000         |
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | activatePaymentNotice                       |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice.idempotencyKey       |
            | VALID_TO           | NotNone                                     |
            | HASH_REQUEST       | NotNone                                     |
            | RESPONSE           | NotNone                                     |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify datetime plus number of date default_idempotency_key_validity_minutes of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
            | PSP_ID          | $activatePaymentNotice.idPSP          |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PSP_ID                | #psp#                                       |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | PAYMENT_METHOD        | None                                        |
            | TOUCHPOINT            | None                                        |
            | SUGGESTED_IDBUNDLE    | None                                        |
            | SUGGESTED_IDCIBUNDLE  | None                                        |
            | SUGGESTED_USER_FEE    | None                                        |
            | SUGGESTED_PA_FEE      | None                                        |
            | PAYMENT_NOTE          | responseFull                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | DESCRIPTION        | NotNone                             |
            | COMPANY_NAME       | NotNone                             |
            | OFFICE_NAME        | None                                |
            | DEBTOR_ID          | None                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                              |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice.idempotencyKey       |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | None                                |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
            | METADATA                 | None                                |
            | REQ_TIPO_BOLLO           | None                                |
            | REQ_HASH_DOCUMENTO       | None                                |
            | REQ_PROVINCIA_RESIDENZA  | None                                |
            | COMPANY_NAME_SECONDARY   | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAYING                              |
            | INSERTED_TIMESTAMP | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |



    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_7 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-7B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            |       | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_ACTIVATE
        And verify 0 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_SERVICE
        And verify 0 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_PLAN
        And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And verify 0 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_8 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-8B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP          | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | pspSconosciuto | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PSP_SCONOSCIUTO of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PRIMITIVA          | activatePaymentNotice                 |
            | PSP_ID             | $activatePaymentNotice.idPSP          |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode     |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber   |
            | TOKEN              | None                                  |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice.idempotencyKey |
            | VALID_TO           | NotNone                               |
            | HASH_REQUEST       | NotNone                               |
            | RESPONSE           | NotNone                               |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        And verify datetime plus number of date 1 of the record at column VALID_TO of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
            | PSP_ID          | $activatePaymentNotice.idPSP          |
        # POSITION_ACTIVATE
        And verify 0 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_SERVICE
        And verify 0 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_PLAN
        And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And verify 0 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_9 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-9B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_Errore_Response initial XML paaAttivaRPT
            |  |
            |  |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                 |
            | ID                    | NotNone                               |
            | CREDITOR_REFERENCE_ID | $iuv                                  |
            | PSP_ID                | #psp#                                 |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey |
            | PAYMENT_TOKEN         | NotNone                               |
            | TOKEN_VALID_FROM      | None                                  |
            | TOKEN_VALID_TO        | None                                  |
            | DUE_DATE              | 2021-12-31 00:00:00                   |
            | AMOUNT                | $activatePaymentNotice.amount         |
            | INSERTED_TIMESTAMP    | NotNone                               |
            | UPDATED_TIMESTAMP     | NotNone                               |
            | INSERTED_BY           | activatePaymentNotice                 |
            | UPDATED_BY            | activatePaymentNotice                 |
            | PAYMENT_METHOD        | None                                  |
            | TOUCHPOINT            | None                                  |
            | SUGGESTED_IDBUNDLE    | None                                  |
            | SUGGESTED_IDCIBUNDLE  | None                                  |
            | SUGGESTED_USER_FEE    | None                                  |
            | SUGGESTED_PA_FEE      | None                                  |
            | PAYMENT_NOTE          | responseFull                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And verify 0 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_PLAN
        And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And verify 0 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_10 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-10B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            |       | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of activatePaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002#iuv#     | 60000          | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PSP_ID                | #psp#                                       |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice.idempotencyKey       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | PAYMENT_METHOD        | None                                        |
            | TOUCHPOINT            | None                                        |
            | SUGGESTED_IDBUNDLE    | None                                        |
            | SUGGESTED_IDCIBUNDLE  | None                                        |
            | SUGGESTED_USER_FEE    | None                                        |
            | SUGGESTED_PA_FEE      | None                                        |
            | PAYMENT_NOTE          | responseFull                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | DESCRIPTION        | NotNone                             |
            | COMPANY_NAME       | NotNone                             |
            | OFFICE_NAME        | None                                |
            | DEBTOR_ID          | None                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                              |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice.idempotencyKey       |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | None                                |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
            | METADATA                 | None                                |
            | REQ_TIPO_BOLLO           | None                                |
            | REQ_HASH_DOCUMENTO       | None                                |
            | REQ_PROVINCIA_RESIDENZA  | None                                |
            | COMPANY_NAME_SECONDARY   | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAYING                              |
            | INSERTED_TIMESTAMP | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |