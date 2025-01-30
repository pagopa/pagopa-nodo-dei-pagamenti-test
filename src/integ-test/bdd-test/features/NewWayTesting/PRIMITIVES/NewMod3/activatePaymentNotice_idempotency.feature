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
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_2 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-2B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_3 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-3B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 30
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_4 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-4B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_5 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-5B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 2
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 305#iuv#     | 10.00  | 240000         |
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


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_6 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-6B)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 2
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 305#iuv#     | 10.00  | 120000         |
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

    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_7 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-7B)
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
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |


    @ALL @PRIMITIVE @NM3 @NM3ACTIVIDMP_8 @after
    Scenario: NM3 flow OK, FLOW: activatePaymentNotice  (OLD_NM3-8B)
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