Feature: NM4 e MOD4 flows con PA New pagamento OK


    Background:
        Given systems up


    @ALL @FLOW @FLOW_NOOPT @NM4 @NM4PANEW @NM4PANEWPAGOK @NM4PANEWPAGOK_1
    Scenario: NM4 flow OK, FLOW con PA New vp1: nodoChiediCatalogoServiziV2, demandPaymentNotice -> paDemandPaymentNotice, activatePaymentNotice -> paGetPayment, spo+ -> paSendRT, BIZ+ (NM4-4)
        Given from body with datatable horizontal nodoChiediCatalogoServiziV2_noOptional initial XML nodoChiediCatalogoServiziV2
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   |
            | #psp#             | #psp#                          | #canale_ATTIVATO_PRESSO_PSP# | #password# |
        When PSP sends SOAP nodoChiediCatalogoServiziV2 to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServiziV2 response
        And check outcome is OK of nodoChiediCatalogoServiziV2 response
        And check fault field not exists in nodoChiediCatalogoServiziV2 response
        Given from body with datatable horizontal demandPaymentNotice_noOptional initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_noOptional initial XML paDemandPaymentNotice
            | outcome            | OK                          |
            | fiscalCode         | #creditor_institution_code# |
            | noticeNumber       | 302#iuv#                    |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | paymentDescription          |
            | fiscalCodPA        | #creditor_institution_code# |
            | companyName        | companyName                 |
            | officeName         | officeName                  |
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When psp sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of demandPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_RECEIPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | RECEIPT_ID            | $sendPaymentOutcome.paymentToken  |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId |
            | PSP_ID                | $sendPaymentOutcome.idPSP         |
            | PAYMENT_TOKEN         | $sendPaymentOutcome.paymentToken  |
            | OUTCOME               | $sendPaymentOutcome.outcome       |
            | PAYMENT_AMOUNT        | $activatePaymentNotice.amount     |
            | DESCRIPTION           | $paGetPayment.description         |
            | COMPANY_NAME          | NA                                |
            | OFFICE_NAME           | None                              |
            | DEBTOR_ID             | NotNone                           |
            | PSP_COMPANY_NAME      | NotNone                           |
            | PSP_FISCAL_CODE       | NotNone                           |
            | PSP_VAT_NUMBER        | None                              |
            | CHANNEL_ID            | $sendPaymentOutcome.idChannel     |
            | CHANNEL_DESCRIPTION   | NA                                |
            | PAYER_ID              | None                              |
            | PAYMENT_METHOD        | None                              |
            | FEE                   | None                              |
            | PAYMENT_DATE_TIME     | NotNone                           |
            | APPLICATION_DATE      | NotNone                           |
            | TRANSFER_DATE         | None                              |
            | METADATA              | None                              |
            | RT_ID                 | None                              |
            | FK_POSITION_PAYMENT   | NotNone                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RECEIPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 02$iuv                                      |
            | PSP_ID                | #psp#                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | None                                        |
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
            | COMPANY_NAME       | None                  |
            | OFFICE_NAME        | None                  |
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
            | FLAG_FINAL_PAYMENT    | N                             |
            | INSERTED_TIMESTAMP    | NotNone                       |
            | UPDATED_TIMESTAMP     | NotNone                       |
            | METADATA              | None                          |
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
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station#                                |
            | STATION_VERSION            | 2                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | NotNone                                     |
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
            | AMOUNT                   | $activatePaymentNotice.amount     |
            | REMITTANCE_INFORMATION   | NotNone                           |
            | TRANSFER_CATEGORY        | NotNone                           |
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
            | column                | value                                                                                   |
            | ID                    | NotNone                                                                                 |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                       |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                     |
            | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                                 |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                             |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
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
            | STATUS                | NOTIFIED                                    |
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
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
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
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                |
            | ID_SESSIONE | $activatePaymentNoticeResponse.paymentToken |
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
        And from $activatePaymentNoticeResp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
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
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
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
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paSendRT                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value NA in position 0
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paSendRT                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0