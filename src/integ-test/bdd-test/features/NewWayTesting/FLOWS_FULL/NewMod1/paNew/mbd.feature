Feature: NMU flows con PA New e MBD


    Background:
        Given systems up


    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_1
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp2 con MBD, PSP MBD 0 e CANALI NODO MBD Y: upd MARCA_BOLLO_DIGITALE = 0 on PSP table, checkPosition con 1 nav, activateV2 -> paGetPaymentV2 (OLD_NMU-1A)
        Given update for table PSP with parameter MARCA_BOLLO_DIGITALE = 0 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | ID_PSP     | #pspEcommerce# |
        And waiting after triggered refresh job ALL
        And MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | #creditor_institution_code_secondary#        |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check idTransfer is 1 of activatePaymentNoticeV2 response
        And check hashDocumento is wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= of activatePaymentNoticeV2 response
        And check tipoBollo is 01 of activatePaymentNoticeV2 response
        And check provinciaResidenza is MI of activatePaymentNoticeV2 response
        Given update for table PSP with parameter MARCA_BOLLO_DIGITALE = 1 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | ID_PSP     | #pspEcommerce# |
        And waiting after triggered refresh job ALL
        Then wait 1 seconds for expiration
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #pspEcommerce#                                |
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
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 10$iuv                                |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code_secondary# |
            | IBAN                     | None                                  |
            | AMOUNT                   | $activatePaymentNoticeV2.amount       |
            | REMITTANCE_INFORMATION   | NotNone                               |
            | TRANSFER_CATEGORY        | NotNone                               |
            | TRANSFER_IDENTIFIER      | 1                                     |
            | VALID                    | Y                                     |
            | COMPANY_NAME_SECONDARY   | None                                  |
            | FK_POSITION_PAYMENT      | NotNone                               |
            | INSERTED_TIMESTAMP       | NotNone                               |
            | UPDATED_TIMESTAMP        | NotNone                               |
            | FK_PAYMENT_PLAN          | NotNone                               |
            | INSERTED_BY              | activatePaymentNoticeV2               |
            | UPDATED_BY               | activatePaymentNoticeV2               |
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
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
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
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code_secondary# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code_secondary# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_2
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp2 con MBD, PSP MBD 1 e CANALI NODO MBD N: upd MARCA_BOLLO_DIGITALE = N on CANALI NODO table, checkPosition con 1 nav, activateV2 -> paGetPaymentV2 (OLD_NMU-2A)
        Given update for table CANALI_NODO with parameter MARCA_BOLLO_DIGITALE = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                                                              |
            | OBJ_ID     | (SELECT FK_CANALI_NODO FROM CANALI WHERE ID_CANALE = '#canaleEcommerce#') |
        And waiting after triggered refresh job ALL
        And MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | #creditor_institution_code_secondary#        |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check idTransfer is 1 of activatePaymentNoticeV2 response
        And check hashDocumento is wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= of activatePaymentNoticeV2 response
        And check tipoBollo is 01 of activatePaymentNoticeV2 response
        And check provinciaResidenza is MI of activatePaymentNoticeV2 response
        Given update for table CANALI_NODO with parameter MARCA_BOLLO_DIGITALE = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                                                              |
            | OBJ_ID     | (SELECT FK_CANALI_NODO FROM CANALI WHERE ID_CANALE = '#canaleEcommerce#') |
        And waiting after triggered refresh job ALL
        Then wait 1 seconds for expiration
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #pspEcommerce#                                |
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
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 10$iuv                                |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code_secondary# |
            | IBAN                     | None                                  |
            | AMOUNT                   | $activatePaymentNoticeV2.amount       |
            | REMITTANCE_INFORMATION   | NotNone                               |
            | TRANSFER_CATEGORY        | NotNone                               |
            | TRANSFER_IDENTIFIER      | 1                                     |
            | VALID                    | Y                                     |
            | COMPANY_NAME_SECONDARY   | None                                  |
            | FK_POSITION_PAYMENT      | NotNone                               |
            | INSERTED_TIMESTAMP       | NotNone                               |
            | UPDATED_TIMESTAMP        | NotNone                               |
            | FK_PAYMENT_PLAN          | NotNone                               |
            | INSERTED_BY              | activatePaymentNoticeV2               |
            | UPDATED_BY               | activatePaymentNoticeV2               |
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
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
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
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code_secondary# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code_secondary# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_3
    Scenario: NMU flow KO, FLOW con PA New vp2 e PSP vp2 con MBD, CANALI NODO MBD N per canale_versione_primitive_2: activateV2 -> paGetPaymentV2, closePaymentV2 -> Invalid PSP/Canale for MBD (OLD_NMU-13A)
        Given update for table CANALI_NODO with parameter MARCA_BOLLO_DIGITALE = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                                                                          |
            | OBJ_ID     | (SELECT FK_CANALI_NODO FROM CANALI WHERE ID_CANALE = '#canale_versione_primitive_2#') |
        And waiting after triggered refresh job ALL
        And MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode          |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | $activatePaymentNoticeV2Response.paymentToken |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2012-04-23T18:25:43Z                          |
            | key                | 12345678                                      |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid PSP/Canale for MBD of v2/closepayment response
        Given update for table CANALI_NODO with parameter MARCA_BOLLO_DIGITALE = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                                                                          |
            | OBJ_ID     | (SELECT FK_CANALI_NODO FROM CANALI WHERE ID_CANALE = '#canale_versione_primitive_2#') |
        And waiting after triggered refresh job ALL
        Then wait 1 seconds for expiration
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #pspEcommerce#                                |
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
            | column                   | value                           |
            | ID                       | NotNone                         |
            | CREDITOR_REFERENCE_ID    | 10$iuv                          |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code#     |
            | IBAN                     | None                            |
            | AMOUNT                   | $activatePaymentNoticeV2.amount |
            | REMITTANCE_INFORMATION   | NotNone                         |
            | TRANSFER_CATEGORY        | NotNone                         |
            | TRANSFER_IDENTIFIER      | 1                               |
            | VALID                    | Y                               |
            | COMPANY_NAME_SECONDARY   | None                            |
            | FK_POSITION_PAYMENT      | NotNone                         |
            | INSERTED_TIMESTAMP       | NotNone                         |
            | UPDATED_TIMESTAMP        | NotNone                         |
            | FK_PAYMENT_PLAN          | NotNone                         |
            | INSERTED_BY              | activatePaymentNoticeV2         |
            | UPDATED_BY               | activatePaymentNoticeV2         |
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
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
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
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value TPAY in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.timestampOperation json check value NotNone in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.key json check value 12345678 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0
        And from $closePaymentv2Resp.description json check value Invalid PSP/Canale for MBD in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_4
    Scenario: NMU flow KO, FLOW con PA New vp2 e PSP vp2 con MBD e canale non ecommerce: checkPosition con 1 nav, activateV2 -> paGetPaymentV2 (OLD_NMU-3A)
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | #creditor_institution_code_secondary#        |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_SEMANTICA of activatePaymentNoticeV2 response
        And check faultString is Errore semantico. of activatePaymentNoticeV2 response
        And check description is Pagamento non attivabile of activatePaymentNoticeV2 response
        And execution query to get value result_query on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And through the query result_query retrieve param paymentToken at position 0 and save it under the key paymentToken
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | None                            |
            | PSP_ID                | #psp#                           |
            | PAYMENT_TOKEN         | $paymentToken                   |
            | TOKEN_VALID_FROM      | None                            |
            | TOKEN_VALID_TO        | None                            |
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
        And verify 0 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And verify 0 record for the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And verify 0 record for the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
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
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $paymentToken |
        # RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values            |
            | PAYMENT_TOKEN      | $paymentToken           |
            | TIPO_EVENTO        | activatePaymentNoticeV2 |
            | SOTTO_TIPO_EVENTO  | REQ                     |
            | ESITO              | RICEVUTA                |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)        |
            | ORDER BY           | DATA_ORA_EVENTO ASC     |
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
            | where_keys         | where_values            |
            | PAYMENT_TOKEN      | $paymentToken           |
            | TIPO_EVENTO        | activatePaymentNoticeV2 |
            | SOTTO_TIPO_EVENTO  | RESP                    |
            | ESITO              | INVIATA                 |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)        |
            | ORDER BY           | DATA_ORA_EVENTO ASC     |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value KO in position 0
        And from $activatePaymentNoticeV2Resp.fault.faultCode xml check value PPT_SEMANTICA in position 0
        And from $activatePaymentNoticeV2Resp.fault.faultString xml check value Errore semantico. in position 0
        And from $activatePaymentNoticeV2Resp.fault.id xml check value NodoDeiPagamentiSPC in position 0
        And from $activatePaymentNoticeV2Resp.fault.description xml check value Pagamento non attivabile in position 0
        # paGetPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | PAYMENT_TOKEN      | $paymentToken       |
            | TIPO_EVENTO        | paGetPaymentV2      |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Req
        And from $paGetPaymentV2Req.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paGetPaymentV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Req.transferType xml check value None in position 0
        # paGetPaymentV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | PAYMENT_TOKEN      | $paymentToken       |
            | TIPO_EVENTO        | paGetPaymentV2      |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Resp
        And from $paGetPaymentV2Resp.outcome xml check value OK in position 0
        And from $paGetPaymentV2Resp.data.creditorReferenceId xml check value 10$iuv in position 0
        And from $paGetPaymentV2Resp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code_secondary# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0










    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_5
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp2 con MBD, PSP MBD 0 e CANALI NODO MBD N: upd MARCA_BOLLO_DIGITALE = 0 on PSP table e upd MARCA_BOLLO_DIGITALE = N on CANALI NODO table, checkPosition con 1 nav, activateV2 -> paGetPaymentV2 (OLD_NMU-4A)
        Given update for table PSP with parameter MARCA_BOLLO_DIGITALE = 0 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | ID_PSP     | #pspEcommerce# |
        And update for table CANALI_NODO with parameter MARCA_BOLLO_DIGITALE = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                                                              |
            | OBJ_ID     | (SELECT FK_CANALI_NODO FROM CANALI WHERE ID_CANALE = '#canaleEcommerce#') |
        And waiting after triggered refresh job ALL
        And MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | #creditor_institution_code_secondary#        |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check idTransfer is 1 of activatePaymentNoticeV2 response
        And check hashDocumento is wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= of activatePaymentNoticeV2 response
        And check tipoBollo is 01 of activatePaymentNoticeV2 response
        And check provinciaResidenza is MI of activatePaymentNoticeV2 response
        Given update for table PSP with parameter MARCA_BOLLO_DIGITALE = 1 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values   |
            | ID_PSP     | #pspEcommerce# |
        And update for table CANALI_NODO with parameter MARCA_BOLLO_DIGITALE = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                                                              |
            | OBJ_ID     | (SELECT FK_CANALI_NODO FROM CANALI WHERE ID_CANALE = '#canaleEcommerce#') |
        And waiting after triggered refresh job ALL
        Then wait 1 seconds for expiration
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #pspEcommerce#                                |
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
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 10$iuv                                |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code_secondary# |
            | IBAN                     | None                                  |
            | AMOUNT                   | $activatePaymentNoticeV2.amount       |
            | REMITTANCE_INFORMATION   | NotNone                               |
            | TRANSFER_CATEGORY        | NotNone                               |
            | TRANSFER_IDENTIFIER      | 1                                     |
            | VALID                    | Y                                     |
            | COMPANY_NAME_SECONDARY   | None                                  |
            | FK_POSITION_PAYMENT      | NotNone                               |
            | INSERTED_TIMESTAMP       | NotNone                               |
            | UPDATED_TIMESTAMP        | NotNone                               |
            | FK_PAYMENT_PLAN          | NotNone                               |
            | INSERTED_BY              | activatePaymentNoticeV2               |
            | UPDATED_BY               | activatePaymentNoticeV2               |
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
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
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
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code_secondary# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code_secondary# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_6
    Scenario: NMU flow KO, FLOW con PA New vp2 e PSP vp2 con MBD, PSP MBD 0: upd MARCA_BOLLO_DIGITALE = 0 on PSP table, activateV2 -> paGetPaymentV2, closepayment -> Invalid PSP/Canale for MBD (OLD_NMU-12A)
        Given update for table PSP with parameter MARCA_BOLLO_DIGITALE = 0 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values |
            | ID_PSP     | #psp#        |
        And waiting after triggered refresh job ALL
        And MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode          |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | $activatePaymentNoticeV2Response.paymentToken |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2012-04-23T18:25:43Z                          |
            | key                | 12345678                                      |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid PSP/Canale for MBD of v2/closepayment response
        Given update for table PSP with parameter MARCA_BOLLO_DIGITALE = 1 on db nodo_cfg with where datatable horizontal
            | where_keys | where_values |
            | ID_PSP     | #psp#        |
        And waiting after triggered refresh job ALL
        Then wait 1 seconds for expiration
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #pspEcommerce#                                |
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
            | column                   | value                           |
            | ID                       | NotNone                         |
            | CREDITOR_REFERENCE_ID    | 10$iuv                          |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code#     |
            | IBAN                     | None                            |
            | AMOUNT                   | $activatePaymentNoticeV2.amount |
            | REMITTANCE_INFORMATION   | NotNone                         |
            | TRANSFER_CATEGORY        | NotNone                         |
            | TRANSFER_IDENTIFIER      | 1                               |
            | VALID                    | Y                               |
            | COMPANY_NAME_SECONDARY   | None                            |
            | FK_POSITION_PAYMENT      | NotNone                         |
            | INSERTED_TIMESTAMP       | NotNone                         |
            | UPDATED_TIMESTAMP        | NotNone                         |
            | FK_PAYMENT_PLAN          | NotNone                         |
            | INSERTED_BY              | activatePaymentNoticeV2         |
            | UPDATED_BY               | activatePaymentNoticeV2         |
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
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
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
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value TPAY in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.timestampOperation json check value NotNone in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.key json check value 12345678 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0
        And from $closePaymentv2Resp.description json check value Invalid PSP/Canale for MBD in position 0







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_7
    Scenario: NMU flow RETRY, FLOW con PA New vp2 e PSP vp2 con MBD: activateV2 -> paGetPaymentV2, closepaymentV2 -> override paSendRTV2 malformata -> spoV2 -> paSendRTV2 (OLD_NMU-5A)
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode          |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | $activatePaymentNoticeV2Response.paymentToken |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2012-04-23T18:25:43Z                          |
            | key                | 12345678                                      |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then check outcome is OK of v2/closepayment response
        And verify the HTTP status code of v2/closepayment response is 200
        Given from body with datatable vertical paSendRTV2_malformata initial XML paSendRTV2
            | outcome | KKL |
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      | creditCard    | 2.00 | $bollo        | 1          |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_TRANSFER_MBD JOIN POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                |
            | s.TIPO_BOLLO             | 01                   |
            | s.TIPO_ALLEGATO_RICEVUTA | BD                   |
            | s.IUBD                   | $iubd                |
            | s.IMPORTO                | 5.00                 |
            | s.ORA_ACQUISTO           | NotNone              |
            | s.XML_CONTENT            | NotNone              |
            | s.INSERTED_TIMESTAMP     | NotNone              |
            | s.UPDATED_TIMESTAMP      | NotNone              |
            | s.INSERTED_BY            | sendPaymentOutcomeV2 |
            | s.UPDATED_BY             | sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER_MBD s JOIN POSITION_TRANSFER pt ON pt.ID = s.FK_POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys        | where_values                          |
            | pt.NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | pt.PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | closePayment-v2                               |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #psp#                                         |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | OK                                            |
            | PAYMENT_METHOD             | creditCard                                    |
            | PAYMENT_CHANNEL            | app                                           |
            | TRANSFER_DATE              | NotNone                                       |
            | PAYER_ID                   | NotNone                                       |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | N                                             |
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                           |
            | ID                       | NotNone                         |
            | CREDITOR_REFERENCE_ID    | 10$iuv                          |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code#     |
            | IBAN                     | None                            |
            | AMOUNT                   | $activatePaymentNoticeV2.amount |
            | REMITTANCE_INFORMATION   | NotNone                         |
            | TRANSFER_CATEGORY        | NotNone                         |
            | TRANSFER_IDENTIFIER      | 1                               |
            | VALID                    | Y                               |
            | COMPANY_NAME_SECONDARY   | None                            |
            | FK_POSITION_PAYMENT      | NotNone                         |
            | INSERTED_TIMESTAMP       | NotNone                         |
            | UPDATED_TIMESTAMP        | NotNone                         |
            | FK_PAYMENT_PLAN          | NotNone                         |
            | INSERTED_BY              | activatePaymentNoticeV2         |
            | UPDATED_BY               | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                     |
            | ID                    | NotNone                                                                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                       |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                     |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                   |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                             |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 7 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | NOTICE_SENT                                   |
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
            | column             | value       |
            | ID                 | NotNone     |
            | STATUS             | PAYING,PAID |
            | INSERTED_TIMESTAMP | NotNone     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAID    |
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
        # POSITION_RETRY_PA_SEND_RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value |
            | RETRY  | 0     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        And verify 1 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value TPAY in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.timestampOperation json check value NotNone in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.key json check value 12345678 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # pspNotifyPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                            |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Req
        And from $pspNotifyPaymentV2Req.paymentList.payment.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $pspNotifyPaymentV2Req.paymentList.payment.paymentDescription xml check value pagamentoTest in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value TPAY in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value key in position 1
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 12345678 in position 1
        # pspNotifyPaymentV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                            |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Resp
        And from $pspNotifyPaymentV2Resp.outcome xml check value OK in position 0
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
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
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
        # paSendRTV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paSendRTV2                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTV2Req
        And from $paSendRTV2Req.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paSendRTV2Req.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTV2Req.receipt.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.receipt.outcome xml check value OK in position 0
        And from $paSendRTV2Req.receipt.creditorReferenceId xml check value 10$iuv in position 0
        And from $paSendRTV2Req.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTV2Req.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTV2Req.receipt.companyName xml check value company in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.MBDAttachment xml check value NotNone in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTV2Req.receipt.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $paSendRTV2Req.receipt.fee xml check value 2.00 in position 0
        # paSendRTV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paSendRTV2                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTV2Resp
        And from $paSendRTV2Resp.outcome xml check value KKL in position 0
        # sendPaymentResult-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentResult-v2                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
        And from $sendPaymentResultv2Req.outcome json check value OK in position 0
        And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
        And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value NotNone in position 0
        And from $sendPaymentResultv2Req.payments.debtor json check value 44444444444 in position 0
        And from $sendPaymentResultv2Req.payments.description json check value pagamentoTest in position 0
        And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0








    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_8
    Scenario: NMU flow KO, FLOW con PA New vp2 e PSP vp2 con MBD, con closeV2 su canale_IMMEDIATO_MULTIBENEFICIARIO: activateV2 -> paGetPaymentV2, closepayment -> Invalid PSP/Canale for MBD (OLD_NMU-11A)
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode          |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | $activatePaymentNoticeV2Response.paymentToken |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2012-04-23T18:25:43Z                          |
            | key                | 12345678                                      |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Invalid PSP/Canale for MBD of v2/closepayment response
        Then wait 1 seconds for expiration
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #pspEcommerce#                                |
            | BROKER_PSP_ID              | #pspEcommerce#                                |
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
            | column                   | value                           |
            | ID                       | NotNone                         |
            | CREDITOR_REFERENCE_ID    | 10$iuv                          |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code#     |
            | IBAN                     | None                            |
            | AMOUNT                   | $activatePaymentNoticeV2.amount |
            | REMITTANCE_INFORMATION   | NotNone                         |
            | TRANSFER_CATEGORY        | NotNone                         |
            | TRANSFER_IDENTIFIER      | 1                               |
            | VALID                    | Y                               |
            | COMPANY_NAME_SECONDARY   | None                            |
            | FK_POSITION_PAYMENT      | NotNone                         |
            | INSERTED_TIMESTAMP       | NotNone                         |
            | UPDATED_TIMESTAMP        | NotNone                         |
            | FK_PAYMENT_PLAN          | NotNone                         |
            | INSERTED_BY              | activatePaymentNoticeV2         |
            | UPDATED_BY               | activatePaymentNoticeV2         |
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
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
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
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value TPAY in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.timestampOperation json check value NotNone in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.key json check value 12345678 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0
        And from $closePaymentv2Resp.description json check value Invalid PSP/Canale for MBD in position 0







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWMBD @NMUPANEWMBD_FULL_9
    Scenario: NMU flow RETRY, FLOW con PA New vp2 e PSP vp2 con MBD: activateV2 -> paGetPaymentV2, closepaymentV2 -> override paSendRTV2 timeout -> spoV2 -> paSendRTV2 (OLD_NMU-6A)
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_MBD_full initial XML paGetPaymentV2
            | outcome                     | OK                                           |
            | creditorReferenceId         | 10$iuv                                       |
            | paymentAmount               | 10.00                                        |
            | dueDate                     | 2021-12-12                                   |
            | description                 | pagamentoTest                                |
            | companyName                 | company                                      |
            | entityUniqueIdentifierType  | G                                            |
            | entityUniqueIdentifierValue | 44444444444                                  |
            | fullName                    | Massimo Benvegnù                             |
            | transferAmount              | 10.00                                        |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode          |
            | hashDocumento               | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
            | tipoBollo                   | 01                                           |
            | provinciaResidenza          | MI                                           |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/             |
            | transferCategory            | paGetPaymentTest                             |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_TPAY_noOptional initial json v2/closepayment
            | token1             | $activatePaymentNoticeV2Response.paymentToken |
            | outcome            | OK                                            |
            | idPSP              | #psp#                                         |
            | idBrokerPSP        | #id_broker_psp#                               |
            | idChannel          | #canale_versione_primitive_2#                 |
            | paymentMethod      | TPAY                                          |
            | transactionId      | #transaction_id#                              |
            | totalAmount        | 12                                            |
            | fee                | 2                                             |
            | timestampOperation | 2012-04-23T18:25:43Z                          |
            | key                | 12345678                                      |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then check outcome is OK of v2/closepayment response
        And verify the HTTP status code of v2/closepayment response is 200
        Given from body with datatable vertical paSendRTV2_timeout initial XML paSendRTV2
            | outcome | OK    |
            | delay   | 10000 |
        And EC replies to nodo-dei-pagamenti with the paSendRTV2
        And from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome | paymentMethod | fee  | MBDAttachment | idTransfer |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      | creditCard    | 2.00 | $bollo        | 1          |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_TRANSFER_MBD JOIN POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                |
            | s.TIPO_BOLLO             | 01                   |
            | s.TIPO_ALLEGATO_RICEVUTA | BD                   |
            | s.IUBD                   | $iubd                |
            | s.IMPORTO                | 5.00                 |
            | s.ORA_ACQUISTO           | NotNone              |
            | s.XML_CONTENT            | NotNone              |
            | s.INSERTED_TIMESTAMP     | NotNone              |
            | s.UPDATED_TIMESTAMP      | NotNone              |
            | s.INSERTED_BY            | sendPaymentOutcomeV2 |
            | s.UPDATED_BY             | sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER_MBD s JOIN POSITION_TRANSFER pt ON pt.ID = s.FK_POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys        | where_values                          |
            | pt.NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | pt.PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | closePayment-v2                               |
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
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
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
            | CREDITOR_REFERENCE_ID      | 10$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #psp#                                         |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | OK                                            |
            | PAYMENT_METHOD             | creditCard                                    |
            | PAYMENT_CHANNEL            | app                                           |
            | TRANSFER_DATE              | NotNone                                       |
            | PAYER_ID                   | NotNone                                       |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | N                                             |
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                           |
            | ID                       | NotNone                         |
            | CREDITOR_REFERENCE_ID    | 10$iuv                          |
            | PA_FISCAL_CODE_SECONDARY | #creditor_institution_code#     |
            | IBAN                     | None                            |
            | AMOUNT                   | $activatePaymentNoticeV2.amount |
            | REMITTANCE_INFORMATION   | NotNone                         |
            | TRANSFER_CATEGORY        | NotNone                         |
            | TRANSFER_IDENTIFIER      | 1                               |
            | VALID                    | Y                               |
            | COMPANY_NAME_SECONDARY   | None                            |
            | FK_POSITION_PAYMENT      | NotNone                         |
            | INSERTED_TIMESTAMP       | NotNone                         |
            | UPDATED_TIMESTAMP        | NotNone                         |
            | FK_PAYMENT_PLAN          | NotNone                         |
            | INSERTED_BY              | activatePaymentNoticeV2         |
            | UPDATED_BY               | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                     |
            | ID                    | NotNone                                                                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                       |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                     |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                   |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                             |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 7 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | NOTICE_SENT                                   |
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
            | column             | value       |
            | ID                 | NotNone     |
            | STATUS             | PAYING,PAID |
            | INSERTED_TIMESTAMP | NotNone     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value   |
            | ID                  | NotNone |
            | STATUS              | PAID    |
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
        # POSITION_RETRY_PA_SEND_RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value |
            | RETRY  | 0     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        And verify 1 record for the table POSITION_RETRY_PA_SEND_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
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
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value #creditor_institution_code# in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.hashDocumento xml check value wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.tipoBollo xml check value 01 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.richiestaMarcaDaBollo.provinciaResidenza xml check value MI in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value TPAY in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.timestampOperation json check value NotNone in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.key json check value 12345678 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # pspNotifyPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                            |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Req
        And from $pspNotifyPaymentV2Req.paymentList.payment.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $pspNotifyPaymentV2Req.paymentList.payment.paymentDescription xml check value pagamentoTest in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value TPAY in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value key in position 1
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 12345678 in position 1
        # pspNotifyPaymentV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                            |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentV2Resp
        And from $pspNotifyPaymentV2Resp.outcome xml check value OK in position 0
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
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
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
        # paSendRTV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paSendRTV2                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTV2Req
        And from $paSendRTV2Req.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paSendRTV2Req.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTV2Req.receipt.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.receipt.outcome xml check value OK in position 0
        And from $paSendRTV2Req.receipt.creditorReferenceId xml check value 10$iuv in position 0
        And from $paSendRTV2Req.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTV2Req.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTV2Req.receipt.companyName xml check value company in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.MBDAttachment xml check value NotNone in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paSendRTV2Req.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTV2Req.receipt.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $paSendRTV2Req.receipt.fee xml check value 2.00 in position 0
        # paSendRTV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paSendRTV2                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTV2Resp
        And from $paSendRTV2Resp.outcome xml check value OK in position 0
        # sendPaymentResult-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentResult-v2                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key sendPaymentResultv2Req
        And from $sendPaymentResultv2Req.outcome json check value OK in position 0
        And from $sendPaymentResultv2Req.paymentDate json check value NotNone in position 0
        And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value NotNone in position 0
        And from $sendPaymentResultv2Req.payments.debtor json check value 44444444444 in position 0
        And from $sendPaymentResultv2Req.payments.description json check value pagamentoTest in position 0
        And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
