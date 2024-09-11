Feature: NM3 flows PA Old sessione scaduta

    Background:
        Given systems up


    @ALL @FLOW @FLOW_NOOPT @NM3 @NM3PAOLD @NM3PAOLDSESSCADUTA @NM3PAOLDSESSCADUTA_1 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT  nodoInviaRPT (scadenza sessione)  mod3cancelV1 -> paaInviaRT- BIZ- (NM3-9)
        Given update parameter default_token_duration_validity_millis on configuration keys with value 2000
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #pspFittizio#                               |
            | identificativoIntermediarioPSP        | #brokerFittizio#                            |
            | identificativoCanale                  | #canaleFittizio#                            |
            | rpt                                   | $rptAttachment                              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        # RPT_ACTIVATIONS
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | None                                        |
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
            | RPT_ID                     | NotNone                                     |
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
            | PAYMENT_NOTE               | None                                        |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode               |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber             |
            | STATUS                | PAYING,PAYING_RPT,CANCELLED                     |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken     |
            | INSERTED_BY           | activatePaymentNotice,nodoInviaRPT,mod3CancelV1 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | CANCELLED                                   |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | mod3CancelV1                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                          |
            | ID                    | NotNone                                                                                                        |
            | ID_SESSIONE           | NotNone                                                                                                        |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                        |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                              |
            | IUV                   | 12$iuv                                                                                                         |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                    |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,mod3CancelV1,mod3CancelV1,paaInviaRT                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RT_ACCETTATA_PA                             |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | paaInviaRT                                  |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                      | value                                       |
            | ID_SESSIONE                 | NotNone                                     |
            | IDENT_DOMINIO               | $activatePaymentNotice.fiscalCode           |
            | IUV                         | 12$iuv                                      |
            | CCP                         | $activatePaymentNoticeResponse.paymentToken |
            | BIC_ADDEBITO                | NotNone                                     |
            | DATA_MSG_RICH               | NotNone                                     |
            | FLAG_CANC                   | N                                           |
            | IBAN_ADDEBITO               | NotNone                                     |
            | ID_MSG_RICH                 | NotNone                                     |
            | STAZ_INTERMEDIARIOPA        | #id_station_old#                            |
            | INTERMEDIARIOPA             | #id_broker_old#                             |
            | CANALE                      | #canaleFittizio#                            |
            | PSP                         | #pspFittizio#                               |
            | INTERMEDIARIOPSP            | #brokerFittizio#                            |
            | TIPO_VERSAMENTO             | PO                                          |
            | NUM_VERSAMENTI              | 1                                           |
            | RT_SIGNATURE_CODE           | 0                                           |
            | SOMMA_VERSAMENTI            | 10                                          |
            | PARAMETRI_PROFILO_PAGAMENTO | None                                        |
            | FK_CARRELLO                 | None                                        |
            | INSERTED_TIMESTAMP          | NotNone                                     |
            | UPDATED_TIMESTAMP           | NotNone                                     |
            | RICEVUTA_PM                 | N                                           |
            | WISP_2                      | N                                           |
            | FLAG_SECONDA                | None                                        |
            | FLAG_IO                     | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                       |
            | ID_SESSIONE         | NotNone                                     |
            | IDENT_DOMINIO       | $activatePaymentNotice.fiscalCode           |
            | IUV                 | 12$iuv                                      |
            | CCP                 | $activatePaymentNoticeResponse.paymentToken |
            | COD_ESITO           | 1                                           |
            | ESITO               | NON_ESEGUITO                                |
            | DATA_RICEVUTA       | NotNone                                     |
            | DATA_RICHIESTA      | NotNone                                     |
            | ID_RICEVUTA         | NotNone                                     |
            | ID_RICHIESTA        | NotNone                                     |
            | SOMMA_VERSAMENTI    | 0                                           |
            | INSERTED_TIMESTAMP  | NotNone                                     |
            | UPDATED_TIMESTAMP   | NotNone                                     |
            | CANALE              | #canaleFittizio#                            |
            | NOTIFICA_PROCESSATA | N                                           |
            | GENERATA_DA         | NMP                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleFittizio# in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0
        # paaInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0



    @ALL @FLOW @FLOW_NOOPT @NM3 @NM3PAOLD @NM3PAOLDSESSCADUTA @NM3PAOLDSESSCADUTA_2 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT (scadenza sessione)  mod3cancelV1  nodoInviaRPT -> paaInviaRT- BIZ- (NM3-10)
        Given update parameter default_token_duration_validity_millis on configuration keys with value 2000
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #pspFittizio#                               |
            | identificativoIntermediarioPSP        | #brokerFittizio#                            |
            | identificativoCanale                  | #canaleFittizio#                            |
            | rpt                                   | $rptAttachment                              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        # RPT_ACTIVATIONS
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | None                                        |
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
            | RPT_ID                     | NotNone                                     |
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
            | PAYMENT_NOTE               | None                                        |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode               |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber             |
            | STATUS                | PAYING,CANCELLED_NORPT,CANCELLED                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken     |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | CANCELLED                                   |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | nodoInviaRPT                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                          |
            | ID                    | NotNone                                                                                                        |
            | ID_SESSIONE           | NotNone                                                                                                        |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                        |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                              |
            | IUV                   | 12$iuv                                                                                                         |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                    |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,paaInviaRT                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RT_ACCETTATA_PA                             |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | paaInviaRT                                  |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                      | value                                       |
            | ID_SESSIONE                 | NotNone                                     |
            | IDENT_DOMINIO               | $activatePaymentNotice.fiscalCode           |
            | IUV                         | 12$iuv                                      |
            | CCP                         | $activatePaymentNoticeResponse.paymentToken |
            | BIC_ADDEBITO                | NotNone                                     |
            | DATA_MSG_RICH               | NotNone                                     |
            | FLAG_CANC                   | N                                           |
            | IBAN_ADDEBITO               | NotNone                                     |
            | ID_MSG_RICH                 | NotNone                                     |
            | STAZ_INTERMEDIARIOPA        | #id_station_old#                            |
            | INTERMEDIARIOPA             | #id_broker_old#                             |
            | CANALE                      | #canaleFittizio#                            |
            | PSP                         | #pspFittizio#                               |
            | INTERMEDIARIOPSP            | #brokerFittizio#                            |
            | TIPO_VERSAMENTO             | PO                                          |
            | NUM_VERSAMENTI              | 1                                           |
            | RT_SIGNATURE_CODE           | 0                                           |
            | SOMMA_VERSAMENTI            | 10                                          |
            | PARAMETRI_PROFILO_PAGAMENTO | None                                        |
            | FK_CARRELLO                 | None                                        |
            | INSERTED_TIMESTAMP          | NotNone                                     |
            | UPDATED_TIMESTAMP           | NotNone                                     |
            | RICEVUTA_PM                 | N                                           |
            | WISP_2                      | N                                           |
            | FLAG_SECONDA                | None                                        |
            | FLAG_IO                     | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                       |
            | ID_SESSIONE         | NotNone                                     |
            | IDENT_DOMINIO       | $activatePaymentNotice.fiscalCode           |
            | IUV                 | 12$iuv                                      |
            | CCP                 | $activatePaymentNoticeResponse.paymentToken |
            | COD_ESITO           | 1                                           |
            | ESITO               | NON_ESEGUITO                                |
            | DATA_RICEVUTA       | NotNone                                     |
            | DATA_RICHIESTA      | NotNone                                     |
            | ID_RICEVUTA         | NotNone                                     |
            | ID_RICHIESTA        | NotNone                                     |
            | SOMMA_VERSAMENTI    | 0                                           |
            | INSERTED_TIMESTAMP  | NotNone                                     |
            | UPDATED_TIMESTAMP   | NotNone                                     |
            | CANALE              | #canaleFittizio#                            |
            | NOTIFICA_PROCESSATA | N                                           |
            | GENERATA_DA         | NMP                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleFittizio# in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0
        # paaInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0


    @ALL @FLOW @FLOW_NOOPT @NM3 @NM3PAOLD @NM3PAOLDSESSCADUTA @NM3PAOLDSESSCADUTA_3 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp2: activateV2 -> paaAttivaRPT  nodoInviaRPT (scadenza sessione)  mod3cancelV1 -> paaInviaRT- BIZ- (NM3-35)
        Given update parameter default_token_duration_validity_millis on configuration keys with value 2000
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#               |
            | identificativoStazioneRichiedente | #id_station_old#                              |
            | dataOraMessaggioRichiesta         | #timedate#                                    |
            | dataEsecuzionePagamento           | #date#                                        |
            | importoTotaleDaVersare            | $activatePaymentNoticeV2.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                        |
            | codiceContestoPagamento           | $activatePaymentNoticeV2Response.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNoticeV2.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
            | password                              | #password#                                    |
            | identificativoPSP                     | #pspFittizio#                                 |
            | identificativoIntermediarioPSP        | #brokerFittizio#                              |
            | identificativoCanale                  | #canaleFittizio#                              |
            | rpt                                   | $rptAttachment                                |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        # RPT_ACTIVATIONS
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station_old#                              |
            | STATION_VERSION            | 1                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #intermediarioPSP2#                           |
            | CHANNEL_ID                 | #canale32#                                    |
            | IDEMPOTENCY_KEY            | None                                          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | None                                          |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | None                                          |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | NotNone                                       |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | N                                             |
            | RICEVUTA_PM                | None                                          |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | FLAG_PAYPAL                | None                                          |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | activatePaymentNoticeV2                       |
            | TRANSACTION_ID             | None                                          |
            | CLOSE_VERSION              | None                                          |
            | FEE_PA                     | None                                          |
            | BUNDLE_ID                  | None                                          |
            | BUNDLE_PA_ID               | None                                          |
            | PM_INFO                    | None                                          |
            | MBD                        | N                                             |
            | FEE_SPO                    | None                                          |
            | PAYMENT_NOTE               | None                                          |
            | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                             |
            | ID                    | NotNone                                           |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode               |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber             |
            | STATUS                | PAYING,PAYING_RPT,CANCELLED                       |
            | INSERTED_TIMESTAMP    | NotNone                                           |
            | CREDITOR_REFERENCE_ID | 12$iuv                                            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken     |
            | INSERTED_BY           | activatePaymentNoticeV2,nodoInviaRPT,mod3CancelV1 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED                                     |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | mod3CancelV1                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                          |
            | ID                    | NotNone                                                                                                        |
            | ID_SESSIONE           | NotNone                                                                                                        |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                        |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                            |
            | IUV                   | 12$iuv                                                                                                         |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                  |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,mod3CancelV1,mod3CancelV1,paaInviaRT                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID_SESSIONE        | NotNone                                       |
            | ID_DOMINIO         | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                | 12$iuv                                        |
            | CCP                | $activatePaymentNoticeV2Response.paymentToken |
            | STATO              | RT_ACCETTATA_PA                               |
            | INSERTED_BY        | nodoInviaRPT                                  |
            | UPDATED_BY         | paaInviaRT                                    |
            | INSERTED_TIMESTAMP | NotNone                                       |
            | UPDATED_TIMESTAMP  | NotNone                                       |
            | PUSH               | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                      | value                                         |
            | ID_SESSIONE                 | NotNone                                       |
            | IDENT_DOMINIO               | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                         | 12$iuv                                        |
            | CCP                         | $activatePaymentNoticeV2Response.paymentToken |
            | BIC_ADDEBITO                | NotNone                                       |
            | DATA_MSG_RICH               | NotNone                                       |
            | FLAG_CANC                   | N                                             |
            | IBAN_ADDEBITO               | NotNone                                       |
            | ID_MSG_RICH                 | NotNone                                       |
            | STAZ_INTERMEDIARIOPA        | #id_station_old#                              |
            | INTERMEDIARIOPA             | #id_broker_old#                               |
            | CANALE                      | #canaleFittizio#                              |
            | PSP                         | #pspFittizio#                                 |
            | INTERMEDIARIOPSP            | #brokerFittizio#                              |
            | TIPO_VERSAMENTO             | PO                                            |
            | NUM_VERSAMENTI              | 1                                             |
            | RT_SIGNATURE_CODE           | 0                                             |
            | SOMMA_VERSAMENTI            | 10                                            |
            | PARAMETRI_PROFILO_PAGAMENTO | None                                          |
            | FK_CARRELLO                 | None                                          |
            | INSERTED_TIMESTAMP          | NotNone                                       |
            | UPDATED_TIMESTAMP           | NotNone                                       |
            | RICEVUTA_PM                 | N                                             |
            | WISP_2                      | N                                             |
            | FLAG_SECONDA                | None                                          |
            | FLAG_IO                     | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                         |
            | ID_SESSIONE         | NotNone                                       |
            | IDENT_DOMINIO       | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                 | 12$iuv                                        |
            | CCP                 | $activatePaymentNoticeV2Response.paymentToken |
            | COD_ESITO           | 1                                             |
            | ESITO               | NON_ESEGUITO                                  |
            | DATA_RICEVUTA       | NotNone                                       |
            | DATA_RICHIESTA      | NotNone                                       |
            | ID_RICEVUTA         | NotNone                                       |
            | ID_RICHIESTA        | NotNone                                       |
            | SOMMA_VERSAMENTI    | 0                                             |
            | INSERTED_TIMESTAMP  | NotNone                                       |
            | UPDATED_TIMESTAMP   | NotNone                                       |
            | CANALE              | #canaleFittizio#                              |
            | NOTIFICA_PROCESSATA | N                                             |
            | GENERATA_DA         | NMP                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
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
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale32# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleFittizio# in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0
        # paaInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0



    @ALL @FLOW @FLOW_NOOPT @NM3 @NM3PAOLD @NM3PAOLDSESSCADUTA @NM3PAOLDSESSCADUTA_4 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp2: activateV2 -> paaAttivaRPT (scadenza sessione)  mod3cancelV1  nodoInviaRPT -> paaInviaRT- BIZ- (NM3-36)
        Given update parameter default_token_duration_validity_millis on configuration keys with value 2000
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#               |
            | identificativoStazioneRichiedente | #id_station_old#                              |
            | dataOraMessaggioRichiesta         | #timedate#                                    |
            | dataEsecuzionePagamento           | #date#                                        |
            | importoTotaleDaVersare            | $activatePaymentNoticeV2.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                        |
            | codiceContestoPagamento           | $activatePaymentNoticeV2Response.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNoticeV2.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
            | password                              | #password#                                    |
            | identificativoPSP                     | #pspFittizio#                                 |
            | identificativoIntermediarioPSP        | #brokerFittizio#                              |
            | identificativoCanale                  | #canaleFittizio#                              |
            | rpt                                   | $rptAttachment                                |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        # RPT_ACTIVATIONS
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station_old#                              |
            | STATION_VERSION            | 1                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #intermediarioPSP2#                           |
            | CHANNEL_ID                 | #canale32#                                    |
            | IDEMPOTENCY_KEY            | None                                          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | None                                          |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | None                                          |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | NotNone                                       |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | N                                             |
            | RICEVUTA_PM                | None                                          |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | FLAG_PAYPAL                | None                                          |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | activatePaymentNoticeV2                       |
            | TRANSACTION_ID             | None                                          |
            | CLOSE_VERSION              | None                                          |
            | FEE_PA                     | None                                          |
            | BUNDLE_ID                  | None                                          |
            | BUNDLE_PA_ID               | None                                          |
            | PM_INFO                    | None                                          |
            | MBD                        | N                                             |
            | FEE_SPO                    | None                                          |
            | PAYMENT_NOTE               | None                                          |
            | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                             |
            | ID                    | NotNone                                           |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode               |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber             |
            | STATUS                | PAYING,CANCELLED_NORPT,CANCELLED                  |
            | INSERTED_TIMESTAMP    | NotNone                                           |
            | CREDITOR_REFERENCE_ID | 12$iuv                                            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken     |
            | INSERTED_BY           | activatePaymentNoticeV2,mod3CancelV1,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED                                     |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | nodoInviaRPT                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                          |
            | ID                    | NotNone                                                                                                        |
            | ID_SESSIONE           | NotNone                                                                                                        |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                        |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                            |
            | IUV                   | 12$iuv                                                                                                         |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                  |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,paaInviaRT                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID_SESSIONE        | NotNone                                       |
            | ID_DOMINIO         | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                | 12$iuv                                        |
            | CCP                | $activatePaymentNoticeV2Response.paymentToken |
            | STATO              | RT_ACCETTATA_PA                               |
            | INSERTED_BY        | nodoInviaRPT                                  |
            | UPDATED_BY         | paaInviaRT                                    |
            | INSERTED_TIMESTAMP | NotNone                                       |
            | UPDATED_TIMESTAMP  | NotNone                                       |
            | PUSH               | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                      | value                                         |
            | ID_SESSIONE                 | NotNone                                       |
            | IDENT_DOMINIO               | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                         | 12$iuv                                        |
            | CCP                         | $activatePaymentNoticeV2Response.paymentToken |
            | BIC_ADDEBITO                | NotNone                                       |
            | DATA_MSG_RICH               | NotNone                                       |
            | FLAG_CANC                   | N                                             |
            | IBAN_ADDEBITO               | NotNone                                       |
            | ID_MSG_RICH                 | NotNone                                       |
            | STAZ_INTERMEDIARIOPA        | #id_station_old#                              |
            | INTERMEDIARIOPA             | #id_broker_old#                               |
            | CANALE                      | #canaleFittizio#                              |
            | PSP                         | #pspFittizio#                                 |
            | INTERMEDIARIOPSP            | #brokerFittizio#                              |
            | TIPO_VERSAMENTO             | PO                                            |
            | NUM_VERSAMENTI              | 1                                             |
            | RT_SIGNATURE_CODE           | 0                                             |
            | SOMMA_VERSAMENTI            | 10                                            |
            | PARAMETRI_PROFILO_PAGAMENTO | None                                          |
            | FK_CARRELLO                 | None                                          |
            | INSERTED_TIMESTAMP          | NotNone                                       |
            | UPDATED_TIMESTAMP           | NotNone                                       |
            | RICEVUTA_PM                 | N                                             |
            | WISP_2                      | N                                             |
            | FLAG_SECONDA                | None                                          |
            | FLAG_IO                     | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                         |
            | ID_SESSIONE         | NotNone                                       |
            | IDENT_DOMINIO       | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                 | 12$iuv                                        |
            | CCP                 | $activatePaymentNoticeV2Response.paymentToken |
            | COD_ESITO           | 1                                             |
            | ESITO               | NON_ESEGUITO                                  |
            | DATA_RICEVUTA       | NotNone                                       |
            | DATA_RICHIESTA      | NotNone                                       |
            | ID_RICEVUTA         | NotNone                                       |
            | ID_RICHIESTA        | NotNone                                       |
            | SOMMA_VERSAMENTI    | 0                                             |
            | INSERTED_TIMESTAMP  | NotNone                                       |
            | UPDATED_TIMESTAMP   | NotNone                                       |
            | CANALE              | #canaleFittizio#                              |
            | NOTIFICA_PROCESSATA | N                                             |
            | GENERATA_DA         | NMP                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IUV           | 12$iuv                                        |
            | IDENT_DOMINIO | $activatePaymentNoticeV2.fiscalCode           |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
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
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale32# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleFittizio# in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0
        # paaInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaInviaRT                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0


    @ALL @FLOW @FLOW_NOOPT @NM3 @NM3PAOLD @NM3PAOLDSESSCADUTA @NM3PAOLDSESSCADUTA_5 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT (scadenza sessione)  mod3cancelV1 BIZ- (NM3-11)
        Given update parameter default_token_duration_validity_millis on configuration keys with value 2000
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        # POSITION_PAYMENT
        Given generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #id_broker_psp#                             |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | None                                        |
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
            | PAYMENT_NOTE               | None                                        |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING,CANCELLED_NORPT                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1          |
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
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | CANCELLED_NORPT                             |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | mod3CancelV1                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0



    @ALL @FLOW @FLOW_NOOPT @NM3 @NM3PAOLD @NM3PAOLDSESSCADUTA @NM3PAOLDSESSCADUTA_6 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp2: activateV2 -> paaAttivaRPT (scadenza sessione)  mod3cancelV1 BIZ- (NM3-37)
        Given update parameter default_token_duration_validity_millis on configuration keys with value 2000
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        # POSITION_PAYMENT
        Given generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #id_station_old#                              |
            | STATION_VERSION            | 1                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #intermediarioPSP2#                           |
            | CHANNEL_ID                 | #canale32#                                    |
            | IDEMPOTENCY_KEY            | None                                          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | None                                          |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | None                                          |
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
            | UPDATED_BY                 | activatePaymentNoticeV2                       |
            | TRANSACTION_ID             | None                                          |
            | CLOSE_VERSION              | None                                          |
            | FEE_PA                     | None                                          |
            | BUNDLE_ID                  | None                                          |
            | BUNDLE_PA_ID               | None                                          |
            | PM_INFO                    | None                                          |
            | MBD                        | N                                             |
            | FEE_SPO                    | None                                          |
            | PAYMENT_NOTE               | None                                          |
            | FLAG_STANDIN               | N                                             |
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
            | STATUS                | PAYING,CANCELLED_NORPT                        |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNoticeV2,mod3CancelV1          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED_NORPT                               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | mod3CancelV1                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
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
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale32# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0