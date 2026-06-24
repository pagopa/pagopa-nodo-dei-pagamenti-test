Feature: NM3 flows PA New con pagamento OK  event

  Background:
    Given systems up


    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_1
    Scenario: NM3 flow OK, FLOW con PSP activate vp2 PSP spo vp1: verify -> paVerify activateV2 -> paGetPayment spo+ -> paSendRT BIZ+ (no touchpoint no paymentchannel)(NM3-66)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full_noTouchpoint initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full_noPaymentChannel initial XML sendPaymentOutcome
        | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
        | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | NotNone                                       |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | None                                          |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | NotNone                             |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | #intermediarioPA#                             |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #id_broker_psp#                               |
        | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                  |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2.00                                          |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | NA                                            |
        | TRANSFER_DATE              | NotNone                                       |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | NotNone                                       |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcome                            |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2.00                                          |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                     |
        | ID                    | NotNone                                                                                   |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                     |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                         |
        | INSERTED_TIMESTAMP    | NotNone                                                                                   |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                         |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                             |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                               |
        | ID                 | NotNone                                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                 |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber               |
        | STATUS             | PAYING,PAID,NOTIFIED                                |
        | INSERTED_TIMESTAMP | NotNone                                             |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcome                    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        ### POSITION_RETRY_PA_SEND_RT
        And verify 0 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | RECEIPT_ID            | $activatePaymentNoticeV2Response.paymentToken |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | OUTCOME               | OK                                            |
        | PAYMENT_AMOUNT        | $activatePaymentNoticeV2.amount               |
        | DESCRIPTION           | pagamentoTest                                 |
        | COMPANY_NAME          | company                                       |
        | OFFICE_NAME           | office                                        |
        | DEBTOR_ID             | NotNone                                       |
        | PSP_ID                | #psp#                                         |
        | PSP_FISCAL_CODE       | NotNone                                       |
        | PSP_VAT_NUMBER        | None                                          |
        | PSP_COMPANY_NAME      | NotNone                                       |
        | CHANNEL_ID            | #canale_ATTIVATO_PRESSO_PSP#                  |
        | CHANNEL_DESCRIPTION   | NA                                            |
        | PAYER_ID              | NotNone                                       |
        | FEE                   | 2.00                                          |
        | PAYMENT_METHOD        | creditCard                                    |
        | PAYMENT_DATE_TIME     | NotNone                                       |
        | APPLICATION_DATE      | NotNone                                       |
        | TRANSFER_DATE         | NotNone                                       |
        | METADATA              | NotNone                                       |
        | RT_ID                 | None                                          |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        | FEE_PA                | None                                          |
        | BUNDLE_ID             | None                                          |
        | BUNDLE_PA_ID          | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_XML
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | XML                   | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_RECIPIENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | FK_RECEIPT_XML        | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paSendRT                                      |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_2
    Scenario: NM3 flow OK, FLOW: verify -> paVerify activateV2 -> paGetPayment --> spoV2+ -> paSendRT BIZ+ (no touchpoint no paymentchannel)(NM3-9)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full_noTouchpoint initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full_noPaymentChannel initial XML sendPaymentOutcomeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | 2021-12-31 00:00:00                           |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | None                                          |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | 2021-12-31 00:00:00                 |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #intermediarioPSP2#                           |
        | CHANNEL_ID                 | #canale32#                                    |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2                                             |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | NA                                            |
        | TRANSFER_DATE              | 2021-12-11                                    |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | 2021-12-12                                    |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcomeV2                          |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2                                             |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                           |
        | ID                    | NotNone                                                                                         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                             |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                           |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                               |
        | INSERTED_TIMESTAMP    | NotNone                                                                                         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                               |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                   |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcomeV2                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                                 |
        | ID                 | NotNone                                               |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                   |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber                 |
        | STATUS             | PAYING,PAID,NOTIFIED                                  |
        | INSERTED_TIMESTAMP | NotNone                                               |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcomeV2                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale32# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
        And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
        And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | REQ                                           |
        | ESITO                    | INVIATA                                       |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        ### TRANSFER 1
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale32# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_3
    Scenario: NM3 flow OK, FLOW con PSP activate vp2 PSP spo vp1: verify -> paVerify activateV2 -> paGetPayment spo+ -> paSendRT BIZ+ (no touchpoint e si paymentchannel)(NM3-66)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full_noTouchpoint initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
        | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
        | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | NotNone                                       |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | None                                          |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | NotNone                             |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | #intermediarioPA#                             |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #id_broker_psp#                               |
        | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                  |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2.00                                          |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | app                                           |
        | TRANSFER_DATE              | NotNone                                       |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | NotNone                                       |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcome                            |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2.00                                          |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                     |
        | ID                    | NotNone                                                                                   |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                     |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                         |
        | INSERTED_TIMESTAMP    | NotNone                                                                                   |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                         |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                             |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                               |
        | ID                 | NotNone                                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                 |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber               |
        | STATUS             | PAYING,PAID,NOTIFIED                                |
        | INSERTED_TIMESTAMP | NotNone                                             |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcome                    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        ### POSITION_RETRY_PA_SEND_RT
        And verify 0 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | RECEIPT_ID            | $activatePaymentNoticeV2Response.paymentToken |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | OUTCOME               | OK                                            |
        | PAYMENT_AMOUNT        | $activatePaymentNoticeV2.amount               |
        | DESCRIPTION           | pagamentoTest                                 |
        | COMPANY_NAME          | company                                       |
        | OFFICE_NAME           | office                                        |
        | DEBTOR_ID             | NotNone                                       |
        | PSP_ID                | #psp#                                         |
        | PSP_FISCAL_CODE       | NotNone                                       |
        | PSP_VAT_NUMBER        | None                                          |
        | PSP_COMPANY_NAME      | NotNone                                       |
        | CHANNEL_ID            | #canale_ATTIVATO_PRESSO_PSP#                  |
        | CHANNEL_DESCRIPTION   | app                                           |
        | PAYER_ID              | NotNone                                       |
        | FEE                   | 2.00                                          |
        | PAYMENT_METHOD        | creditCard                                    |
        | PAYMENT_DATE_TIME     | NotNone                                       |
        | APPLICATION_DATE      | NotNone                                       |
        | TRANSFER_DATE         | NotNone                                       |
        | METADATA              | NotNone                                       |
        | RT_ID                 | None                                          |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        | FEE_PA                | None                                          |
        | BUNDLE_ID             | None                                          |
        | BUNDLE_PA_ID          | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_XML
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | XML                   | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_RECIPIENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | FK_RECEIPT_XML        | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paSendRT                                      |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_4
    Scenario: NM3 flow OK, FLOW: verify -> paVerify activateV2 -> paGetPayment --> spoV2+ -> paSendRT BIZ+ (no touchpoint e si paymentchannel)(NM3-9)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full_noTouchpoint initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | 2021-12-31 00:00:00                           |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | None                                          |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | 2021-12-31 00:00:00                 |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #intermediarioPSP2#                           |
        | CHANNEL_ID                 | #canale32#                                    |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2                                             |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | app                                           |
        | TRANSFER_DATE              | 2021-12-11                                    |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | 2021-12-12                                    |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcomeV2                          |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2                                             |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                           |
        | ID                    | NotNone                                                                                         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                             |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                           |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                               |
        | INSERTED_TIMESTAMP    | NotNone                                                                                         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                               |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                   |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcomeV2                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                                 |
        | ID                 | NotNone                                               |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                   |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber                 |
        | STATUS             | PAYING,PAID,NOTIFIED                                  |
        | INSERTED_TIMESTAMP | NotNone                                               |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcomeV2                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale32# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
        And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
        And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | REQ                                           |
        | ESITO                    | INVIATA                                       |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        ### TRANSFER 1
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale32# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_5
    Scenario: NM3 flow OK, FLOW con PSP activate vp2 PSP spo vp1: verify -> paVerify activateV2 -> paGetPayment spo+ -> paSendRT BIZ+ (si touchpoint e no paymentchannel)(NM3-66)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full_noPaymentChannel initial XML sendPaymentOutcome
        | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
        | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | NotNone                                       |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | POS                                           |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | NotNone                             |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | #intermediarioPA#                             |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #id_broker_psp#                               |
        | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                  |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2.00                                          |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | NA                                            |
        | TRANSFER_DATE              | NotNone                                       |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | NotNone                                       |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcome                            |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2.00                                          |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                     |
        | ID                    | NotNone                                                                                   |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                     |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                         |
        | INSERTED_TIMESTAMP    | NotNone                                                                                   |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                         |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                             |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                               |
        | ID                 | NotNone                                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                 |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber               |
        | STATUS             | PAYING,PAID,NOTIFIED                                |
        | INSERTED_TIMESTAMP | NotNone                                             |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcome                    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        ### POSITION_RETRY_PA_SEND_RT
        And verify 0 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | RECEIPT_ID            | $activatePaymentNoticeV2Response.paymentToken |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | OUTCOME               | OK                                            |
        | PAYMENT_AMOUNT        | $activatePaymentNoticeV2.amount               |
        | DESCRIPTION           | pagamentoTest                                 |
        | COMPANY_NAME          | company                                       |
        | OFFICE_NAME           | office                                        |
        | DEBTOR_ID             | NotNone                                       |
        | PSP_ID                | #psp#                                         |
        | PSP_FISCAL_CODE       | NotNone                                       |
        | PSP_VAT_NUMBER        | None                                          |
        | PSP_COMPANY_NAME      | NotNone                                       |
        | CHANNEL_ID            | #canale_ATTIVATO_PRESSO_PSP#                  |
        | CHANNEL_DESCRIPTION   | NA                                            |
        | PAYER_ID              | NotNone                                       |
        | FEE                   | 2.00                                          |
        | PAYMENT_METHOD        | creditCard                                    |
        | PAYMENT_DATE_TIME     | NotNone                                       |
        | APPLICATION_DATE      | NotNone                                       |
        | TRANSFER_DATE         | NotNone                                       |
        | METADATA              | NotNone                                       |
        | RT_ID                 | None                                          |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        | FEE_PA                | None                                          |
        | BUNDLE_ID             | None                                          |
        | BUNDLE_PA_ID          | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_XML
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | XML                   | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_RECIPIENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | FK_RECEIPT_XML        | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paSendRT                                      |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_6
    Scenario: NM3 flow OK, FLOW: verify -> paVerify activateV2 -> paGetPayment --> spoV2+ -> paSendRT BIZ+ (si touchpoint e no paymentchannel)(NM3-9)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full_noPaymentChannel initial XML sendPaymentOutcomeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | 2021-12-31 00:00:00                           |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | POS                                           |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | 2021-12-31 00:00:00                 |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #intermediarioPSP2#                           |
        | CHANNEL_ID                 | #canale32#                                    |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2                                             |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | NA                                            |
        | TRANSFER_DATE              | 2021-12-11                                    |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | 2021-12-12                                    |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcomeV2                          |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2                                             |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                           |
        | ID                    | NotNone                                                                                         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                             |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                           |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                               |
        | INSERTED_TIMESTAMP    | NotNone                                                                                         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                               |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                   |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcomeV2                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                                 |
        | ID                 | NotNone                                               |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                   |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber                 |
        | STATUS             | PAYING,PAID,NOTIFIED                                  |
        | INSERTED_TIMESTAMP | NotNone                                               |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcomeV2                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale32# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
        And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
        And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | REQ                                           |
        | ESITO                    | INVIATA                                       |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        ### TRANSFER 1
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale32# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_7
    Scenario: NM3 flow OK, FLOW con PSP activate vp2 PSP spo vp1: verify -> paVerify activateV2 -> paGetPayment spo+ -> paSendRT BIZ+ (no touchpoint no paymentchannel)(NM3-66)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full_noTouchpoint initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full_noPaymentChannel initial XML sendPaymentOutcome
        | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
        | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | NotNone                                       |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | None                                          |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | NotNone                             |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | #intermediarioPA#                             |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #id_broker_psp#                               |
        | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                  |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2.00                                          |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | NA                                            |
        | TRANSFER_DATE              | NotNone                                       |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | NotNone                                       |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcome                            |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2.00                                          |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                     |
        | ID                    | NotNone                                                                                   |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                     |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                         |
        | INSERTED_TIMESTAMP    | NotNone                                                                                   |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                         |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                             |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                               |
        | ID                 | NotNone                                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                 |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber               |
        | STATUS             | PAYING,PAID,NOTIFIED                                |
        | INSERTED_TIMESTAMP | NotNone                                             |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcome                    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        ### POSITION_RETRY_PA_SEND_RT
        And verify 0 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | RECEIPT_ID            | $activatePaymentNoticeV2Response.paymentToken |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | OUTCOME               | OK                                            |
        | PAYMENT_AMOUNT        | $activatePaymentNoticeV2.amount               |
        | DESCRIPTION           | pagamentoTest                                 |
        | COMPANY_NAME          | company                                       |
        | OFFICE_NAME           | office                                        |
        | DEBTOR_ID             | NotNone                                       |
        | PSP_ID                | #psp#                                         |
        | PSP_FISCAL_CODE       | NotNone                                       |
        | PSP_VAT_NUMBER        | None                                          |
        | PSP_COMPANY_NAME      | NotNone                                       |
        | CHANNEL_ID            | #canale_ATTIVATO_PRESSO_PSP#                  |
        | CHANNEL_DESCRIPTION   | NA                                            |
        | PAYER_ID              | NotNone                                       |
        | FEE                   | 2.00                                          |
        | PAYMENT_METHOD        | creditCard                                    |
        | PAYMENT_DATE_TIME     | NotNone                                       |
        | APPLICATION_DATE      | NotNone                                       |
        | TRANSFER_DATE         | NotNone                                       |
        | METADATA              | NotNone                                       |
        | RT_ID                 | None                                          |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        | FEE_PA                | None                                          |
        | BUNDLE_ID             | None                                          |
        | BUNDLE_PA_ID          | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_XML
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | XML                   | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # DB Checks for POSITION_RECEIPT_RECIPIENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_RECEIPT   | NotNone                                       |
        | FK_RECEIPT_XML        | NotNone                                       |
        | INSERTED_BY           | sendPaymentOutcome                            |
        | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcome                            |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paSendRT                                      |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOKBIZ @NM3PANEWPAGOKBIZ_FULL_8
    Scenario: NM3 flow OK, FLOW: verify -> paVerify activateV2 -> paGetPayment --> spoV2+ -> paSendRT BIZ+ (no touchpoint no paymentchannel)(NM3-9)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full_noTouchpoint initial XML activatePaymentNoticeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full_noPaymentChannel initial XML sendPaymentOutcomeV2
        | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
        | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PSP_ID                | #psp#                                         |
        | IDEMPOTENCY_KEY       | NotNone                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                       |
        | TOKEN_VALID_TO        | NotNone                                       |
        | DUE_DATE              | 2021-12-31 00:00:00                           |
        | AMOUNT                | $activatePaymentNoticeV2.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | activatePaymentNoticeV2                       |
        | PAYMENT_METHOD        | CP                                            |
        | TOUCHPOINT            | None                                          |
        | SUGGESTED_IDBUNDLE    | None                                          |
        | SUGGESTED_IDCIBUNDLE  | None                                          |
        | SUGGESTED_USER_FEE    | None                                          |
        | SUGGESTED_PA_FEE      | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                               |
        | ID                 | NotNone                             |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
        | DESCRIPTION        | pagamentoTest                       |
        | COMPANY_NAME       | company                             |
        | OFFICE_NAME        | office                              |
        | DEBTOR_ID          | NotNone                             |
        | INSERTED_TIMESTAMP | NotNone                             |
        | UPDATED_TIMESTAMP  | NotNone                             |
        | INSERTED_BY        | activatePaymentNoticeV2             |
        | UPDATED_BY         | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                               |
        | ID                    | NotNone                             |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId   |
        | DUE_DATE              | 2021-12-31 00:00:00                 |
        | RETENTION_DATE        | None                                |
        | AMOUNT                | $activatePaymentNoticeV2.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                   |
        | INSERTED_TIMESTAMP    | NotNone                             |
        | UPDATED_TIMESTAMP     | NotNone                             |
        | METADATA              | NotNone                             |
        | FK_POSITION_SERVICE   | NotNone                             |
        | INSERTED_BY           | activatePaymentNoticeV2             |
        | UPDATED_BY            | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                         |
        | ID                         | NotNone                                       |
        | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
        | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
        | STATION_ID                 | #id_station#                                  |
        | STATION_VERSION            | 2                                             |
        | PSP_ID                     | #psp#                                         |
        | BROKER_PSP_ID              | #intermediarioPSP2#                           |
        | CHANNEL_ID                 | #canale32#                                    |
        | IDEMPOTENCY_KEY            | NotNone                                       |
        | AMOUNT                     | $activatePaymentNoticeV2.amount               |
        | FEE                        | 2                                             |
        | OUTCOME                    | OK                                            |
        | PAYMENT_METHOD             | creditCard                                    |
        | PAYMENT_CHANNEL            | NA                                            |
        | TRANSFER_DATE              | 2021-12-11                                    |
        | PAYER_ID                   | NotNone                                       |
        | APPLICATION_DATE           | 2021-12-12                                    |
        | INSERTED_TIMESTAMP         | NotNone                                       |
        | UPDATED_TIMESTAMP          | NotNone                                       |
        | FK_PAYMENT_PLAN            | NotNone                                       |
        | RPT_ID                     | None                                          |
        | PAYMENT_TYPE               | MOD3                                          |
        | CARRELLO_ID                | None                                          |
        | ORIGINAL_PAYMENT_TOKEN     | None                                          |
        | FLAG_IO                    | N                                             |
        | RICEVUTA_PM                | None                                          |
        | FLAG_ACTIVATE_RESP_MISSING | None                                          |
        | FLAG_PAYPAL                | None                                          |
        | INSERTED_BY                | activatePaymentNoticeV2                       |
        | UPDATED_BY                 | sendPaymentOutcomeV2                          |
        | TRANSACTION_ID             | None                                          |
        | CLOSE_VERSION              | None                                          |
        | FEE_PA                     | None                                          |
        | BUNDLE_ID                  | None                                          |
        | BUNDLE_PA_ID               | None                                          |
        | PM_INFO                    | None                                          |
        | MBD                        | N                                             |
        | FEE_SPO                    | 2                                             |
        | PAYMENT_NOTE               | responseFull                                  |
        | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                                 |
        | ID                       | NotNone                               |
        | NOTICE_ID                | $activatePaymentNoticeV2.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId     |
        | PA_FISCAL_CODE           | $activatePaymentNoticeV2.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016           |
        | AMOUNT                   | $activatePaymentNoticeV2.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                      |
        | TRANSFER_CATEGORY        | paGetPaymentTest                      |
        | TRANSFER_IDENTIFIER      | 1                                     |
        | VALID                    | Y                                     |
        | FK_POSITION_PAYMENT      | NotNone                               |
        | INSERTED_TIMESTAMP       | NotNone                               |
        | UPDATED_TIMESTAMP        | NotNone                               |
        | FK_PAYMENT_PLAN          | NotNone                               |
        | INSERTED_BY              | activatePaymentNoticeV2               |
        | UPDATED_BY               | activatePaymentNoticeV2               |
        | METADATA                 | None                                  |
        | REQ_TIPO_BOLLO           | None                                  |
        | REQ_HASH_DOCUMENTO       | None                                  |
        | REQ_PROVINCIA_RESIDENZA  | None                                  |
        | COMPANY_NAME_SECONDARY   | None                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                           |
        | ID                    | NotNone                                                                                         |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                             |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                           |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                               |
        | INSERTED_TIMESTAMP    | NotNone                                                                                         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                               |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                   |
        | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                         |
        | ID                    | NotNone                                       |
        | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
        | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
        | STATUS                | NOTIFIED                                      |
        | INSERTED_TIMESTAMP    | NotNone                                       |
        | UPDATED_TIMESTAMP     | NotNone                                       |
        | FK_POSITION_PAYMENT   | NotNone                                       |
        | INSERTED_BY           | activatePaymentNoticeV2                       |
        | UPDATED_BY            | sendPaymentOutcomeV2                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                                 |
        | ID                 | NotNone                                               |
        | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                   |
        | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber                 |
        | STATUS             | PAYING,PAID,NOTIFIED                                  |
        | INSERTED_TIMESTAMP | NotNone                                               |
        | INSERTED_BY        | activatePaymentNoticeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                                 |
        | ID                  | NotNone                               |
        | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
        | STATUS              | NOTIFIED                              |
        | INSERTED_TIMESTAMP  | NotNone                               |
        | UPDATED_TIMESTAMP   | NotNone                               |
        | FK_POSITION_SERVICE | NotNone                               |
        | ACTIVATION_PENDING  | N                                     |
        | INSERTED_BY         | activatePaymentNoticeV2               |
        | UPDATED_BY          | sendPaymentOutcomeV2                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                          |
        | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                          |
        | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        | ORDER BY   | ID ASC                                |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canale32# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | activatePaymentNoticeV2                       |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                  |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | REQ                                           |
        | ESITO              | RICEVUTA                                      |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
        And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeV2Req.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                  |
        | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
        | SOTTO_TIPO_EVENTO  | RESP                                          |
        | ESITO              | INVIATA                                       |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
        | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
        And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | REQ                                           |
        | ESITO                    | INVIATA                                       |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        ### TRANSFER 1
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale32# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                  |
        | PAYMENT_TOKEN            | $activatePaymentNoticeV2Response.paymentToken |
        | TIPO_EVENTO              | paSendRT                                      |
        | SOTTO_TIPO_EVENTO        | RESP                                          |
        | ESITO                    | RICEVUTA                                      |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                  |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                              |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                        |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0
