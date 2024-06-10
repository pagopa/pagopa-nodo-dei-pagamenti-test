Feature: NMU flows con PA New pagamento OK


    Background:
        Given systems up


    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_1
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp2: checkPosition con 1 nav, activateV2 -> paGetPayment, closeV2+ -> pspNotifyV2, spoV2+ -> paSendRT+, BIZ+ e SPRv2+ (NMU-8)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #id_broker_psp#                               |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                                |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                              |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                      |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
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
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
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
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2023-11-30T12:46:46.554+01:00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
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
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
        And from $pspNotifyPaymentV2Req.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
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
        And from $paSendRTReq.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value NA in position 0
        # And from $paSendRTReq.receipt.debtor.fullName xml check value Massimo Benvegnù in position 0
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $paSendRTReq.receipt.fee xml check value 2.00 in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paSendRT                                      |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0
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
        And from $sendPaymentResultv2Req.payments.creditorReferenceId json check value 02$iuv in position 0
        And from $sendPaymentResultv2Req.payments.debtor json check value 77777777777 in position 0
        And from $sendPaymentResultv2Req.payments.description json check value pagamentoTest in position 0
        And from $sendPaymentResultv2Req.payments.fiscalCode json check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $sendPaymentResultv2Req.payments.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0




    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_2 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp1 con Travaso CP: checkPosition con 1 nav activateV2 -> paGetPayment, closeV2+ -> pspNotifyPayment con creditCardPayment, spo+ -> paSendRT+, BIZ+ e SPRv2+ (NMU-9)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                      |
            | ID                    | NotNone                                                                                                                                    |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                        |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                           |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                    |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                              |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.creditCardPayment.rrn check value 11223344 in position 0
        And from $pspNotifyPayment.creditCardPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.creditCardPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.creditCardPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.creditCardPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.creditCardPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.creditCardPayment.paymentGateway check value 00 in position 0



    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_3 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp1 con Travaso PPAL: checkPosition con 1 nav activateV2 -> paGetPayment, closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spo+ -> paSendRT+ BIZ+ e SPRv2+ (NMU-10)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_PPAL_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | PPAL                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | pspTransactionId      | #psp_transaction_id#                          |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                      |
            | ID                    | NotNone                                                                                                                                    |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                        |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                           |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                    |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                              |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,pspTransactionId                     |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,PPAL,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.paypalPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.pspTransactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.paypalPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.paypalPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0



    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_4 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp1 con Travaso BPAY: checkPosition con 1 nav activateV2 -> paGetPayment, closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spo+ -> paSendRT+ BIZ+ e SPRv2+ (NMU-11)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_BPAY_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | BPAY                                          |
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
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                      |
            | ID                    | NotNone                                                                                                                                    |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                        |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                           |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                    |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                              |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway                |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,BPAY,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.ctBancomatpayPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.paymentGateway check value 00 in position 0



    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_5
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp1 notify e PSP vp2 spo: checkPosition con 1 nav activateV2 -> paGetPayment, closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spoV2+ -> paSendRT+ BIZ+ e SPRv2+ (NMU-12)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value tipoVersamento in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value CP in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value outcomePaymentGateway in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value timestampOperation in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value totalAmount in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 12 in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value paymentGateway in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value fee in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2 in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value authorizationCode in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 123456 in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value rrn in position 7
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 11223344 in position 7


    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_6 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp1 notify e PSP vp2 spo c con Travaso CP: checkPosition con 1 nav activateV2 -> paGetPayment, closeV2+ -> pspNotifyPayment con creditCardPayment, spoV2+ -> paSendRT+, BIZ+ e SPRv2+ (NMU-13)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.creditCardPayment.rrn check value 11223344 in position 0
        And from $pspNotifyPayment.creditCardPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.creditCardPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.creditCardPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.creditCardPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.creditCardPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.creditCardPayment.paymentGateway check value 00 in position 0


    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_7 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp1 notify e PSP vp2 spo con Travaso PPAL: checkPosition con 1 nav activateV2 -> paGetPayment, closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spoV2+ -> paSendRT+ BIZ+ e SPRv2+ (NMU-14)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_PPAL_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | PPAL                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | pspTransactionId      | #psp_transaction_id#                          |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,pspTransactionId                     |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,PPAL,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.paypalPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.pspTransactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.paypalPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.paypalPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0




    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_8 @after
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp1 notify e PSP vp2 spo con Travaso BPAY: checkPosition con 1 nav activateV2 -> paGetPayment, closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spoV2+ -> paSendRT+ BIZ+ e SPRv2+ (NMU-15)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_BPAY_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | BPAY                                          |
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
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway                |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,BPAY,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.ctBancomatpayPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.paymentGateway check value 00 in position 0






    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_9
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp2 notify e PSP vp1 spo: con checkPosition con 1 nav, activateV2 -> paGetPayment , closeV2+ -> pspNotifyPaymentV2 con additionalPaymentInformations, spo+ -> paSendRT+, BIZ+ e SPRv2+ (NMU-16)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                     | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                        |
            | ID                    | NotNone                                                                                                                                      |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                          |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                        |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                      |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                            |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value tipoVersamento in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value CP in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value outcomePaymentGateway in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value timestampOperation in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value totalAmount in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 12 in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value paymentGateway in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value fee in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2 in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value authorizationCode in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 123456 in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value rrn in position 7
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 11223344 in position 7




    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_10 @after
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp1 con Travaso CP: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPayment con creditCardPayment, spo+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-22)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                      |
            | ID                    | NotNone                                                                                                                                    |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                        |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                           |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                    |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                              |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.creditCardPayment.rrn check value 11223344 in position 0
        And from $pspNotifyPayment.creditCardPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.creditCardPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.creditCardPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.creditCardPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.creditCardPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.creditCardPayment.paymentGateway check value 00 in position 0





    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_11 @after
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp1 con Travaso PPAL: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPayment con creditCardPayment, spo+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-23)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_PPAL_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | PPAL                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | pspTransactionId      | #psp_transaction_id#                          |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                      |
            | ID                    | NotNone                                                                                                                                    |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                        |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                           |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                    |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                              |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,pspTransactionId                     |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,PPAL,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.paypalPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.pspTransactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.paypalPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.paypalPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0







    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_12 @after
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp1 con Travaso BPAY: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPayment con creditCardPayment, spo+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-24)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_BPAY_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | BPAY                                          |
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
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                      |
            | ID                    | NotNone                                                                                                                                    |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                        |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                           |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                    |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                              |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway                |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,BPAY,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.ctBancomatpayPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.paymentGateway check value 00 in position 0





    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_13
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp1 notify e PSP vp2 spo: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPayment con additionalPaymentInformations, spoV2+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-25)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value tipoVersamento in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value CP in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value outcomePaymentGateway in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value timestampOperation in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value totalAmount in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 12 in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value paymentGateway in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value fee in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2 in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value authorizationCode in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 123456 in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value rrn in position 7
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 11223344 in position 7




    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_14 @after
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp1 notify e PSP vp2 spo con Travaso CP: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPayment con creditCardPayment, spoV2+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-26)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.creditCardPayment.rrn check value 11223344 in position 0
        And from $pspNotifyPayment.creditCardPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.creditCardPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.creditCardPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.creditCardPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.creditCardPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.creditCardPayment.paymentGateway check value 00 in position 0



    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_15 @after
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp1 notify e PSP vp2 spo con Travaso PPAL: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPayment con paypalPayment, spoV2+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-27)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_PPAL_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | PPAL                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | transId               | #transaction_id#                              |
            | pspTransactionId      | #psp_transaction_id#                          |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,pspTransactionId                     |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,PPAL,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.paypalPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.pspTransactionId check value NotNone in position 0
        And from $pspNotifyPayment.paypalPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.paypalPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.paypalPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0







    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_16 @after
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp1 notify e PSP vp2 spo con Travaso BPAY: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPayment con bancomatpayPayment, spoV2+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-28)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_BPAY_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | BPAY                                          |
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
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'Y', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | None                                          |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                            |
            | ID                    | NotNone                                                                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPayment,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                      |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id            |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway                |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,BPAY,NotNone |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2            |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                              |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.ctBancomatpayPayment.transactionId check value NotNone in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.outcomePaymentGateway check value 00 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.totalAmount check value 12 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.fee check value 2 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.timestampOperation check value 2021-07-09T17:06:03 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.authorizationCode check value 123456 in position 0
        And from $pspNotifyPayment.ctBancomatpayPayment.paymentGateway check value 00 in position 0



    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_17
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp2 notify e PSP vp1 spo: checkPosition con 1 nav, activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyPaymentV2 con additionalPaymentInformations, spo+ -> paSendRTV2, BIZ+ e SPRv2+ (NMU-29)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                     | password   | paymentToken                                  | outcome |
            | #psp# | #psp#       | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | None                                          |
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
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
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
            | FLAG_FINAL_PAYMENT    | N                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | None                            |
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
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                 |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NotNone                                       |
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
            | RICEVUTA_PM                | Y                                             |
            | FLAG_PAYPAL                | N                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | TRANSACTION_ID             | $transaction_id                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
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
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                        |
            | ID                    | NotNone                                                                                                                                      |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                          |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                                                                        |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                      |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                                                                                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                                                                |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTIFIED                                      |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
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
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                               |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway         |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2     |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                            |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value tipoVersamento in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value CP in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value outcomePaymentGateway in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value timestampOperation in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value totalAmount in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 12 in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value paymentGateway in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value fee in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2 in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value authorizationCode in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 123456 in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value rrn in position 7
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 11223344 in position 7



    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_18
    Scenario: NMU flow OK, FLOW con PA New vp1 e PSP vp2 con Multitoken: checkPosition con 4 nav, 4x activateV2 -> paGetPayment , closeV2+ -> pspNotifyV2 con 4 token, spoV2+ con 4 token -> 4x paSendRT+, 4x BIZ+ e SPRv2+ (NMU-17)
        Given from body with datatable vertical checkPositionBody_4element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | fiscalCode3   | #creditor_institution_code# |
            | fiscalCode4   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
            | noticeNumber3 | 302#iuv2#                   |
            | noticeNumber4 | 302#iuv3#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        And saving paGetPayment request in paGetPayment_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv1                             |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And saving paGetPayment request in paGetPayment_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv2     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv2                             |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_3
        And saving paGetPayment request in paGetPayment_3
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_3
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv3     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv3                             |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_4
        And saving paGetPayment request in paGetPayment_4
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_4
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | token3                | $activatePaymentNoticeV2_3Response.paymentToken |
            | token4                | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #psp#                                           |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 42                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 42                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable vertical sendPaymentOutcomeV2Body_4paymentToken_noOptional initial XML sendPaymentOutcomeV2
            | idPSP       | #psp#                                           |
            | idBrokerPSP | #psp#                                           |
            | idChannel   | #canale_versione_primitive_2#                   |
            | password    | #password#                                      |
            | payToken1   | $activatePaymentNoticeV2_1Response.paymentToken |
            | payToken2   | $activatePaymentNoticeV2_2Response.paymentToken |
            | payToken3   | $activatePaymentNoticeV2_3Response.paymentToken |
            | payToken4   | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome     | OK                                              |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # ACTIVATE 1
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv1                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv2                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_3.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv3                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_4.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | None                    |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 02$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 02$iuv1                           |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 02$iuv2                           |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_3.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 02$iuv3                           |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_4.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                          |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_1.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv1                                         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_2.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv2                                         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_3Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_3.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_3.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv3                                         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_4Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_4.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_4.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
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
        # ACTIVATE 2
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 02$iuv1                               |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_2.amount     |
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
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 02$iuv2                               |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_3.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_3.amount     |
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
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 02$iuv3                               |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_4.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_4.amount     |
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
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_1.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_3.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPayment_3.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_4.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPayment_4.creditorReferenceId                                                                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 2
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv1                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 3
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv2                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_3.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 4
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv3                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_4.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 1
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 2
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 3
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_3.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 4
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_4.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 1
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 2
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 3
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_3.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 4
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_4.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 1
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        # ACTIVATE 2
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # ACTIVATE 3
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_3Response.paymentToken |
        # ACTIVATE 4
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_4Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                                                                                                                                                                                                                       |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id                                                             |
            | KEY            | Token,Token,Token,Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn                                                                                                                       |
            | VALUE          | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2_3Response.paymentToken,$activatePaymentNoticeV2_4Response.paymentToken,CP,NotNone,2021-07-09T17:06:03,42,NotNone,2,123456,11223344 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2                                                             |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2                                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                              |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value tipoVersamento in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value CP in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value outcomePaymentGateway in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value timestampOperation in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value totalAmount in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 42 in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value paymentGateway in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value fee in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2 in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value authorizationCode in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 123456 in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value rrn in position 7
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 11223344 in position 7



    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_19
    Scenario: NMU flow OK, FLOW con PA New vp2 e PSP vp2 con Multitoken: checkPosition con 4 nav, 4x activateV2 -> paGetPaymentV2, closeV2+ -> pspNotifyV2 con 4 token, spoV2+ con 4 token -> 4x paSendRTV2, 4x BIZ+ e SPRv2+ (NMU-30)
        Given from body with datatable vertical checkPositionBody_4element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | fiscalCode3   | #creditor_institution_code# |
            | fiscalCode4   | #creditor_institution_code# |
            | noticeNumber1 | 310#iuv#                    |
            | noticeNumber2 | 310#iuv1#                   |
            | noticeNumber3 | 310#iuv2#                   |
            | noticeNumber4 | 310#iuv3#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv1     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv1                             |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv2     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv2                             |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_3
        And saving paGetPaymentV2 request in paGetPaymentV2_3
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_3
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv3     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv3                             |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_4
        And saving paGetPaymentV2 request in paGetPaymentV2_4
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_4
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | token3                | $activatePaymentNoticeV2_3Response.paymentToken |
            | token4                | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #psp#                                           |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 42                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 42                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable vertical sendPaymentOutcomeV2Body_4paymentToken_noOptional initial XML sendPaymentOutcomeV2
            | idPSP       | #psp#                                           |
            | idBrokerPSP | #psp#                                           |
            | idChannel   | #canale_versione_primitive_2#                   |
            | password    | #password#                                      |
            | payToken1   | $activatePaymentNoticeV2_1Response.paymentToken |
            | payToken2   | $activatePaymentNoticeV2_2Response.paymentToken |
            | payToken3   | $activatePaymentNoticeV2_3Response.paymentToken |
            | payToken4   | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome     | OK                                              |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # ACTIVATE 1
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv                                          |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv1                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv2                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_3.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv3                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | None                                            |
            | AMOUNT                | $activatePaymentNoticeV2_4.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | NotNone                 |
            | OFFICE_NAME        | None                    |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 10$iuv                            |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 10$iuv1                           |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 10$iuv2                           |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_3.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | 10$iuv3                           |
            | DUE_DATE              | NotNone                           |
            | RETENTION_DATE        | None                              |
            | AMOUNT                | $activatePaymentNoticeV2_4.amount |
            | FLAG_FINAL_PAYMENT    | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | METADATA              | None                              |
            | FK_POSITION_SERVICE   | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 10$iuv                                          |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_1.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 10$iuv1                                         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_2.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 10$iuv2                                         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_3Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_3.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_3.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | CREDITOR_REFERENCE_ID      | 10$iuv3                                         |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_4Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_4.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_4.amount               |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | NotNone                                         |
            | PAYMENT_METHOD             | None                                            |
            | PAYMENT_CHANNEL            | None                                            |
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
            | RICEVUTA_PM                | Y                                               |
            | FLAG_PAYPAL                | N                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | TRANSACTION_ID             | $transaction_id                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 10$iuv                                |
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
        # ACTIVATE 2
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 10$iuv1                               |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_2.amount     |
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
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 10$iuv2                               |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_3.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_3.amount     |
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
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                 |
            | ID                       | NotNone                               |
            | CREDITOR_REFERENCE_ID    | 10$iuv3                               |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2_4.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016           |
            | AMOUNT                   | $activatePaymentNoticeV2_4.amount     |
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
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_1.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        # ACTIVATE 2
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_2.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        # ACTIVATE 3
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_3.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_3.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
        # ACTIVATE 4
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                              |
            | ID                    | NotNone                                                                                                                                            |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4.fiscalCode                                                                                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2_4.noticeNumber                                                                                                            |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                            |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_4.creditorReferenceId                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken                                                                                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,closePayment-v2,closePayment-v2,pspNotifyPaymentV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC               |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
        # ACTIVATE 1
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 2
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv1                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 3
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv2                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_3.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 4
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv3                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_4.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 1
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 2
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 3
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_3.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 4
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                |
            | ID                 | NotNone              |
            | STATUS             | PAYING,PAID,NOTIFIED |
            | INSERTED_TIMESTAMP | NotNone              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                  |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_4.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # ACTIVATE 1
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 2
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 3
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_3.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_3.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_3.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 4
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value    |
            | ID                  | NotNone  |
            | STATUS              | NOTIFIED |
            | INSERTED_TIMESTAMP  | NotNone  |
            | UPDATED_TIMESTAMP   | NotNone  |
            | FK_POSITION_SERVICE | NotNone  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_4.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_4.fiscalCode   |
            | ORDER BY       | ID ASC                                  |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_4.noticeNumber |
            | ORDER BY   | ID ASC                                  |
        # ACTIVATE 1
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        # ACTIVATE 2
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # ACTIVATE 3
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_3Response.paymentToken |
        # ACTIVATE 4
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_4Response.paymentToken |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                                                                                                                                                                                                                       |
            | TRANSACTION_ID | $transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id,$transaction_id                                                             |
            | KEY            | Token,Token,Token,Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn                                                                                                                       |
            | VALUE          | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2_3Response.paymentToken,$activatePaymentNoticeV2_4Response.paymentToken,CP,NotNone,2021-07-09T17:06:03,42,NotNone,2,123456,11223344 |
            | INSERTED_BY    | closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2                                                             |
            | UPDATED_BY     | closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2                                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # RE
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPaymentV2                              |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPayment
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value tipoVersamento in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value CP in position 0
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value outcomePaymentGateway in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 1
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value timestampOperation in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value totalAmount in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 42 in position 3
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value paymentGateway in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 00 in position 4
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value fee in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 2 in position 5
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value authorizationCode in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 123456 in position 6
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.key check value rrn in position 7
        And from $pspNotifyPayment.additionalPaymentInformations.metadata.mapEntry.value check value 11223344 in position 7




    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_20 @after
    Scenario: NMU flow paNEW OK con broadcast paPrinc!=paSec MBD, FLOW: con PA con broadcast sia vp1 che vp2, checkPosition con 1 nav, activateV2 -> paGetPaymentV2 con MBD, closeV2+ -> pspNotifyPaymentV2 con MBD, spoV2 con MBD+ -> paSendRTV2 con MBD verso stazione principale, paSendRT con IBAN fittizio e paSendRTV2 con MBD verso le broadcast delle PA secondarie, paSendRTV2 con MBD verso le broadcast vp2 della PA principale, BIZ+ e SPRv2+ (NMU-49)
        Given updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with Y under macro NewMod1 on db nodo_cfg
        And wait 7 seconds after triggered refresh job ALL
        And MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 310#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_MBD_noOptional initial XML paGetPaymentV2
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
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_versione_primitive_2#                 |
            | paymentMethod         | CP                                            |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_MBD_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome | paymentMethod | fee  | MBDAttachment |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      | creditCard    | 2.00 | $bollo        |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        And checks the value PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
        And checks the value PAYING,PAID,NOTIFIED of the record at column STATUS of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And checks the value NOTIFIED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |




    @ALL @NMU @NMUPANEW @NMUPANEWPAGOK @NMUPANEWPAGOK_21 @after
    Scenario: NMU flow paNEW OK con Multitoken, FLOW: con token1: PA Old, token2: PA New vp1, token3: PA New vp2, token4: PA New vp1 standin, token5: PA New vp2 standin. Le PA New hanno tutte delle broadcast sia vp1 che vp2. checkPosition con 5 nav, 5x activateV2 (la presenza del flag standin dipende dalla configurazione del psp eCommerce, non da quella del PSP vero) -> token1: paaAttivaRPT, token2: paGetPayment 5 transfer paPrincip = paSecond, token3: paGetPaymentV2 5 transfer paPrincip = paSecond, token4: paGetPayment verso ACA 5 transfer paPrincip = paSecond e token5: paGetPaymentV2 verso ACA 5 transfer paPrincip = paSecond, nodoInviaRPT token1, closeV2+ -> pspNotifyV2 con 5 token e senza il flag standin=true, spoV2+ con 5 token -> token1: paaInviaRT+; token2: paSendRT verso stazione principale, paSendRT/V2 verso broadcast PA secondarie (compresa PA principale che è anche secondaria?); token3: paSendRTV2 verso stazione principale, paSendRT/V2 verso broadcast PA secondarie, paSendRTV2 verso broadcast PA principale (anche le paSendRT visto che è sia principale che secondaria?); token4: paSendRT verso stazione principale (quella del nav), paSendRT/V2 verso broadcast PA secondarie (compresa PA principale che è anche secondaria?); token5: paSendRTV2 verso stazione principale (quella del nav), paSendRT/V2 verso broadcast PA secondarie, paSendRTV2 verso broadcast PA principale (anche le paSendRT visto che è sia principale che secondaria?). Tutte le receipt NON hanno il flag standin=true, 5x BIZ+ e SPRv2+ (NMU-35)
        Given update parameter invioReceiptStandin on configuration keys with value true
        And from body with datatable vertical checkPositionBody_4element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | fiscalCode3   | #creditor_institution_code# |
            | fiscalCode4   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 310#iuv1#                   |
            | noticeNumber3 | 347#iuv2#                   |
            | noticeNumber4 | 347#iuv3#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 25.00  |
        And from body with datatable vertical paGetPayment_5transfer_noOptional initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 25.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 5.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA4               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA5               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv1     | 25.00  |
        And from body with datatable vertical paGetPaymentV2_5transfer_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 25.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 5.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA4               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA5               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given update parameter station.stand-in on configuration keys with value 66666666666_01
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter VERSIONE_PRIMITIVE = '1', with where condition OBJ_ID = '1200001' under macro update_query on db nodo_cfg
        And wait 60 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 347$iuv2     | 25.00  |
        And from body with datatable vertical paGetPayment_5transfer_noOptional initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 47$iuv                              |
            | paymentAmount               | 25.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 5.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA4               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA5               | $activatePaymentNoticeV2.fiscalCode |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_3Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_3
        Given update parameter station.stand-in on configuration keys with value 66666666666_08
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter VERSIONE_PRIMITIVE = '2', with where condition OBJ_ID = '1200001' under macro update_query on db nodo_cfg
        And wait 60 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 347$iuv3     | 25.00  |
        And from body with datatable vertical paGetPaymentV2_5transfer_noOptional initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 47$iuv                              |
            | paymentAmount               | 25.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 5.00                                |
            | fiscalCodePA1               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA2               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA3               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA4               | $activatePaymentNoticeV2.fiscalCode |
            | fiscalCodePA5               | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_4Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_4
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | token3                | $activatePaymentNoticeV2_3Response.paymentToken |
            | token4                | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #psp#                                           |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 102                                             |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 102                                             |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable vertical sendPaymentOutcomeV2Body_4paymentToken_noOptional initial XML sendPaymentOutcomeV2
            | idPSP       | #psp#                                           |
            | idBrokerPSP | #psp#                                           |
            | idChannel   | #canale_ATTIVATO_PRESSO_PSP#                    |
            | password    | #password#                                      |
            | payToken1   | $activatePaymentNoticeV2_1Response.paymentToken |
            | payToken2   | $activatePaymentNoticeV2_2Response.paymentToken |
            | payToken3   | $activatePaymentNoticeV2_3Response.paymentToken |
            | payToken4   | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome     | OK                                              |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration




    @after
    Scenario: After restore
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter FLAG_TRAVASO = 'N', with where condition OBJ_ID = '16649' under macro update_query on db nodo_cfg
        And updates through the query update_obj_id_1 of the table PA_STAZIONE_PA the parameter BROADCAST with N under macro NewMod1 on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter VERSIONE_PRIMITIVE = '1', with where condition OBJ_ID = '1200001' under macro update_query on db nodo_cfg
        And update parameter invioReceiptStandin on configuration keys with value false
        And update parameter station.stand-in on configuration keys with value 66666666666_01
        And wait 3 seconds after triggered refresh job ALL

