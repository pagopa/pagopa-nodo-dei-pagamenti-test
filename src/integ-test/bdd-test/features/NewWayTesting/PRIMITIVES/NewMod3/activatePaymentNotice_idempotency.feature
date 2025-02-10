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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_11 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-11B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | Password01 | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002$iuv      | 60000          | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_12 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-12B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002$iuv      | 60000          | 10.00  |
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
        # RE CRONOLOGIA EVENTI REQ E RESP
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column            | value                                                                                                                                                         |
            | tipo_evento       | activatePaymentNotice,paaAttivaRPT,paaAttivaRPT,activatePaymentNotice,activatePaymentNotice,activatePaymentNotice,activatePaymentNotice,activatePaymentNotice |
            | sotto_tipo_evento | REQ,REQ,RESP,INTERN,INTERN,RESP,REQ,RESP                                                                                                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |



    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_13 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-13B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002$iuv      | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                          |
            | ID                 | NotNone                                        |
            | PRIMITIVA          | activatePaymentNotice                          |
            | PSP_ID             | $activatePaymentNotice.idPSP                   |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode              |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber            |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone                                        |
            | HASH_REQUEST       | NotNone                                        |
            | RESPONSE           | NotNone                                        |
            | INSERTED_TIMESTAMP | NotNone                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
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
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | $iuv                                           |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                                       |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | $iuv                                           |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | $iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                         |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_14 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-14B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                            | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_secondary# | 002$iuv      | 60000          | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                          |
            | ID                 | NotNone                                        |
            | PRIMITIVA          | activatePaymentNotice                          |
            | PSP_ID             | $activatePaymentNotice_1Request.idPSP          |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode     |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber   |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone                                        |
            | HASH_REQUEST       | NotNone                                        |
            | RESPONSE           | NotNone                                        |
            | INSERTED_TIMESTAMP | NotNone                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
            | PA_FISCAL_CODE  | $activatePaymentNotice_1Request.fiscalCode     |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | $iuv                                           |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                                       |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | $iuv                                           |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | $iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                         |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_15 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-15B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And replace $iuv content with IUV content
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002#iuv#     | 60000          | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                          |
            | ID                 | NotNone                                        |
            | PRIMITIVA          | activatePaymentNotice                          |
            | PSP_ID             | $activatePaymentNotice_1Request.idPSP          |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode     |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber   |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone                                        |
            | HASH_REQUEST       | NotNone                                        |
            | RESPONSE           | NotNone                                        |
            | INSERTED_TIMESTAMP | NotNone                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
            | PA_FISCAL_CODE  | $activatePaymentNotice_1Request.fiscalCode     |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | NotNone                                        |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | NotNone                                    |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | NotNone                                        |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | NotNone                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | NotNone                                      |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_16 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-16B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey    | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #idempotency_key# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_noExpiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002$iuv      | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                          |
            | ID                 | NotNone                                        |
            | PRIMITIVA          | activatePaymentNotice                          |
            | PSP_ID             | $activatePaymentNotice_1Request.idPSP          |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode     |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber   |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone                                        |
            | HASH_REQUEST       | NotNone                                        |
            | RESPONSE           | NotNone                                        |
            | INSERTED_TIMESTAMP | NotNone                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
            | PA_FISCAL_CODE  | $activatePaymentNotice_1Request.fiscalCode     |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | NotNone                                        |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | NotNone                                    |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | NotNone                                        |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | NotNone                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | NotNone                                      |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_17 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-17B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002$iuv      | 60000          | 8.00   |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                          |
            | ID                 | NotNone                                        |
            | PRIMITIVA          | activatePaymentNotice                          |
            | PSP_ID             | $activatePaymentNotice_1Request.idPSP          |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode     |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber   |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone                                        |
            | HASH_REQUEST       | NotNone                                        |
            | RESPONSE           | NotNone                                        |
            | INSERTED_TIMESTAMP | NotNone                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
            | PA_FISCAL_CODE  | $activatePaymentNotice_1Request.fiscalCode     |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | NotNone                                        |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | NotNone                                    |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | NotNone                                        |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | NotNone                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | NotNone                                      |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_18 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-18B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter scheduler.jobName_idempotencyCacheClean.enabled on configuration keys with value false
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 1
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        And wait 65 seconds for expiration
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode  | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | 44444444444 | 002$iuv      | 60000          | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                          |
            | ID                 | NotNone                                        |
            | PRIMITIVA          | activatePaymentNotice                          |
            | PSP_ID             | $activatePaymentNotice_1Request.idPSP          |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode     |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber   |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone                                        |
            | HASH_REQUEST       | NotNone                                        |
            | RESPONSE           | NotNone                                        |
            | INSERTED_TIMESTAMP | NotNone                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
            | PA_FISCAL_CODE  | $activatePaymentNotice_1Request.fiscalCode     |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | NotNone                                        |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | NotNone                                    |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | NotNone                                        |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | NotNone                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | NotNone                                      |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 2 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_19 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-19B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 1
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        And wait 65 seconds for expiration
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_noExpiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002$iuv      | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                                                         |
            | ID                 | NotNone,NotNone                                                                               |
            | PRIMITIVA          | activatePaymentNotice,activatePaymentNotice                                                   |
            | PSP_ID             | $activatePaymentNotice.idPSP,$activatePaymentNotice.idPSP                                     |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode                           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber,$activatePaymentNotice.noticeNumber                       |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken,None                                            |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey,$activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone,NotNone                                                                               |
            | HASH_REQUEST       | NotNone,NotNone                                                                               |
            | RESPONSE           | NotNone,NotNone                                                                               |
            | INSERTED_TIMESTAMP | NotNone,NotNone                                                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | $iuv                                           |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                                       |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | $iuv                                           |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | $iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                         |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |



    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_20 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-20B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 002#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        And wait 3 seconds for expiration
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_noExpiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                      | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_old# | 002$iuv      | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                                                         |
            | ID                 | NotNone,NotNone                                                                               |
            | PRIMITIVA          | activatePaymentNotice,activatePaymentNotice                                                   |
            | PSP_ID             | $activatePaymentNotice.idPSP,$activatePaymentNotice.idPSP                                     |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode                           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber,$activatePaymentNotice.noticeNumber                       |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken,None                                            |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey,$activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone,NotNone                                                                               |
            | HASH_REQUEST       | NotNone,NotNone                                                                               |
            | RESPONSE           | NotNone,NotNone                                                                               |
            | INSERTED_TIMESTAMP | NotNone,NotNone                                                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | $iuv                                           |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | None                                         |
            | DEBTOR_ID          | None                                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | $iuv                                       |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | None                                       |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | $iuv                                           |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station_old#                               |
            | STATION_VERSION            | 1                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | $iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $iuv                                         |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | None                                         |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_22 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-22B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 40
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | OFFICE_NAME        | NotNone                             |
            | DEBTOR_ID          | NotNone                             |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | NotNone                           |
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
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_23 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-23B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | OFFICE_NAME        | NotNone                             |
            | DEBTOR_ID          | NotNone                             |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | NotNone                           |
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
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_24 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-24B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 30
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | OFFICE_NAME        | NotNone                             |
            | DEBTOR_ID          | NotNone                             |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | NotNone                           |
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
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_25 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-25B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | OFFICE_NAME        | NotNone                             |
            | DEBTOR_ID          | NotNone                             |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | NotNone                           |
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
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_26 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-26B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 2
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 240000         |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | OFFICE_NAME        | NotNone                             |
            | DEBTOR_ID          | NotNone                             |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | NotNone                           |
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
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_27 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-27B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 2
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | OFFICE_NAME        | NotNone                             |
            | DEBTOR_ID          | NotNone                             |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | NotNone                           |
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
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_28 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-28B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            |       | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_29 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-29B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP          | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | pspSconosciuto | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_30 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-30B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable horizontal paGetPayment_Errore_Response initial XML paGetPayment
            |  |
            |  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                 |
            | ID                    | NotNone                               |
            | CREDITOR_REFERENCE_ID | None                                  |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_31 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-31B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code# | 302$iuv      | 60000          | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
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
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | OFFICE_NAME        | NotNone                             |
            | DEBTOR_ID          | NotNone                             |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNotice.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | NotNone                           |
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
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
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
        # RE CRONOLOGIA EVENTI REQ E RESP
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column            | value                                                                                                                                                         |
            | tipo_evento       | activatePaymentNotice,paGetPayment,paGetPayment,activatePaymentNotice,activatePaymentNotice,activatePaymentNotice,activatePaymentNotice,activatePaymentNotice |
            | sotto_tipo_evento | REQ,REQ,RESP,INTERN,INTERN,RESP,REQ,RESP                                                                                                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_32 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-32B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                            | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code_secondary# | 302$iuv      | 60000          | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And verify 0 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And verify 0 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        # POSITION_TRANSFER
        And verify 0 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_33 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-33B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code# | 302#iuv#     | 60000          | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And verify 0 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And verify 0 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        # POSITION_TRANSFER
        And verify 0 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_34 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-34B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey    | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #idempotency_key# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_noExpiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code# | 302$iuv      | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And verify 1 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And verify 1 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        # POSITION_TRANSFER
        And verify 1 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_35 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-35B)
        Given update parameter useIdempotency on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code# | 302$iuv      | 60000          | 8.00   |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And verify 1 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And verify 1 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        # POSITION_TRANSFER
        And verify 1 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_36 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-36B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 1
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice_1
        And wait 65 seconds for expiration
        Given from body with datatable horizontal activatePaymentNoticeBody_with_idempotency_noExpiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey                        | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.idempotencyKey | #creditor_institution_code# | 302$iuv      | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                                                         |
            | ID                 | NotNone,NotNone                                                                               |
            | PRIMITIVA          | activatePaymentNotice,activatePaymentNotice                                                   |
            | PSP_ID             | $activatePaymentNotice.idPSP,$activatePaymentNotice.idPSP                                     |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode,$activatePaymentNotice.fiscalCode                           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber,$activatePaymentNotice.noticeNumber                       |
            | TOKEN              | $activatePaymentNotice_1Response.paymentToken,None                                            |
            | IDEMPOTENCY_KEY    | $activatePaymentNotice_1Request.idempotencyKey,$activatePaymentNotice_1Request.idempotencyKey |
            | VALID_TO           | NotNone,NotNone                                                                               |
            | HASH_REQUEST       | NotNone,NotNone                                                                               |
            | RESPONSE           | NotNone,NotNone                                                                               |
            | INSERTED_TIMESTAMP | NotNone,NotNone                                                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                   |
            | IDEMPOTENCY_KEY | $activatePaymentNotice_1Request.idempotencyKey |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | CREDITOR_REFERENCE_ID | 02$iuv                                         |
            | PSP_ID                | #psp#                                          |
            | IDEMPOTENCY_KEY       | $activatePaymentNotice_1Request.idempotencyKey |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken  |
            | TOKEN_VALID_FROM      | NotNone                                        |
            | TOKEN_VALID_TO        | NotNone                                        |
            | DUE_DATE              | 2021-12-31 00:00:00                            |
            | AMOUNT                | $activatePaymentNotice_1Request.amount         |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | UPDATED_TIMESTAMP     | NotNone                                        |
            | INSERTED_BY           | activatePaymentNotice                          |
            | UPDATED_BY            | activatePaymentNotice                          |
            | PAYMENT_METHOD        | None                                           |
            | TOUCHPOINT            | None                                           |
            | SUGGESTED_IDBUNDLE    | None                                           |
            | SUGGESTED_IDCIBUNDLE  | None                                           |
            | SUGGESTED_USER_FEE    | None                                           |
            | SUGGESTED_PA_FEE      | None                                           |
            | PAYMENT_NOTE          | responseFull                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | DESCRIPTION        | NotNone                                      |
            | COMPANY_NAME       | NotNone                                      |
            | OFFICE_NAME        | NotNone                                      |
            | DEBTOR_ID          | NotNone                                      |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | UPDATED_TIMESTAMP  | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
            | UPDATED_BY         | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                      |
            | ID                    | NotNone                                    |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode |
            | CREDITOR_REFERENCE_ID | 02$iuv                                     |
            | DUE_DATE              | NotNone                                    |
            | RETENTION_DATE        | None                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount     |
            | FLAG_FINAL_PAYMENT    | Y                                          |
            | INSERTED_TIMESTAMP    | NotNone                                    |
            | UPDATED_TIMESTAMP     | NotNone                                    |
            | METADATA              | NotNone                                    |
            | FK_POSITION_SERVICE   | NotNone                                    |
            | INSERTED_BY           | activatePaymentNotice                      |
            | UPDATED_BY            | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                          |
            | ID                         | NotNone                                        |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode     |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                         |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken  |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode     |
            | STATION_ID                 | #id_station#                                   |
            | STATION_VERSION            | 2                                              |
            | PSP_ID                     | #psp#                                          |
            | BROKER_PSP_ID              | #id_broker_psp#                                |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                   |
            | IDEMPOTENCY_KEY            | $activatePaymentNotice_1Request.idempotencyKey |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount         |
            | FEE                        | None                                           |
            | OUTCOME                    | None                                           |
            | PAYMENT_METHOD             | None                                           |
            | PAYMENT_CHANNEL            | NA                                             |
            | TRANSFER_DATE              | None                                           |
            | PAYER_ID                   | None                                           |
            | APPLICATION_DATE           | None                                           |
            | INSERTED_TIMESTAMP         | NotNone                                        |
            | UPDATED_TIMESTAMP          | NotNone                                        |
            | FK_PAYMENT_PLAN            | NotNone                                        |
            | RPT_ID                     | None                                           |
            | PAYMENT_TYPE               | MOD3                                           |
            | CARRELLO_ID                | None                                           |
            | ORIGINAL_PAYMENT_TOKEN     | None                                           |
            | FLAG_IO                    | N                                              |
            | RICEVUTA_PM                | None                                           |
            | FLAG_ACTIVATE_RESP_MISSING | None                                           |
            | FLAG_PAYPAL                | None                                           |
            | INSERTED_BY                | activatePaymentNotice                          |
            | UPDATED_BY                 | activatePaymentNotice                          |
            | TRANSACTION_ID             | None                                           |
            | CLOSE_VERSION              | None                                           |
            | FEE_PA                     | None                                           |
            | BUNDLE_ID                  | None                                           |
            | BUNDLE_PA_ID               | None                                           |
            | PM_INFO                    | None                                           |
            | MBD                        | N                                              |
            | FEE_SPO                    | None                                           |
            | PAYMENT_NOTE               | responseFull                                   |
            | FLAG_STANDIN               | N                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber  |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNotice                         |
            | UPDATED_BY            | activatePaymentNotice                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | NOTICE_ID                | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID    | 02$iuv                                       |
            | PA_FISCAL_CODE           | $activatePaymentNotice_1Request.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount       |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | NotNone                                      |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNotice                        |
            | UPDATED_BY               | activatePaymentNotice                        |
            | METADATA                 | None                                         |
            | REQ_TIPO_BOLLO           | None                                         |
            | REQ_HASH_DOCUMENTO       | None                                         |
            | REQ_PROVINCIA_RESIDENZA  | None                                         |
            | COMPANY_NAME_SECONDARY   | None                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
            | INSERTED_BY        | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                       |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS              | PAYING                                       |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
            | FK_POSITION_SERVICE | NotNone                                      |
            | ACTIVATION_PENDING  | N                                            |
            | INSERTED_BY         | activatePaymentNotice                        |
            | UPDATED_BY          | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |