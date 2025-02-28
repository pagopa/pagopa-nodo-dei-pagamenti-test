Feature: NM3 flows con pagamento fallito

    Background:
        Given systems up


    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_1
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment, spo-, BIZ- (NM3-3)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING,FAILED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,INSERTED                   |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID                  | NotNone                           |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode |
            | STATUS              | INSERTED                          |
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
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | $activatePaymentNotice.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNotice.idBrokerPSP          |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2                                           |
            | OUTCOME                    | $sendPaymentOutcome.outcome                 |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | sendPaymentOutcome                          |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | NotNone                                     |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | NotNone                                     |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                |
            | ID_SESSIONE | $activatePaymentNoticeResponse.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                       |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | PSP_ID        | $activatePaymentNotice.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_SUBJECT JOIN POSITION_SERVICE #Massimo Benvegnù
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                            | value                     |
            | su.ID                             | NotNone                   |
            | su.SUBJECT_TYPE                   | DEBTOR                    |
            | su.ENTITY_UNIQUE_IDENTIFIER_TYPE  | G                         |
            | su.ENTITY_UNIQUE_IDENTIFIER_VALUE | 77777777777               |
            | su.FULL_NAME                      | NotNone                   |
            | su.STREET_NAME                    | paGetPaymentStreet        |
            | su.CIVIC_NUMBER                   | paGetPayment99            |
            | su.POSTAL_CODE                    | 20155                     |
            | su.CITY                           | paGetPaymentCity          |
            | su.STATE_PROVINCE_REGION          | paGetPaymentState         |
            | su.COUNTRY                        | IT                        |
            | su.EMAIL                          | paGetPayment@provatest.it |
            | su.INSERTED_TIMESTAMP             | NotNone                   |
            | su.UPDATED_TIMESTAMP              | NotNone                   |
            | su.INSERTED_BY                    | activatePaymentNotice     |
            | su.UPDATED_BY                     | activatePaymentNotice     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SUBJECT su JOIN POSITION_SERVICE se ON su.ID = se.DEBTOR_ID retrived by the query on db nodo_online with where datatable horizontal
            | where_keys            | where_values                        |
            | se.NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | se.PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | su.SUBJECT_TYPE       | DEBTOR                              |
            | su.INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                    |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0




    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_2
    Scenario: NM3 flow OK, FLOW: activateV2 -> paGetPayment, spoV2-, BIZ- (NM3-11)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING,FAILED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | FAILED                                        |
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
            | STATUS             | PAYING,INSERTED                     |
            | INSERTED_TIMESTAMP | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
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
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station#                                  |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | $activatePaymentNoticeV2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2.idBrokerPSP          |
            | CHANNEL_ID                 | #canale32#                                    |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2                                             |
            | OUTCOME                    | $sendPaymentOutcomeV2.outcome                 |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | sendPaymentOutcomeV2                          |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | NotNone                                       |
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
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                         |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
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
        And from $sendPaymentOutcomeV2Req.outcome xml check value KO in position 0
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



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_3
    Scenario: NM3 flow OK, FLOW: activate -> paGetPaymentV2 -> spo- BIZ- (NM3-32)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                |
            | creditorReferenceId         | 10$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | companyName                 | companyName                       |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING,FAILED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,INSERTED                   |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID                  | NotNone                           |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode |
            | STATUS              | INSERTED                          |
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
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2.creditorReferenceId         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#             |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | $activatePaymentNotice.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNotice.idBrokerPSP          |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2                                           |
            | OUTCOME                    | $sendPaymentOutcome.outcome                 |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | sendPaymentOutcome                          |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | NotNone                                     |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | NotNone                                     |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                |
            | ID_SESSIONE | $activatePaymentNoticeResponse.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                       |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | PSP_ID        | $activatePaymentNotice.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 0 record for the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | NOTICE_ID  | $activatePaymentNoticeResponse.paymentToken |
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | NOTICE_ID  | $activatePaymentNoticeResponse.paymentToken |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 10$iuv in position 0
        # paGetPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                              |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Req
        And from $paGetPaymentV2Req.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Req.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paGetPaymentV2Req.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value 310$iuv in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPaymentV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                              |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Resp
        And from $paGetPaymentV2Resp.outcome xml check value OK in position 0
        And from $paGetPaymentV2Resp.data.creditorReferenceId xml check value 10$iuv in position 0
        And from $paGetPaymentV2Resp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_4
    Scenario: NM3 flow OK, FLOW: activateV2 -> paGetPaymentV2, spoV2-, BIZ- (NM3-39)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING,FAILED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | FAILED                                        |
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
            | STATUS             | PAYING,INSERTED                     |
            | INSERTED_TIMESTAMP | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
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
            | PSP_ID                     | $activatePaymentNoticeV2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2.idBrokerPSP          |
            | CHANNEL_ID                 | #canale32#                                    |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2                                             |
            | OUTCOME                    | $sendPaymentOutcomeV2.outcome                 |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | sendPaymentOutcomeV2                          |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | NotNone                                       |
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
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                         |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
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
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value 310$iuv in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPaymentV2 RESP
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
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
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
        And from $sendPaymentOutcomeV2Req.outcome xml check value KO in position 0
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




    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_5
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment, spoV2-, BIZ- (NM3-64)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING,FAILED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,INSERTED                   |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID                  | NotNone                           |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode |
            | STATUS              | INSERTED                          |
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
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | $activatePaymentNotice.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNotice.idBrokerPSP          |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2                                           |
            | OUTCOME                    | $sendPaymentOutcomeV2.outcome               |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | sendPaymentOutcomeV2                        |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | NotNone                                     |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | NotNone                                     |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                |
            | ID_SESSIONE | $activatePaymentNoticeResponse.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                       |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | PSP_ID        | $activatePaymentNotice.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
        And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeV2Req.outcome xml check value KO in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
        And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_6
    Scenario: NM3 flow OK, FLOW: activateV2 -> paGetPayment, spo-, BIZ- (NM3-68)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING,FAILED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | FAILED                                        |
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
            | STATUS             | PAYING,INSERTED                     |
            | INSERTED_TIMESTAMP | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
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
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station#                                  |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | $activatePaymentNoticeV2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2.idBrokerPSP          |
            | CHANNEL_ID                 | #canale32#                                    |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2                                             |
            | OUTCOME                    | $sendPaymentOutcome.outcome                   |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | sendPaymentOutcome                            |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | NotNone                                       |
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
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                         |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
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
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
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



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_7
    Scenario: NM3 flow OK, FLOW: activate -> paGetPaymentV2, spoV2-, BIZ- (NM3-86)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                |
            | creditorReferenceId         | 10$iuv                            |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | companyName                 | companyName                       |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING,FAILED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,INSERTED                   |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID                  | NotNone                           |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode |
            | STATUS              | INSERTED                          |
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
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2.creditorReferenceId         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#             |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | $activatePaymentNotice.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNotice.idBrokerPSP          |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2                                           |
            | OUTCOME                    | $sendPaymentOutcomeV2.outcome               |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | sendPaymentOutcomeV2                        |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | NotNone                                     |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | NotNone                                     |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                |
            | ID_SESSIONE | $activatePaymentNoticeResponse.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                       |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | PSP_ID        | $activatePaymentNotice.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 10$iuv in position 0
        # paGetPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                              |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Req
        And from $paGetPaymentV2Req.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Req.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paGetPaymentV2Req.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value 310$iuv in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPaymentV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                              |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Resp
        And from $paGetPaymentV2Resp.outcome xml check value OK in position 0
        And from $paGetPaymentV2Resp.data.creditorReferenceId xml check value 10$iuv in position 0
        And from $paGetPaymentV2Resp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
        And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeV2Req.outcome xml check value KO in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
        And from $sendPaymentOutcomeV2Resp.outcome xml check value OK in position 0



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_8
    Scenario: NM3 flow OK, FLOW: activateV2 -> paGetPaymentV2, spo-, BIZ- (NM3-90)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING,FAILED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | FAILED                                        |
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
            | STATUS             | PAYING,INSERTED                     |
            | INSERTED_TIMESTAMP | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
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
            | PSP_ID                     | $activatePaymentNoticeV2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2.idBrokerPSP          |
            | CHANNEL_ID                 | #canale32#                                    |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2                                             |
            | OUTCOME                    | $sendPaymentOutcome.outcome                   |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | sendPaymentOutcome                            |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | NotNone                                       |
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
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                         |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
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
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value 310$iuv in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # paGetPaymentV2 RESP
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
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
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
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
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





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_10
    Scenario: NM3 flow OK, FLOW: activateV2 -> paGetPayment, spoV2-, spoV2- PPT_ESITO_GIA_ACQUISITO (OLD_NM3-15)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
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
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING,FAILED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | FAILED                                        |
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
            | STATUS             | PAYING,INSERTED                     |
            | INSERTED_TIMESTAMP | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
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
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId             |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station#                                  |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | $activatePaymentNoticeV2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2.idBrokerPSP          |
            | CHANNEL_ID                 | #canale32#                                    |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2                                             |
            | OUTCOME                    | $sendPaymentOutcomeV2.outcome                 |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | sendPaymentOutcomeV2                          |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | NotNone                                       |
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
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                         |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2.idPSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
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





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_11
    Scenario: NM3 + paGetPaymentV2 --> controllo, FLOW: activateV2 -> paGetPaymentV2 -> KO iuv not contained in notice number of (OLD_NM3-84)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 12345678998765432                   |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | companyName                 | companyName                         |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check description is iuv not contained in notice number of activatePaymentNoticeV2 response



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_12
    Scenario: NM3 + paGetPaymentV2 --> controllo, FLOW: activate -> paGetPaymentV2 -> KO iuv not contained in notice number of (OLD_NM3-83)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                |
            | creditorReferenceId         | 12345678998765432                 |
            | paymentAmount               | 10.00                             |
            | dueDate                     | 2021-12-31                        |
            | description                 | pagamentoTest                     |
            | companyName                 | companyName                       |
            | entityUniqueIdentifierType  | G                                 |
            | entityUniqueIdentifierValue | 77777777777                       |
            | fullName                    | Massimo Benvegnù                  |
            | transferAmount              | 10.00                             |
            | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016       |
            | remittanceInformation       | testPaGetPayment                  |
            | transferCategory            | paGetPaymentTest                  |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check description is iuv not contained in notice number of activatePaymentNotice response



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_13
    Scenario: NM3 + paGetPayment --> controllo, FLOW: activateV2 -> paGetPayment -> KO iuv not contained in notice number of (OLD_NM3-82)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 12345678998765432                   |
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
        When psp sends soap activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check description is iuv not contained in notice number of activatePaymentNoticeV2 response



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_14
    Scenario: NM3 + paGetPayment --> controllo, FLOW: activate -> paGetPayment -> KO iuv not contained in notice number of (OLD_NM3-81)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                |
            | creditorReferenceId         | 12345678998765432                 |
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
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check description is iuv not contained in notice number of activatePaymentNotice response




    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_15
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> upd POSITION_STATUS_SNAPSHOT NOTICE_ID rand NOTIFIED -> spoV2+ -> KO con PPT_PAGAMENTO_SCONOSCIUTO (OLD_NM3-92)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        And update for table POSITION_STATUS_SNAPSHOT with parameter NOTICE_ID = '311011451292109621' on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_SCONOSCIUTO of sendPaymentOutcomeV2 response





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_16
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> upd POSITION_STATUS_SNAPSHOT ACTIVATION_PENDING Y -> spoV2+ -> KO con PPT_SEMANTICA  && description is Outcome non accettabile per stato pagamento (OLD_NM3-94)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        And update for table POSITION_STATUS_SNAPSHOT with parameter ACTIVATION_PENDING = 'Y' on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_17
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> upd POSITION_STATUS_SNAPSHOT STATUS PAID -> spoV2+ -> KO con PPT_PAGAMENTO_DUPLICATO (OLD_NM3-95)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        And update for table POSITION_STATUS_SNAPSHOT with parameter STATUS = 'PAID' on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_18
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> upd idPsp empty in spov2 -> spoV2+ -> KO con PPT_SINTASSI_EXTRAXSD (OLD_NM3-114)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
        And idPSP with Empty in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcomeV2 response
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |


    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_19
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> upd paymentToken rand in spov2 -> spoV2+ -> KO con PPT_TOKEN_SCONOSCIUTO (OLD_NM3-115)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
        And paymentToken with 798c6a817ed9482fa5659c45f4a25f286 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PRIMITIVA          | sendPaymentOutcomeV2              |
            | PSP_ID             | $activatePaymentNotice.idPSP      |
            | PA_FISCAL_CODE     | None                              |
            | NOTICE_ID          | None                              |
            | TOKEN              | 798c6a817ed9482fa5659c45f4a25f286 |
            | VALID_TO           | NotNone                           |
            | HASH_REQUEST       | NotNone                           |
            | RESPONSE           | NotNone                           |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |








    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_20
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> upd idBrokerPSP 70000000001 in spov2 -> spoV2+ -> KO con PPT_AUTORIZZAZIONE (OLD_NM3-116)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
        And idBrokerPSP with 70000000001 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_AUTORIZZAZIONE of sendPaymentOutcomeV2 response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | sendPaymentOutcomeV2                        |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | None                                        |
            | NOTICE_ID          | None                                        |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | VALID_TO           | NotNone                                     |
            | HASH_REQUEST       | NotNone                                     |
            | RESPONSE           | NotNone                                     |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |

        And idPSP with 70000000001 in sendPaymentOutcomeV2
        And idBrokerPSP with 70000000001 in sendPaymentOutcomeV2
        And idChannel with 70000000001_01 in sendPaymentOutcomeV2


    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_21
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> spoV2+ -> upd idPSP, idBrokerPSP, idChannel in spov2 -> spoV2+ -> KO con PPT_TOKEN_SCONOSCIUTO (OLD_NM3-118)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And saving sendPaymentOutcomeV2 request in sendPaymentOutcomeV2_1
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey                       |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | $sendPaymentOutcomeV2.idempotencyKey |
        And idPSP with 70000000001 in sendPaymentOutcomeV2
        And idBrokerPSP with 70000000001 in sendPaymentOutcomeV2
        And idChannel with 70000000001_01 in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCONOSCIUTO of sendPaymentOutcomeV2 response
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                             |
            | ID                    | NotNone                                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                 |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                 |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken       |
            | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED |
            | INSERTED_TIMESTAMP    | NotNone                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | NOTIFIED                                    |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,PAID,NOTIFIED              |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID                  | NotNone                           |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode |
            | STATUS              | NOTIFIED                          |
            | FK_POSITION_SERVICE | NotNone                           |
            | INSERTED_TIMESTAMP  | NotNone                           |
            | UPDATED_TIMESTAMP   | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # IDEMPOTENCY_CACHE
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
        # POSITION_PAYMENT
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |




    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_22
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> spoV2+ -> upd paymentMethod with cash in spov2 -> spoV2+ -> KO con PPT_ERRORE_IDEMPOTENZA (OLD_NM3-119)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And saving sendPaymentOutcomeV2 request in sendPaymentOutcomeV2_1
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey                       |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | $sendPaymentOutcomeV2.idempotencyKey |
        And paymentMethod with cash in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ERRORE_IDEMPOTENZA of sendPaymentOutcomeV2 response
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                             |
            | ID                    | NotNone                                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                 |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                 |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken       |
            | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED |
            | INSERTED_TIMESTAMP    | NotNone                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | NOTIFIED                                    |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,PAID,NOTIFIED              |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID                  | NotNone                           |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode |
            | STATUS              | NOTIFIED                          |
            | FK_POSITION_SERVICE | NotNone                           |
            | INSERTED_TIMESTAMP  | NotNone                           |
            | UPDATED_TIMESTAMP   | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # IDEMPOTENCY_CACHE
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
        # POSITION_PAYMENT
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_23
    Scenario: NM3 flow KO, FLOW: upd scheduler.jobName_idempotencyCacheClean.enabled set to false -> verify -> paVerify activate -> paGetPayment -> spoV2+ -> upd VALID_TO 1 min later -> spoV2+ -> KO con PPT_ESITO_GIA_ACQUISITO (OLD_NM3-121)
        Given nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to false
        And from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PRIMITIVA          | sendPaymentOutcomeV2                |
            | PSP_ID             | $sendPaymentOutcomeV2.idPSP         |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | TOKEN              | $sendPaymentOutcomeV2.paymentToken  |
            | VALID_TO           | NotNone                             |
            | HASH_REQUEST       | NotNone                             |
            | RESPONSE           | NotNone                             |
            | INSERTED_TIMESTAMP | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
        And current date plus 1 minutes generation
        And updates through the query update_validto of the table IDEMPOTENCY_CACHE the parameter VALID_TO with $date_plus_minutes under macro NewMod1 on db nodo_online
        And wait 65 seconds for expiration
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                    |
            | ID                 | NotNone                                  |
            | PRIMITIVA          | sendPaymentOutcomeV2                     |
            | PSP_ID             | $sendPaymentOutcomeV2.idPSP              |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode,None   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber,None |
            | TOKEN              | $sendPaymentOutcomeV2.paymentToken       |
            | VALID_TO           | NotNone                                  |
            | HASH_REQUEST       | NotNone                                  |
            | RESPONSE           | NotNone                                  |
            | INSERTED_TIMESTAMP | NotNone                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
            | ORDER BY        | INSERTED_TIMESTAMP,ID ASC            |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                         |
            | IDEMPOTENCY_KEY | $sendPaymentOutcomeV2.idempotencyKey |
        And nodo-dei-pagamenti has config parameter scheduler.jobName_idempotencyCacheClean.enabled set to true





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_24
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> spoV2+ -> upd idempotencyKey with rand in spov2 -> spoV2+ -> KO con PPT_ESITO_GIA_ACQUISITO (OLD_NM3-126)
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
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey    |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | #idempotency_key# |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        Given idempotencyKey with 60000000001_7381318111 in sendPaymentOutcomeV2
        And from body with datatable horizontal sendPaymentOutcomeV2Body_idempotency_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | idempotencyKey                       |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | $sendPaymentOutcomeV2.idempotencyKey |
        And paymentMethod with cash in sendPaymentOutcomeV2
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_25
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment   activate -> paGetPayment -> spoV2+ -> with 2 token ->  KO con PPT_SEMANTICA (OLD_NM3-97)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
            | outcome            | OK                              |
            | amount             | 1.00                            |
            | options            | EQ                              |
            | allCCP             | false                           |
            | paymentDescription | Pagamento di Test               |
            | fiscalCodePA       | $verifyPaymentNotice.fiscalCode |
            | companyName        | companyName                     |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable vertical paGetPayment_full initial XML paGetPayment
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
        And save activatePaymentNotice response in activatePaymentNotice_2
        Given from body with datatable vertical sendPaymentOutcomeV2Body_2paymentToken_full initial XML sendPaymentOutcomeV2
            | idPSP       | #psp#                                         |
            | idBrokerPSP | #id_broker_psp#                               |
            | idChannel   | #canale_ATTIVATO_PRESSO_PSP#                  |
            | password    | #password#                                    |
            | payToken1   | $activatePaymentNotice_1Response.paymentToken |
            | payToken2   | $activatePaymentNotice_2Response.paymentToken |
            | outcome     | OK                                            |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And check description is Outcome non accettabile per token multipli attivati presso il PSP of sendPaymentOutcomeV2 response
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
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
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
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
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
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
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |






    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_26
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment  activate random noticeNumber -> paGetPayment -> spoV2+ ->  KO con PPT_PAGAMENTO_DUPLICATO (OLD_NM3-98)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
            | outcome            | OK                              |
            | amount             | 1.00                            |
            | options            | EQ                              |
            | allCCP             | false                           |
            | paymentDescription | Pagamento di Test               |
            | fiscalCodePA       | $verifyPaymentNotice.fiscalCode |
            | companyName        | companyName                     |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  | 60000          |
        And idempotencyKey with None in activatePaymentNotice
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
        And saving paGetPayment request in paGetPayment_1
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNoticeRequest1
        And save activatePaymentNotice response in activatePaymentNotice_1
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 60000          |
        And idempotencyKey with None in activatePaymentNotice
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
        And saving paGetPayment request in paGetPayment_2
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNoticeRequest2
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice_1Response.paymentToken | OK      |
        And updates through the query update_noticeid_activate2 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter NOTICE_ID with $activatePaymentNoticeRequest1.noticeNumber under macro NewMod1 on db nodo_online
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        And updates through the query update_noticeid_activate1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter NOTICE_ID with $activatePaymentNoticeRequest2.noticeNumber under macro NewMod1 on db nodo_online
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response






    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_27
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate -> paGetPayment -> spoV2+ OK -> SPOV2+ KO con PPT_ESITO_GIA_ACQUISITO (OLD_NM3-91)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
            | outcome            | OK                          |
            | amount             | 1.00                        |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | Pagamento di Test           |
            | fiscalCodePA       | #creditor_institution_code# |
            | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 6000           | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
        And check description contains Esito concorde of sendPaymentOutcomeV2 response





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_28
    Scenario: NM3 flow KO, FLOW: verify -> paVerifyPayment activate -> paGetPayment -> updDB STATUS with CANCELLED activate -> paGetPayment -> spoV2+ paymentToken_2 -> OK spoV2+ paymentToken_1 -> KO con PPT_PAGAMENTO_DUPLICATO (OLD_NM3-127)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
            | outcome            | OK                              |
            | amount             | 1.00                            |
            | options            | EQ                              |
            | allCCP             | false                           |
            | paymentDescription | Pagamento di Test               |
            | fiscalCodePA       | $verifyPaymentNotice.fiscalCode |
            | companyName        | companyName                     |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 2000           | 10.00  |
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
        And save activatePaymentNotice response in activatePaymentNotice_1
        And updates through the query update_activate of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
        And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online
        And wait 3 seconds for expiration
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        And save activatePaymentNotice response in activatePaymentNotice_2
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice_2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice_1Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response






    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_29
    Scenario: NM3 flow KO, FLOW: verify -> paVerify activate with 2000 expirationTime-> paGetPayment ->  spoV2- -> KO  (OLD_NM3-145)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
            | outcome            | OK                              |
            | amount             | 1.00                            |
            | options            | EQ                              |
            | allCCP             | false                           |
            | paymentDescription | Pagamento di Test               |
            | fiscalCodePA       | $verifyPaymentNotice.fiscalCode |
            | companyName        | companyName                     |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 2000           | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When job mod3CancelV2 triggered after 3 seconds
        And PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING,CANCELLED,FAILED                     |
            | INSERTED_TIMESTAMP    | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,INSERTED                   |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | INSERTED                            |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | mod3CancelV2                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        # POSITION_RECEIPT
        And verify 0 record for the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_RECEIPT_XML
        And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_RECEIPT_RECIPIENT
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_RECEIPT_RECIPIENT_STATUS
        And verify 0 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |





    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_30 @after
    Scenario: NM3 flow KO con PA New vp1 e PSP vp1, FLOW : verify -> activate -> paGetPayment with 3 transfer, mod3CancelV2, spo+ -> Override paSendRT with delay 10000 , BIZ- (OLD_NM3-23F)
        Given update through the query param_update_in of the table PA_STAZIONE_PA the parameter BROADCAST with N, with where condition FK_PA and where value ('6','8') under macro update_query on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        And from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     |
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                      | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $verifyPaymentNotice.noticeNumber | 15.00  | 6000           |
        And from body with datatable vertical paGetPayment_3transfer_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 15.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | 77777777777                 |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 5.00                        |
            | IBAN                        | IT45R0760103200000000001016 |
            | fiscalCodePA1               | #creditor_institution_code# |
            | fiscalCodePA2               | #creditor_institution_code# |
            | fiscalCodePA3               | #creditor_institution_code# |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        When job mod3CancelV2 triggered after 6 seconds
        Then wait 5 seconds for expiration
        Given from body with datatable vertical paSendRT_delay initial XML paSendRT
            | outcome | OK    |
            | delay   | 10000 |
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        And EC replies to nodo-dei-pagamenti with the paSendRT
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And wait 10 seconds for expiration
        Then check outcome is KO of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
            | PSP_ID                | #psp#                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
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
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId |
            | DUE_DATE              | 2021-12-31 00:00:00               |
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
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | #intermediarioPA#                           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | NotNone                                     |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2                                           |
            | OUTCOME                    | OK                                          |
            | PAYMENT_METHOD             | creditCard                                  |
            | PAYMENT_CHANNEL            | app                                         |
            | TRANSFER_DATE              | 2021-12-11                                  |
            | PAYER_ID                   | NotNone                                     |
            | APPLICATION_DATE           | 2021-12-12                                  |
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
            | UPDATED_BY                 | sendPaymentOutcome                          |
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
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId   |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code#         |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | 5.00                                |
            | REMITTANCE_INFORMATION   | testPaGetPayment                    |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1,2,3                               |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | activatePaymentNotice               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                       |
            | ID                    | NotNone                                                                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                         |
            | STATUS                | PAYING,CANCELLED,PAID,NOTICE_GENERATED,NOTICE_SENT                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                                 |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | NOTICE_SENT                                 |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_RECEIPT_RECIPIENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                          |
            | ID                    | NotNone                                        |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode              |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber            |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken    |
            | STATUS                | NOTICE_GENERATED,NOTICE_SENT,NOTICE_PENDING    |
            | INSERTED_TIMESTAMP    | NotNone                                        |
            | INSERTED_BY           | sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_RECEIPT_RECIPIENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | NOTICE_PENDING                              |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | INSERTED_BY           | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_RECEIPT_RECIPIENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                       |
            | ID                    | NotNone                                                                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                                 |
            | STATUS                | PAYING,CANCELLED,PAID,NOTICE_GENERATED,NOTICE_SENT                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                     |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | NOTICE_SENT                                 |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                 |
            | ID                 | NotNone                                               |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode                     |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber                   |
            | STATUS             | PAYING,INSERTED,PAID                                  |
            | INSERTED_TIMESTAMP | NotNone                                               |
            | INSERTED_BY        | activatePaymentNotice,mod3CancelV2,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | STATUS             | PAID                                |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
            | INSERTED_BY        | activatePaymentNotice               |
            | UPDATED_BY         | sendPaymentOutcome                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_RETRY_PA_SEND_RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                               |
            | ID                 | NotNone                             |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber |
            | RETRY              | 0                                   |
            | INSERTED_TIMESTAMP | NotNone                             |
            | UPDATED_TIMESTAMP  | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value 5 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value 5 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys               | where_values                                |
            | PAYMENT_TOKEN            | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO              | paSendRT                                    |
            | SOTTO_TIPO_EVENTO        | REQ                                         |
            | ESITO                    | INVIATA_KO                                  |
            | IDENTIFICATIVO_EROGATORE | #id_station#                                |
            | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                            |
            | ORDER BY                 | INSERTED_TIMESTAMP ASC                      |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        ### TRANSFER 1
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value 5 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        ### TRANSFER 2
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 2 in position 1
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value 5 in position 1
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 1
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 1
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 1
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 1
        ### TRANSFER 3
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 3 in position 2
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value 5 in position 2
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 2
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 2
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 2
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 2
        # paSendRT RESP NOTHING
        And verify 0 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys               | where_values                                |
            | PAYMENT_TOKEN            | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO              | paSendRT                                    |
            | SOTTO_TIPO_EVENTO        | RESP                                        |
            | ESITO                    | RICEVUTA                                    |
            | IDENTIFICATIVO_EROGATORE | #id_station#                                |
            | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                            |
            | ORDER BY                 | INSERTED_TIMESTAMP ASC                      |




    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_31
    Scenario: NM3 flow KO, FLOW: verificaBollettino -> paVerify activate -> paGetPayment --> spo- -> verificaBollettino OK (OLD_NM3-3M)
        Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
        And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
            | outcome            | OK                          |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | Pagamento di Test           |
            | fiscalCodePA       | #creditor_institution_code# |
            | companyName        | companyName                 |
        And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                | outcome |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PSP_ID                | #pspPoste#                                  |
            | IDEMPOTENCY_KEY       | NotNone                                     |
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
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | DESCRIPTION        | pagamentoTest                     |
            | COMPANY_NAME       | company                           |
            | OFFICE_NAME        | office                            |
            | DEBTOR_ID          | NotNone                           |
            | INSERTED_TIMESTAMP | NotNone                           |
            | UPDATED_TIMESTAMP  | NotNone                           |
            | INSERTED_BY        | activatePaymentNotice             |
            | UPDATED_BY         | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId |
            | DUE_DATE              | 2021-12-31 00:00:00               |
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
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | #pspPoste#                                  |
            | BROKER_PSP_ID              | #brokerPspPoste#                            |
            | CHANNEL_ID                 | #channelPoste#                              |
            | IDEMPOTENCY_KEY            | NotNone                                     |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2                                           |
            | OUTCOME                    | KO                                          |
            | PAYMENT_METHOD             | creditCard                                  |
            | PAYMENT_CHANNEL            | app                                         |
            | TRANSFER_DATE              | 2021-12-11                                  |
            | PAYER_ID                   | NotNone                                     |
            | APPLICATION_DATE           | 2021-12-12                                  |
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
            | UPDATED_BY                 | sendPaymentOutcome                          |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | 2                                           |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId   |
            | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | testPaGetPayment                    |
            | TRANSFER_CATEGORY        | paGetPaymentTest                    |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING,FAILED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                    |
            | ID                 | NotNone                                  |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode        |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber      |
            | STATUS             | PAYING,INSERTED                          |
            | INSERTED_TIMESTAMP | NotNone                                  |
            | INSERTED_BY        | activatePaymentNotice,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | INSERTED                            |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | ACTIVATION_PENDING  | N                                   |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | sendPaymentOutcome                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #pspPoste# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #brokerPspPoste# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #channelPoste# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #pspPoste# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #brokerPspPoste# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #channelPoste# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0



    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_32
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment, spo- -> activate BIZ- (OLD_NM3-72B)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                   |
            | ID                    | NotNone                                                                                                                                 |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                                                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_1Response.paymentToken,$activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING,FAILED,PAYING                                                                                                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                         |
            | FK_POSITION_PAYMENT   | NotNone                                                                                   |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                         |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED,PAYING                                                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID                 | NotNone                           |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
            | STATUS             | PAYING,INSERTED,PAYING            |
            | INSERTED_TIMESTAMP | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
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
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                     |
            | ID                         | NotNone                                                                                   |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode                                                         |
            | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId                                                         |
            | PAYMENT_TOKEN              | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode                                                         |
            | STATION_ID                 | #id_station#                                                                              |
            | STATION_VERSION            | 2                                                                                         |
            | PSP_ID                     | $activatePaymentNotice.idPSP                                                              |
            | BROKER_PSP_ID              | $activatePaymentNotice.idBrokerPSP                                                        |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                                                              |
            | AMOUNT                     | $activatePaymentNotice.amount                                                             |
            | FEE                        | 2,None                                                                                    |
            | OUTCOME                    | $sendPaymentOutcome.outcome,None                                                          |
            | INSERTED_BY                | activatePaymentNotice,activatePaymentNotice                                               |
            | UPDATED_BY                 | sendPaymentOutcome,activatePaymentNotice                                                  |
            | FK_PAYMENT_PLAN            | NotNone                                                                                   |
            | RPT_ID                     | None                                                                                      |
            | PAYMENT_TYPE               | NotNone                                                                                   |
            | CARRELLO_ID                | None                                                                                      |
            | ORIGINAL_PAYMENT_TOKEN     | None                                                                                      |
            | FLAG_IO                    | NotNone                                                                                   |
            | RICEVUTA_PM                | None                                                                                      |
            | FLAG_ACTIVATE_RESP_MISSING | None                                                                                      |
            | FLAG_PAYPAL                | None                                                                                      |
            | TRANSACTION_ID             | None                                                                                      |
            | CLOSE_VERSION              | None                                                                                      |
            | INSERTED_TIMESTAMP         | NotNone                                                                                   |
            | UPDATED_TIMESTAMP          | NotNone                                                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                |
            | ID_SESSIONE | $activatePaymentNoticeResponse.paymentToken |











    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOK @NM3PANEWPAGKO_FULL_33 @after
    Scenario: NM3 flow KO con PA New vp1 e PSP vp1, FLOW con broadcast paPrinc!=paSec: activate -> paGetPayment con 5 transfer, la PA principale non fa parte dei transfer, la PA principale ha broadcast sia vp1 che vp2, le PA secondarie hanno broadcast alcune vp1, altre vp2 e altre senza broadcast -> spo- (OLD_NM3-5L)
        Given update for table PA_STAZIONE_PA with parameter BROADCAST = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                                                           |
            | OBJ_ID     | ('4328','4329','11991','11993','13','15134','15133','16640','1340001') |
        And update for table STAZIONI with parameter VERSIONE_PRIMITIVE = '2' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values  |
            | OBJ_ID     | ('7','15131') |
        And update parameter scheduler.jobName_paSendRt.enabled on configuration keys with value true
        And waiting after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 50.00  |
        And from body with datatable vertical paGetPayment_5transfer_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 50.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | 77777777777                 |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | IBAN                        | IT45R0760103200000000001016 |
            | fiscalCodePA1               | 90000000001                 |
            | fiscalCodePA2               | 90000000002                 |
            | fiscalCodePA3               | 90000000003                 |
            | fiscalCodePA4               | 88888888888                 |
            | fiscalCodePA5               | 88888888888                 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
            | PSP_ID                | #psp#                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | NotNone                                     |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
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
            | METADATA              | NotNone                       |
            | FK_POSITION_SERVICE   | NotNone                       |
            | INSERTED_BY           | activatePaymentNotice         |
            | UPDATED_BY            | activatePaymentNotice         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | #intermediarioPA#                           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2.00                                        |
            | OUTCOME                    | KO                                          |
            | PAYMENT_METHOD             | creditCard                                  |
            | PAYMENT_CHANNEL            | app                                         |
            | TRANSFER_DATE              | NotNone                                     |
            | PAYER_ID                   | NotNone                                     |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | TRANSACTION_ID             | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                                       |
            | ID                       | NotNone                                                     |
            | CREDITOR_REFERENCE_ID    | 02$iuv                                                      |
            | PA_FISCAL_CODE_SECONDARY | 90000000001,90000000002,90000000003,88888888888,88888888888 |
            | IBAN                     | IT45R0760103200000000001016                                 |
            | AMOUNT                   | 10                                                          |
            | REMITTANCE_INFORMATION   | NotNone                                                     |
            | TRANSFER_CATEGORY        | NotNone                                                     |
            | TRANSFER_IDENTIFIER      | 1,2,3,4,5                                                   |
            | VALID                    | Y                                                           |
            | FK_POSITION_PAYMENT      | NotNone                                                     |
            | INSERTED_TIMESTAMP       | NotNone                                                     |
            | UPDATED_TIMESTAMP        | NotNone                                                     |
            | FK_PAYMENT_PLAN          | NotNone                                                     |
            | INSERTED_BY              | activatePaymentNotice                                       |
            | UPDATED_BY               | activatePaymentNotice                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING,FAILED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value           |
            | ID                 | NotNone         |
            | STATUS             | PAYING,INSERTED |
            | INSERTED_TIMESTAMP | NotNone         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC              |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | INSERTED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        ### TRANSFER 1
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value 10 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value 90000000001 in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        ### TRANSFER 2
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 2 in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value 10 in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value 90000000002 in position 2
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 1
        ### TRANSFER 3
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 3 in position 2
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value 10 in position 2
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value 90000000003 in position 3
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 2
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 2
        ### TRANSFER 4
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 4 in position 3
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value 10 in position 3
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value 88888888888 in position 4
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 3
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 3
        ### TRANSFER 5
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 5 in position 4
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value 10 in position 4
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value 88888888888 in position 5
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 4
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 4

        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value #intermediarioPA# in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        ###TRANSFER 1
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value 10 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value 90000000001 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        ###TRANSFER 2
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 2 in position 1
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value 10 in position 1
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value 90000000002 in position 1
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 1
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 1
        ###TRANSFER 3
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 3 in position 2
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value 10 in position 2
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value 90000000003 in position 2
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 2
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 2
        ###TRANSFER 4
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 4 in position 3
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value 10 in position 3
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value 88888888888 in position 3
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 3
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 3
        ###TRANSFER 5
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 5 in position 4
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value 10 in position 4
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value 88888888888 in position 4
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 4
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 4
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentTokens.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0








    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGKO @NM3PANEWPAGKO_FULL_34
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment  -> spo+ with empty idPsp -> KO PPT_SINTASSI_EXTRAXSD check idempotency cache table for activate and spo (OLD_NM3-25K)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_idempotency_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | idempotencyKey    | paymentToken                                | outcome |
            |       | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #idempotency_key# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
            | PSP_ID                | #psp#                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | NotNone                                     |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
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
            | METADATA              | NotNone                       |
            | FK_POSITION_SERVICE   | NotNone                       |
            | INSERTED_BY           | activatePaymentNotice         |
            | UPDATED_BY            | activatePaymentNotice         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | #intermediarioPA#                           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | TRANSACTION_ID             | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
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
            | AMOUNT                   | 10                                |
            | REMITTANCE_INFORMATION   | testPaGetPayment                  |
            | TRANSFER_CATEGORY        | paGetPaymentTest                  |
            | TRANSFER_IDENTIFIER      | 1                                 |
            | VALID                    | Y                                 |
            | FK_POSITION_PAYMENT      | NotNone                           |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value   |
            | ID                 | NotNone |
            | STATUS             | PAYING  |
            | INSERTED_TIMESTAMP | NotNone |
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
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAYING  |
            | INSERTED_TIMESTAMP  | NotNone |
            | UPDATED_TIMESTAMP   | NotNone |
            | FK_POSITION_SERVICE | NotNone |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # IDEMPOTENCY_CACHE activatePaymentNotice
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID                 | NotNone                                     |
            | PRIMITIVA          | activatePaymentNotice                       |
            | PSP_ID             | $activatePaymentNotice.idPSP                |
            | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID          | $activatePaymentNotice.noticeNumber         |
            | TOKEN              | $activatePaymentNoticeResponse.paymentToken |
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
        # IDEMPOTENCY_CACHE sendPaymentOutcome
        And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                       |
            | IDEMPOTENCY_KEY | $sendPaymentOutcome.idempotencyKey |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
