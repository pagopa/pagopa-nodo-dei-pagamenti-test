Feature: NMU flows con PA New - activation phase


    Background:
        Given systems up

    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWATTIVAZIONE @NMUPANEWATTIVAZIONE_FULL_1 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp2: checkPosition con 1 nav, activateV2 -> paGetPayment  (OLD-NMU-8)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 40
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        # And wait 1 seconds for expiration
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID                 | NotNone                                       |
            | PRIMITIVA          | activatePaymentNoticeV2                       |
            | PSP_ID             | $activatePaymentNoticeV2.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | VALID_TO           | NotNone                                       |
            | HASH_REQUEST       | NotNone                                       |
            | RESPONSE           | NotNone                                       |
            | INSERTED_TIMESTAMP | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #pspEcommerce#                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | activatePaymentNoticeV2                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | company                 |
            | OFFICE_NAME        | office                  |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                          |
            | DUE_DATE              | NotNone                         |
            | RETENTION_DATE        | None                            |
            | AMOUNT                | $activatePaymentNoticeV2.amount |
            | FLAG_FINAL_PAYMENT    | Y                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | NotNone                         |
            | FK_POSITION_SERVICE   | NotNone                         |
            | INSERTED_BY           | activatePaymentNoticeV2         |
            | UPDATED_BY            | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station#                                  |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #brokerEcommerce#                             |
            | CHANNEL_ID                 | #canaleEcommerce#                             |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | None                                          |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | N                                             |
            | RICEVUTA_PM                | None                                          |
            | FLAG_PAYPAL                | None                                          |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNoticeV2.amount     |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNoticeV2             |
            | UPDATED_BY               | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
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
            | column             | value   |
            | ID                 | NotNone |
            | STATUS             | PAYING  |
            | INSERTED_TIMESTAMP | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAYING  |
            | INSERTED_TIMESTAMP  | NotNone |
            | UPDATED_TIMESTAMP   | NotNone |
            | FK_POSITION_SERVICE | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                  |
            | TRANSACTION_ID | $activatePaymentNoticeV2Response.paymentToken |
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
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
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
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.metadata.mapEntry.key xml check value IBANAPPOGGIO in position 0
        And from $activatePaymentNoticeV2Resp.metadata.mapEntry.value xml check value 22 in position 0
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
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
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
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0




    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWATTIVAZIONE @NMUPANEWATTIVAZIONE_FULL_2
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp2: activateV2 -> paGetPayment -> activateV2 (uguale alla prima) OK (OLD-NMU-16)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #pspEcommerce#                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | activatePaymentNoticeV2                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station#                                  |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #brokerEcommerce#                             |
            | CHANNEL_ID                 | #canaleEcommerce#                             |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | None                                          |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | N                                             |
            | RICEVUTA_PM                | None                                          |
            | FLAG_PAYPAL                | None                                          |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNoticeV2.amount     |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNoticeV2             |
            | UPDATED_BY               | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value   |
            | ID                 | NotNone |
            | STATUS             | PAYING  |
            | INSERTED_TIMESTAMP | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAYING  |
            | INSERTED_TIMESTAMP  | NotNone |
            | UPDATED_TIMESTAMP   | NotNone |
            | FK_POSITION_SERVICE | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID                 | NotNone                                       |
            | PRIMITIVA          | activatePaymentNoticeV2                       |
            | PSP_ID             | $activatePaymentNoticeV2.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | VALID_TO           | NotNone                                       |
            | HASH_REQUEST       | NotNone                                       |
            | RESPONSE           | NotNone                                       |
            | INSERTED_TIMESTAMP | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                      |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2Response.paymentToken','$activatePaymentNoticeV2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                           |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                               |
            | ESITO              | RICEVUTA                                                                                          |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                  |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                               |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                      |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2Response.paymentToken','$activatePaymentNoticeV2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                           |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                              |
            | ESITO              | INVIATA                                                                                           |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                  |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                               |
        # paGetPayment REQ COUNT 1 RECORDS
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                      |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                      |
            | SOTTO_TIPO_EVENTO  | REQ                                               |
            | ESITO              | INVIATA                                           |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                  |
            | ORDER BY           | DATA_ORA_EVENTO ASC                               |
        # paGetPayment RESP COUNT 1 RECORDS
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                      |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                      |
            | SOTTO_TIPO_EVENTO  | RESP                                              |
            | ESITO              | RICEVUTA                                          |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                  |
            | ORDER BY           | DATA_ORA_EVENTO ASC                               |



    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWATTIVAZIONE @NMUPANEWATTIVAZIONE_FULL_3
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 1 nav, activateV2 -> paGetPayment with error response -> KO PPT_STAZIONE_INT_PA_ERRORE_RESPONSE  (OLD_NMU-15)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_Errore_Response initial XML paGetPayment
            | body | empty |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
        And execution query to get value result_query on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And through the query result_query retrieve param paymentToken at position 0 and save it under the key paymentToken
        And wait 1 seconds for expiration
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PRIMITIVA          | activatePaymentNoticeV2               |
            | PSP_ID             | $activatePaymentNoticeV2.idPSP        |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber |
            | TOKEN              | $paymentToken                         |
            | VALID_TO           | NotNone                               |
            | HASH_REQUEST       | NotNone                               |
            | RESPONSE           | NotNone                               |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_ACTIVATE
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        # POSITION_SERVICE
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS
        And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        # POSITION_STATUS
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value             |
            | PAYMENT_TOKEN | $paymentToken     |
            | PSP_ID        | #brokerEcommerce# |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # # RE #####
        # activatePaymentNoticeV2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values            |
            | PAYMENT_TOKEN      | $paymentToken           |
            | TIPO_EVENTO        | activatePaymentNoticeV2 |
            | SOTTO_TIPO_EVENTO  | REQ                     |
            | ESITO              | RICEVUTA                |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)        |
            | ORDER BY           | DATA_ORA_EVENTO ASC     |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values            |
            | PAYMENT_TOKEN      | $paymentToken           |
            | TIPO_EVENTO        | activatePaymentNoticeV2 |
            | SOTTO_TIPO_EVENTO  | RESP                    |
            | ESITO              | INVIATA                 |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)        |
            | ORDER BY           | DATA_ORA_EVENTO ASC     |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value KO in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | PAYMENT_TOKEN      | $paymentToken       |
            | TIPO_EVENTO        | paGetPayment        |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0



    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWATTIVAZIONE @NMUPANEWATTIVAZIONE_FULL_4
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 1 nav, activateV2 with wrong password, activateV2 -> paGetPayment with error response -> KO PPT_ERRORE_IDEMPOTENZA  (OLD_NMU-18)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password  | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | pwdpwdpwf | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNoticeV2 response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_idempotency_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | idempotencyKey                          | noticeNumber                          | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | $activatePaymentNoticeV2.idempotencyKey | $activatePaymentNoticeV2.noticeNumber | 10.00  |
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
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        And wait 1 seconds for expiration
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PRIMITIVA          | activatePaymentNoticeV2               |
            | PSP_ID             | $activatePaymentNoticeV2.idPSP        |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber |
            | TOKEN              | None                                  |
            | VALID_TO           | NotNone                               |
            | HASH_REQUEST       | NotNone                               |
            | RESPONSE           | NotNone                               |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_ACTIVATE
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        # POSITION_SERVICE
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_PLAN
        And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS
        And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |



    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWATTIVAZIONE @NMUPANEWATTIVAZIONE_FULL_5
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp2: activateV2 -> paGetPayment -> activateV2 PPT_PAGAMENTO_IN_CORSO (OLD-NMU-19)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given idPSP with 40000000001 in activatePaymentNoticeV2
        And idBrokerPSP with 40000000001 in activatePaymentNoticeV2
        And idChannel with 40000000001_01 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                          |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                               |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_1.amount               |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | NA                                              |
            | TRANSFER_DATE              | None                                            |
            | PAYER_ID                   | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | None                                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2_1.noticeNumber         |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId               |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 02$iuv                                |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_1.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_1.amount     |
            | REMITTANCE_INFORMATION   | NotNone                               |
            | TRANSFER_CATEGORY        | NotNone                               |
            | TRANSFER_IDENTIFIER      | 1                                     |
            | VALID                    | Y                                     |
            | FK_POSITION_PAYMENT      | NotNone                               |
            | INSERTED_TIMESTAMP       | NotNone                               |
            | UPDATED_TIMESTAMP        | NotNone                               |
            | FK_PAYMENT_PLAN          | NotNone                               |
            | INSERTED_BY              | activatePaymentNoticeV2               |
            | UPDATED_BY               | activatePaymentNoticeV2               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value   |
            | ID                 | NotNone |
            | STATUS             | PAYING  |
            | INSERTED_TIMESTAMP | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAYING  |
            | INSERTED_TIMESTAMP  | NotNone |
            | UPDATED_TIMESTAMP   | NotNone |
            | FK_POSITION_SERVICE | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                |
            | ID                 | NotNone                                              |
            | PRIMITIVA          | activatePaymentNoticeV2                              |
            | PSP_ID             | $activatePaymentNoticeV2_1.idPSP,40000000001         |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode                |
            | NOTICE_ID          | $activatePaymentNoticeV2_1.noticeNumber              |
            | TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken,None |
            | VALID_TO           | NotNone                                              |
            | HASH_REQUEST       | NotNone                                              |
            | RESPONSE           | NotNone                                              |
            | INSERTED_TIMESTAMP | NotNone                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWATTIVAZIONE @NMUPANEWATTIVAZIONE_FULL_6
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 1 nav, activateV2 -> paGetPayment -> OK, activateV2 with different fiscalCode-> KO PPT_ERRORE_IDEMPOTENZA  (OLD_NMU-20)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_idempotency_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode  | idempotencyKey                          | noticeNumber                          | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | 44444444444 | $activatePaymentNoticeV2.idempotencyKey | $activatePaymentNoticeV2.noticeNumber | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | 77777777777                 |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | 44444444444                 |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of activatePaymentNoticeV2 response
        And wait 1 seconds for expiration
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                           |
            | ID                 | NotNone                                         |
            | PRIMITIVA          | activatePaymentNoticeV2                         |
            | PSP_ID             | $activatePaymentNoticeV2_1Request.idPSP         |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | NOTICE_ID          | $activatePaymentNoticeV2_1Request.noticeNumber  |
            | TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | VALID_TO           | NotNone                                         |
            | HASH_REQUEST       | NotNone                                         |
            | RESPONSE           | NotNone                                         |
            | INSERTED_TIMESTAMP | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | company                 |
            | OFFICE_NAME        | office                  |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                    |
            | ID                    | NotNone                                  |
            | CREDITOR_REFERENCE_ID | 02$iuv                                   |
            | DUE_DATE              | NotNone                                  |
            | RETENTION_DATE        | None                                     |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                        |
            | INSERTED_TIMESTAMP    | NotNone                                  |
            | UPDATED_TIMESTAMP     | NotNone                                  |
            | METADATA              | NotNone                                  |
            | FK_POSITION_SERVICE   | NotNone                                  |
            | INSERTED_BY           | activatePaymentNoticeV2                  |
            | UPDATED_BY            | activatePaymentNoticeV2                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                          |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                               |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_1Request.amount        |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | NA                                              |
            | TRANSFER_DATE              | None                                            |
            | PAYER_ID                   | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | None                                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                        |
            | ID                       | NotNone                                      |
            | CREDITOR_REFERENCE_ID    | 02$iuv                                       |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                  |
            | AMOUNT                   | $activatePaymentNoticeV2_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                      |
            | TRANSFER_CATEGORY        | NotNone                                      |
            | TRANSFER_IDENTIFIER      | 1                                            |
            | VALID                    | Y                                            |
            | FK_POSITION_PAYMENT      | NotNone                                      |
            | INSERTED_TIMESTAMP       | NotNone                                      |
            | UPDATED_TIMESTAMP        | NotNone                                      |
            | FK_PAYMENT_PLAN          | NotNone                                      |
            | INSERTED_BY              | activatePaymentNoticeV2                      |
            | UPDATED_BY               | activatePaymentNoticeV2                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                      |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | NOTICE_ID             | $activatePaymentNoticeV2_1Request.noticeNumber  |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                      |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                      |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                         |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value   |
            | ID                 | NotNone |
            | STATUS             | PAYING  |
            | INSERTED_TIMESTAMP | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAYING  |
            | INSERTED_TIMESTAMP  | NotNone |
            | UPDATED_TIMESTAMP   | NotNone |
            | FK_POSITION_SERVICE | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                      |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                         |
        # RE #####
        # activatePaymentNoticeV2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        # activatePaymentNoticeV2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2_1Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0




    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWATTIVAZIONE @NMUPANEWATTIVAZIONE_FULL_7 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp2: activateV2 -> paGetPayment -> activateV2 PPT_PAGAMENTO_IN_CORSO (OLD-NMU-24)
        Given update parameter default_idempotency_key_validity_minutes on configuration keys with value 1
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                           |
            | ID                 | NotNone                                         |
            | PRIMITIVA          | activatePaymentNoticeV2                         |
            | PSP_ID             | $activatePaymentNoticeV2_1.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNoticeV2_1.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | VALID_TO           | NotNone                                         |
            | HASH_REQUEST       | NotNone                                         |
            | RESPONSE           | NotNone                                         |
            | INSERTED_TIMESTAMP | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        And wait 62 seconds for expiration
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                          |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                               |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_1.amount               |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | NA                                              |
            | TRANSFER_DATE              | None                                            |
            | PAYER_ID                   | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | None                                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2_1.noticeNumber         |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId               |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 02$iuv                                |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_1.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_1.amount     |
            | REMITTANCE_INFORMATION   | NotNone                               |
            | TRANSFER_CATEGORY        | NotNone                               |
            | TRANSFER_IDENTIFIER      | 1                                     |
            | VALID                    | Y                                     |
            | FK_POSITION_PAYMENT      | NotNone                               |
            | INSERTED_TIMESTAMP       | NotNone                               |
            | UPDATED_TIMESTAMP        | NotNone                               |
            | FK_PAYMENT_PLAN          | NotNone                               |
            | INSERTED_BY              | activatePaymentNoticeV2               |
            | UPDATED_BY               | activatePaymentNoticeV2               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value   |
            | ID                 | NotNone |
            | STATUS             | PAYING  |
            | INSERTED_TIMESTAMP | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAYING  |
            | INSERTED_TIMESTAMP  | NotNone |
            | UPDATED_TIMESTAMP   | NotNone |
            | FK_POSITION_SERVICE | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |








    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWATTIVAZIONE_FULL_8
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 1 nav, activateV2 -> paGetPayment -> OK,  activateV2 with expired token -> paGetPayment -> KO PPT_PAGAMENTO_IN_CORSO  (OLD_NMU-25)
        Given update parameter useIdempotency on configuration keys with value true
        And update parameter default_idempotency_key_validity_minutes on configuration keys with value 10
        And update parameter default_token_duration_validity_millis on configuration keys with value 1800000
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  | 6000           |
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
        And execution query to get value result_query on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And through the query result_query retrieve param paymentToken at position 0 and save it under the key paymentToken
        And wait 6.5 seconds for expiration
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_idempotency_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | idempotencyKey                          | noticeNumber                          | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | $activatePaymentNoticeV2.idempotencyKey | $activatePaymentNoticeV2.noticeNumber | 10.00  |
        Given from body with datatable vertical paGetPayment_full initial XML paGetPayment
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
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And wait 1 seconds for expiration
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PRIMITIVA          | activatePaymentNoticeV2               |
            | PSP_ID             | $activatePaymentNoticeV2.idPSP        |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber |
            | TOKEN              | $paymentToken,None                    |
            | VALID_TO           | NotNone                               |
            | HASH_REQUEST       | NotNone                               |
            | RESPONSE           | NotNone                               |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
            | ORDER BY        | INSERTED_TIMESTAMP,ID ASC               |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                          |
            | PSP_ID                | #pspEcommerce#                  |
            | PAYMENT_TOKEN         | $paymentToken                   |
            | TOKEN_VALID_FROM      | NotNone                         |
            | TOKEN_VALID_TO        | NotNone                         |
            | DUE_DATE              | NotNone                         |
            | AMOUNT                | $activatePaymentNoticeV2.amount |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | INSERTED_BY           | activatePaymentNoticeV2         |
            | UPDATED_BY            | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | company                 |
            | OFFICE_NAME        | office                  |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                          |
            | DUE_DATE              | NotNone                         |
            | RETENTION_DATE        | None                            |
            | AMOUNT                | $activatePaymentNoticeV2.amount |
            | FLAG_FINAL_PAYMENT    | Y                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | NotNone                         |
            | FK_POSITION_SERVICE   | NotNone                         |
            | INSERTED_BY           | activatePaymentNoticeV2         |
            | UPDATED_BY            | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                               |
            | ID                         | NotNone                             |
            | CREDITOR_REFERENCE_ID      | 02$iuv                              |
            | PAYMENT_TOKEN              | $paymentToken                       |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode |
            | STATION_ID                 | #id_station#                        |
            | STATION_VERSION            | 2                                   |
            | PSP_ID                     | #pspEcommerce#                      |
            | BROKER_PSP_ID              | #brokerEcommerce#                   |
            | CHANNEL_ID                 | #canaleEcommerce#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount     |
            | FEE                        | None                                |
            | OUTCOME                    | None                                |
            | PAYMENT_METHOD             | None                                |
            | PAYMENT_CHANNEL            | NA                                  |
            | TRANSFER_DATE              | None                                |
            | PAYER_ID                   | None                                |
            | INSERTED_TIMESTAMP         | NotNone                             |
            | UPDATED_TIMESTAMP          | NotNone                             |
            | FK_PAYMENT_PLAN            | NotNone                             |
            | RPT_ID                     | None                                |
            | PAYMENT_TYPE               | MOD3                                |
            | CARRELLO_ID                | None                                |
            | ORIGINAL_PAYMENT_TOKEN     | None                                |
            | FLAG_IO                    | N                                   |
            | RICEVUTA_PM                | None                                |
            | FLAG_PAYPAL                | None                                |
            | FLAG_ACTIVATE_RESP_MISSING | None                                |
            | TRANSACTION_ID             | None                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNoticeV2.amount     |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNoticeV2             |
            | UPDATED_BY               | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                 |
            | ID                    | NotNone                               |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber |
            | STATUS                | PAYING                                |
            | INSERTED_TIMESTAMP    | NotNone                               |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId     |
            | PAYMENT_TOKEN         | $paymentToken                         |
            | INSERTED_BY           | activatePaymentNoticeV2               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value         |
            | ID                    | NotNone       |
            | FK_POSITION_PAYMENT   | NotNone       |
            | CREDITOR_REFERENCE_ID | 02$iuv        |
            | PAYMENT_TOKEN         | $paymentToken |
            | STATUS                | PAYING        |
            | INSERTED_TIMESTAMP    | NotNone       |
            | UPDATED_TIMESTAMP     | NotNone       |
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
            | column             | value   |
            | ID                 | NotNone |
            | STATUS             | PAYING  |
            | INSERTED_TIMESTAMP | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAYING  |
            | INSERTED_TIMESTAMP  | NotNone |
            | UPDATED_TIMESTAMP   | NotNone |
            | FK_POSITION_SERVICE | NotNone |
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
        # activatePaymentNoticeV2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values            |
            | PAYMENT_TOKEN      | $paymentToken           |
            | TIPO_EVENTO        | activatePaymentNoticeV2 |
            | SOTTO_TIPO_EVENTO  | REQ                     |
            | ESITO              | RICEVUTA                |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)        |
            | ORDER BY           | DATA_ORA_EVENTO ASC     |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values            |
            | PAYMENT_TOKEN      | $paymentToken           |
            | TIPO_EVENTO        | activatePaymentNoticeV2 |
            | SOTTO_TIPO_EVENTO  | RESP                    |
            | ESITO              | INVIATA                 |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)        |
            | ORDER BY           | DATA_ORA_EVENTO ASC     |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | PAYMENT_TOKEN      | $paymentToken       |
            | TIPO_EVENTO        | paGetPayment        |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | PAYMENT_TOKEN      | $paymentToken       |
            | TIPO_EVENTO        | paGetPayment        |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWATTIVAZIONE_FULL_9
    Scenario: NMU flow paNEW VP2 OK, FLOW: con  activateV2-> paGetPaymentV2 with companyName in transfer (OLD_NM1-52)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_complete_metadataTransferList initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | companySec                  | companySecondary                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
            | key                         | CHIAVEOK                            |
            | value                       | 22                                  |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #pspEcommerce#                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | activatePaymentNoticeV2                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING                                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode |
            | STATUS             | PAYING                              |
            | INSERTED_BY        | activatePaymentNoticeV2             |
            | INSERTED_TIMESTAMP | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | PAYING                              |
            | FK_POSITION_SERVICE | NotNone                             |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #brokerEcommerce#                             |
            | CHANNEL_ID                 | #canaleEcommerce#                             |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | None                                          |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | activatePaymentNoticeV2                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | NotNone                                       |
            | RICEVUTA_PM                | None                                          |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | FLAG_PAYPAL                | None                                          |
            | TRANSACTION_ID             | None                                          |
            | CLOSE_VERSION              | None                                          |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        #RE #####
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
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
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
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 10$iuv in position 0
        # paGetPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Req
        And from $paGetPaymentV2Req.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paGetPaymentV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Req.transferType xml check value PAGOPA in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Resp
        And from $paGetPaymentV2Resp.outcome xml check value OK in position 0
        And from $paGetPaymentV2Resp.data.creditorReferenceId xml check value 10$iuv in position 0
        And from $paGetPaymentV2Resp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWATTIVAZIONE_FULL_10
    Scenario: NMU flow paNEW OK, FLOW: activateV2 -> paGetPayment -> mod3CancelV2-> activateV2 -> paGetPayment with different key and value in transferList  (OLD_NMU-72)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_complete_metadataTransferList initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | companySec                  | companySecondary                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
            | key                         | 1                                   |
            | value                       | 22                                  |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber                          | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | $activatePaymentNoticeV2.noticeNumber | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_complete_metadataTransferList initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | companySec                  | companySecondary                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
            | key                         | chiave                              |
            | value                       | valore                              |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                          |
            | DUE_DATE              | NotNone                         |
            | RETENTION_DATE        | None                            |
            | AMOUNT                | $activatePaymentNoticeV2.amount |
            | FLAG_FINAL_PAYMENT    | Y                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | NotNone,NotNone                 |
            | FK_POSITION_SERVICE   | NotNone                         |
            | INSERTED_BY           | activatePaymentNoticeV2         |
            | UPDATED_BY            | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_PLAN Metadata 1
        And execution query to get value result_query on the table POSITION_PAYMENT_PLAN, with the columns METADATA with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC LIMIT 1        |
        And through the query result_query retrieve json METADATA at position 0 and save it under the key position_payment_plan_metadata
        And from $position_payment_plan_metadata.key json check value 1 in position 0
        And from $position_payment_plan_metadata.value json check value 22 in position 0
        # POSITION_PAYMENT_PLAN Metadata 2
        And execution query to get value result_query on the table POSITION_PAYMENT_PLAN, with the columns METADATA with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC LIMIT 1        |
        And through the query result_query retrieve json METADATA at position 0 and save it under the key position_payment_plan_metadata
        And from $position_payment_plan_metadata.key json check value chiave in position 0
        And from $position_payment_plan_metadata.value json check value valore in position 0
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                           |
            | ID                    | NotNone                                                                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                          |
            | PSP_ID                | #pspEcommerce#                                                                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                                                                         |
            | TOKEN_VALID_TO        | NotNone                                                                                         |
            | DUE_DATE              | NotNone                                                                                         |
            | AMOUNT                | $activatePaymentNoticeV2.amount                                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                         |
            | UPDATED_TIMESTAMP     | NotNone                                                                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                                                                         |
            | UPDATED_BY            | activatePaymentNoticeV2                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                           |
            | ID                    | NotNone                                                                                                                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                             |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                               |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED,PAYING                                                                                                                         |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                           |
            | ID                    | NotNone                                                                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                             |
            | FK_POSITION_PAYMENT   | NotNone                                                                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                               |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED,PAYING                                                                                |
            | INSERTED_TIMESTAMP    | NotNone                                                                                         |
            | UPDATED_TIMESTAMP     | NotNone                                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                        |
            | ID                 | NotNone                                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                          |
            | STATUS             | PAYING,INSERTED,PAYING                                       |
            | INSERTED_BY        | activatePaymentNoticeV2,mod3CancelV2,activatePaymentNoticeV2 |
            | INSERTED_TIMESTAMP | NotNone                                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | PAYING                              |
            | FK_POSITION_SERVICE | NotNone                             |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                           |
            | ID                         | NotNone                                                                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode                                                             |
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId                                                               |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode                                                             |
            | STATION_ID                 | #id_station#                                                                                    |
            | STATION_VERSION            | 2                                                                                               |
            | PSP_ID                     | #pspEcommerce#                                                                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                                                                               |
            | CHANNEL_ID                 | #canaleEcommerce#                                                                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                                                                 |
            | FEE                        | None                                                                                            |
            | OUTCOME                    | None                                                                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                                                                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                                                                         |
            | FK_PAYMENT_PLAN            | NotNone                                                                                         |
            | RPT_ID                     | None                                                                                            |
            | PAYMENT_TYPE               | MOD3                                                                                            |
            | CARRELLO_ID                | None                                                                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                                                                            |
            | FLAG_IO                    | NotNone                                                                                         |
            | RICEVUTA_PM                | None                                                                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                                                                            |
            | FLAG_PAYPAL                | None                                                                                            |
            | TRANSACTION_ID             | None                                                                                            |
            | CLOSE_VERSION              | None                                                                                            |
            | INSERTED_TIMESTAMP         | NotNone                                                                                         |
            | UPDATED_TIMESTAMP          | NotNone                                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | company                 |
            | OFFICE_NAME        | office                  |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 02$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNoticeV2.amount     |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone,NotNone                     |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNoticeV2             |
            | UPDATED_BY               | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        #RE #####
        # activatePaymentNoticeV2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # activatePaymentNoticeV2 2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2_2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # paGetPayment 2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPayment 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0








    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWATTIVAZIONE_FULL_11
    Scenario: NMU flow paNEW OK, FLOW: activate -> paGetPayment -> mod3Cancel-> activate -> paGetPayment with different key and value in transferList  (OLD_NMU-73)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_complete_metadataTransferList initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | companyName                 | companyName                       |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | companySec                  | companySecondary                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
            | key                         | 1                                 |
            | value                       | 22                                |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice_1
        When job mod3CancelV2 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber                        | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | $activatePaymentNotice.noticeNumber | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_complete_metadataTransferList initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 02$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | companyName                 | companyName                       |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | companySec                  | companySecondary                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
            | key                         | chiave                            |
            | value                       | valore                            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice_2
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                         |
            | ID                    | NotNone                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                        |
            | DUE_DATE              | NotNone                       |
            | RETENTION_DATE        | None                          |
            | AMOUNT                | $activatePaymentNotice.amount |
            | FLAG_FINAL_PAYMENT    | Y                             |
            | INSERTED_TIMESTAMP    | NotNone                       |
            | UPDATED_TIMESTAMP     | NotNone                       |
            | METADATA              | NotNone,NotNone               |
            | FK_POSITION_SERVICE   | NotNone                       |
            | INSERTED_BY           | activatePaymentNotice         |
            | UPDATED_BY            | activatePaymentNotice         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                       |
            | ID                    | NotNone                                                                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                      |
            | PSP_ID                | #pspEcommerce#                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                                                                     |
            | TOKEN_VALID_TO        | NotNone                                                                                     |
            | DUE_DATE              | NotNone                                                                                     |
            | AMOUNT                | $activatePaymentNotice.amount                                                               |
            | INSERTED_TIMESTAMP    | NotNone                                                                                     |
            | UPDATED_TIMESTAMP     | NotNone                                                                                     |
            | INSERTED_BY           | activatePaymentNotice                                                                       |
            | UPDATED_BY            | activatePaymentNotice                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                          |
            | IDEMPOTENCY_KEY | $activatePaymentNotice.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                     |
            | ID                    | NotNone                                                                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                                                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                         |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED,PAYING                                                                                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_PLAN Metadata 1
        And execution query to get value result_query on the table POSITION_PAYMENT_PLAN, with the columns METADATA with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC LIMIT 1      |
        And through the query result_query retrieve json METADATA at position 0 and save it under the key position_payment_plan_metadata
        And from $position_payment_plan_metadata.key json check value 1 in position 0
        And from $position_payment_plan_metadata.value json check value 22 in position 0
        # POSITION_PAYMENT_PLAN Metadata 2
        And execution query to get value result_query on the table POSITION_PAYMENT_PLAN, with the columns METADATA with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC LIMIT 1     |
        And through the query result_query retrieve json METADATA at position 0 and save it under the key position_payment_plan_metadata
        And from $position_payment_plan_metadata.key json check value chiave in position 0
        And from $position_payment_plan_metadata.value json check value valore in position 0
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                       |
            | ID                    | NotNone                                                                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                           |
            | FK_POSITION_PAYMENT   | NotNone                                                                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                           |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | STATUS                | CANCELLED,PAYING                                                                            |
            | INSERTED_TIMESTAMP    | NotNone                                                                                     |
            | UPDATED_TIMESTAMP     | NotNone                                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                    |
            | ID                 | NotNone                                                  |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode                        |
            | STATUS             | PAYING,INSERTED,PAYING                                   |
            | INSERTED_BY        | activatePaymentNotice,mod3CancelV2,activatePaymentNotice |
            | INSERTED_TIMESTAMP | NotNone                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID                  | NotNone                           |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode |
            | STATUS              | PAYING                            |
            | FK_POSITION_SERVICE | NotNone                           |
            | INSERTED_TIMESTAMP  | NotNone                           |
            | UPDATED_TIMESTAMP   | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                       |
            | ID                         | NotNone                                                                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode                                                           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId                                                           |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode                                                           |
            | STATION_ID                 | #id_station#                                                                                |
            | STATION_VERSION            | 2                                                                                           |
            | PSP_ID                     | #pspEcommerce#                                                                              |
            | BROKER_PSP_ID              | #brokerEcommerce#                                                                           |
            | CHANNEL_ID                 | #canaleEcommerce#                                                                           |
            | AMOUNT                     | $activatePaymentNotice.amount                                                               |
            | FEE                        | None                                                                                        |
            | OUTCOME                    | None                                                                                        |
            | INSERTED_BY                | activatePaymentNotice                                                                       |
            | UPDATED_BY                 | activatePaymentNotice                                                                       |
            | FK_PAYMENT_PLAN            | NotNone                                                                                     |
            | RPT_ID                     | None                                                                                        |
            | PAYMENT_TYPE               | MOD3                                                                                        |
            | CARRELLO_ID                | None                                                                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                                                                        |
            | FLAG_IO                    | NotNone                                                                                     |
            | RICEVUTA_PM                | None                                                                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                                                                        |
            | FLAG_PAYPAL                | None                                                                                        |
            | TRANSACTION_ID             | None                                                                                        |
            | CLOSE_VERSION              | None                                                                                        |
            | INSERTED_TIMESTAMP         | NotNone                                                                                     |
            | UPDATED_TIMESTAMP          | NotNone                                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                 |
            | ID                 | NotNone               |
            | DESCRIPTION        | NotNone               |
            | COMPANY_NAME       | company               |
            | OFFICE_NAME        | office                |
            | DEBTOR_ID          | NotNone               |
            | INSERTED_TIMESTAMP | NotNone               |
            | UPDATED_TIMESTAMP  | NotNone               |
            | INSERTED_BY        | activatePaymentNotice |
            | UPDATED_BY         | activatePaymentNotice |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                             |
            | ID                       | NotNone                           |
            | CREDITOR_REFERENCE_ID    | 02$iuv                            |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016       |
            | AMOUNT                   | $activatePaymentNotice.amount     |
            | REMITTANCE_INFORMATION   | NotNone                           |
            | TRANSFER_CATEGORY        | NotNone                           |
            | TRANSFER_IDENTIFIER      | 1                                 |
            | VALID                    | Y                                 |
            | FK_POSITION_PAYMENT      | NotNone,NotNone                   |
            | INSERTED_TIMESTAMP       | NotNone                           |
            | UPDATED_TIMESTAMP        | NotNone                           |
            | FK_PAYMENT_PLAN          | NotNone                           |
            | INSERTED_BY              | activatePaymentNotice             |
            | UPDATED_BY               | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        #RE #####
        # activatePaymentNotice 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                         |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                         |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice_1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # activatePaymentNotice 2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                         |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                         |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice_2Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # paGetPayment 2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_2Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNotice_2Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
