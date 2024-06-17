Feature: NM3 flows PA Old con pagamento OK

    Background:
        Given systems up


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_1 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT  spo+  nodoInviaRPT -> paaInviaRT+ (subito, senza job paInviaRT) BIZ+ (NM3-2)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     |
        And from body with datatable vertical paVerifyPaymentNotice_noOptional initial XML paVerifyPaymentNotice
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
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
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
            | OUTCOME                    | NotNone                                     |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | NotNone                                     |
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
            | UPDATED_BY                 | sendPaymentOutcome                          |
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
            | column                | value                                                                           |
            | ID                    | NotNone                                                                         |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                               |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                             |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                           |
            | INSERTED_TIMESTAMP    | NotNone                                                                         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                          |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                     |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | nodoInviaRPT                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                                             |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                                   |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,paaInviaRT                                      |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
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
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
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



    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_2 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: verify -> paaVerificaRPT activate -> paaAttivaRPT  nodoInviaRPT spo+ -> paaInviaRT+ (subito, senza job paInviaRT) nodoChiediStatoRPT nodoChiediCopiaRT BIZ+ BIZ+ (NM3-1)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_noOptional initial XML paaVerificaRPT
            | esito                    | OK                          |
            | importoSingoloVersamento | 10.00                       |
            | ibanAccredito            | IT45R0760103200000000001016 |
            | causaleVersamento        | pagamentoTest               |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | password                              | #password#                                  |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_PARCHEGGIATA_NODO_MOD3 of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RISOLTA_OK of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | password                              | #password#                                  |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response
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
            | OUTCOME                    | NotNone                                     |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | NotNone                                     |
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
            | UPDATED_BY                 | sendPaymentOutcome                          |
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
            | column                | value                                                                                       |
            | ID                    | NotNone                                                                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                         |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                                 |
            | INSERTED_BY           | activatePaymentNotice,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                                             |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                                   |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paaInviaRT                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
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
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
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



    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_3 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp2: activateV2 -> paaAttivaRPT nodoInviaRPT spoV2+ -> paaInviaRT+ BIZ+ (NM3-27)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        And job paInviaRt triggered after 3 seconds
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
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
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | NotNone                                       |
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
            | UPDATED_BY                 | sendPaymentOutcomeV2                          |
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
            | column                | value                                                                                               |
            | ID                    | NotNone                                                                                             |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                 |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                               |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                               |
            | INSERTED_TIMESTAMP    | NotNone                                                                                             |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                       |
            | INSERTED_BY           | activatePaymentNoticeV2,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
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
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | NOTICE_STORED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | sendPaymentOutcomeV2                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                                           |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                                 |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paInviaRt,paaInviaRT                         |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID_SESSIONE        | NotNone                                       |
            | ID_DOMINIO         | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                | 12$iuv                                        |
            | CCP                | $activatePaymentNoticeV2Response.paymentToken |
            | STATO              | RT_ACCETTATA_PA                               |
            | INSERTED_BY        | nodoInviaRPT                                  |
            | UPDATED_BY         | paInviaRt                                     |
            | INSERTED_TIMESTAMP | NotNone                                       |
            | UPDATED_TIMESTAMP  | NotNone                                       |
            | PUSH               | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
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
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
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


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_4 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp2: activateV2 -> paaAttivaRPT  spoV2+  nodoInviaRPT -> paaInviaRT+ BIZ+ (NM3-28)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
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
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | NotNone                                       |
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
            | UPDATED_BY                 | sendPaymentOutcomeV2                          |
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
            | column                | value                                                                               |
            | ID                    | NotNone                                                                             |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                 |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                               |
            | STATUS                | PAYING,PAID_NORPT,PAID,NOTICE_GENERATED,NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                                                             |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                       |
            | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcomeV2,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT |
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
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | NOTICE_STORED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | nodoInviaRPT                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                                           |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                                 |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,paaInviaRT                                      |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
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
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
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

    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_5 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: verificaBollettino -> paaVerificaRPT activate -> paaAttivaRPT  nodoInviaRPT spo+ -> paaInviaRT+ (tramite job paInviaRT) nodoChiediStatoRPT nodoChiediCopiaRT BIZ+ BIZ+ (NM3-4)
        Given from body with datatable horizontal verificaBollettino_noOptional initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_noOptional initial XML paaVerificaRPT
            | esito                    | OK                          |
            | importoSingoloVersamento | 10.00                       |
            | ibanAccredito            | IT45R0760103200000000001016 |
            | causaleVersamento        | pagamentoTest               |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                | outcome |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job paInviaRt triggered after 3 seconds
        Then check outcome is OK of sendPaymentOutcome response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | password                              | #password#                                  |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_PARCHEGGIATA_NODO_MOD3 of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RISOLTA_OK of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | password                              | #password#                                  |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response
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
            | PSP_ID                     | $activatePaymentNotice.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNotice.idBrokerPSP          |
            | CHANNEL_ID                 | $activatePaymentNotice.idChannel            |
            | IDEMPOTENCY_KEY            | None                                        |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | NotNone                                     |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | NotNone                                     |
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
            | UPDATED_BY                 | sendPaymentOutcome                          |
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
            | column                | value                                                                                       |
            | ID                    | NotNone                                                                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                         |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                                 |
            | INSERTED_BY           | activatePaymentNotice,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                                             |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                                   |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,paInviaRt,paaInviaRT                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RT_ACCETTATA_PA                             |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | paInviaRt                                   |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
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
        And from $activatePaymentNoticeReq.idPSP xml check value $activatePaymentNotice.idPSP in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value $activatePaymentNotice.idBrokerPSP in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value $activatePaymentNotice.idChannel in position 0
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
        And from $sendPaymentOutcomeReq.idPSP xml check value $sendPaymentOutcome.idPSP in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value $sendPaymentOutcome.idBrokerPSP in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value $sendPaymentOutcome.idChannel in position 0
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
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
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


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_6 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp2: verificaBollettino -> paaVerificaRPT activatev2 -> paaAttivaRPT  nodoInviaRPT spov2+ -> paaInviaRT+ (tramite job paInviaRT) nodoChiediStatoRPT nodoChiediCopiaRT BIZ+ BIZ+ (NM3-30)
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter VERSIONE_PRIMITIVE = '2', with where condition OBJ_ID = '14748' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal verificaBollettino_noOptional initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_noOptional initial XML paaVerificaRPT
            | esito                    | OK                          |
            | importoSingoloVersamento | 10.00                       |
            | ibanAccredito            | IT45R0760103200000000001016 |
            | causaleVersamento        | pagamentoTest               |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
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
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                  | outcome |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        And job paInviaRt triggered after 3 seconds
        Then check outcome is OK of sendPaymentOutcomeV2 response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | password                              | #password#                                    |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_PARCHEGGIATA_NODO_MOD3 of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RISOLTA_OK of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | password                              | #password#                                    |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response
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
            | PSP_ID                     | $activatePaymentNoticeV2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2.idBrokerPSP          |
            | CHANNEL_ID                 | $activatePaymentNoticeV2.idChannel            |
            | IDEMPOTENCY_KEY            | None                                          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | NotNone                                       |
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
            | UPDATED_BY                 | sendPaymentOutcomeV2                          |
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
            | column                | value                                                                                               |
            | ID                    | NotNone                                                                                             |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                 |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                               |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                               |
            | INSERTED_TIMESTAMP    | NotNone                                                                                             |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                       |
            | INSERTED_BY           | activatePaymentNoticeV2,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
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
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | NOTICE_STORED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | sendPaymentOutcomeV2                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                                           |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                                 |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paInviaRt,paaInviaRT                         |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID_SESSIONE        | NotNone                                       |
            | ID_DOMINIO         | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                | 12$iuv                                        |
            | CCP                | $activatePaymentNoticeV2Response.paymentToken |
            | STATO              | RT_ACCETTATA_PA                               |
            | INSERTED_BY        | nodoInviaRPT                                  |
            | UPDATED_BY         | paInviaRt                                     |
            | INSERTED_TIMESTAMP | NotNone                                       |
            | UPDATED_TIMESTAMP  | NotNone                                       |
            | PUSH               | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
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
        And from $activatePaymentNoticeReq.idPSP xml check value $activatePaymentNoticeV2.idPSP in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value $activatePaymentNoticeV2.idBrokerPSP in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value $activatePaymentNoticeV2.idChannel in position 0
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
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value $sendPaymentOutcomeV2.idPSP in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value $sendPaymentOutcomeV2.idBrokerPSP in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value $sendPaymentOutcomeV2.idChannel in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
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


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_7 @after
    Scenario: NM3 flow OK, FLOW con PSP POSTE vp2 activate PSP POSTE vp1 spo: verificaBollettino -> paaVerificaRPT activatev2 -> paaAttivaRPT  nodoInviaRPT spo+ -> paaInviaRT+ (tramite job paInviaRT) nodoChiediStatoRPT nodoChiediCopiaRT BIZ+ BIZ+ (NM3-73)
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter VERSIONE_PRIMITIVE = '2', with where condition OBJ_ID = '14748' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal verificaBollettino_noOptional initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_noOptional initial XML paaVerificaRPT
            | esito                    | OK                          |
            | importoSingoloVersamento | 10.00                       |
            | ibanAccredito            | IT45R0760103200000000001016 |
            | causaleVersamento        | pagamentoTest               |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
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
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter VERSIONE_PRIMITIVE = '1', with where condition OBJ_ID = '14748' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                  | outcome |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        And job paInviaRt triggered after 3 seconds
        Then check outcome is OK of sendPaymentOutcome response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | password                              | #password#                                    |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_PARCHEGGIATA_NODO_MOD3 of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RISOLTA_OK of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | password                              | #password#                                    |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response
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
            | PSP_ID                     | $activatePaymentNoticeV2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2.idBrokerPSP          |
            | CHANNEL_ID                 | $activatePaymentNoticeV2.idChannel            |
            | IDEMPOTENCY_KEY            | None                                          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | None                                          |
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | NotNone                                       |
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
            | UPDATED_BY                 | sendPaymentOutcome                            |
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
            | column                | value                                                                                         |
            | ID                    | NotNone                                                                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                         |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                         |
            | INSERTED_TIMESTAMP    | NotNone                                                                                       |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                                 |
            | INSERTED_BY           | activatePaymentNoticeV2,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
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
            | CREDITOR_REFERENCE_ID | 12$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | NOTICE_STORED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                                           |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                                 |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,paInviaRt,paaInviaRT                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                         |
            | ID_SESSIONE        | NotNone                                       |
            | ID_DOMINIO         | $activatePaymentNoticeV2.fiscalCode           |
            | IUV                | 12$iuv                                        |
            | CCP                | $activatePaymentNoticeV2Response.paymentToken |
            | STATO              | RT_ACCETTATA_PA                               |
            | INSERTED_BY        | nodoInviaRPT                                  |
            | UPDATED_BY         | paInviaRt                                     |
            | INSERTED_TIMESTAMP | NotNone                                       |
            | UPDATED_TIMESTAMP  | NotNone                                       |
            | PUSH               | None                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
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
        And from $activatePaymentNoticeReq.idPSP xml check value $activatePaymentNoticeV2.idPSP in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value $activatePaymentNoticeV2.idBrokerPSP in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value $activatePaymentNoticeV2.idChannel in position 0
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
        And from $sendPaymentOutcomeReq.idPSP xml check value $sendPaymentOutcome.idPSP in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value $sendPaymentOutcome.idBrokerPSP in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value $sendPaymentOutcome.idChannel in position 0
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


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_8 @after
    Scenario: NM3 flow OK, FLOW con PSP POSTE vp1 activate PSP POSTE vp2 spo: verificaBollettino -> paaVerificaRPT activate -> paaAttivaRPT  nodoInviaRPT spov2+ -> paaInviaRT+ (tramite job paInviaRT) nodoChiediStatoRPT nodoChiediCopiaRT BIZ+ BIZ+ (NM3-56)
        Given from body with datatable horizontal verificaBollettino_noOptional initial XML verificaBollettino
            | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 312#iuv#     |
        And from body with datatable vertical paaVerificaRPT_noOptional initial XML paaVerificaRPT
            | esito                    | OK                          |
            | importoSingoloVersamento | 10.00                       |
            | ibanAccredito            | IT45R0760103200000000001016 |
            | causaleVersamento        | pagamentoTest               |
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
        Then check outcome is OK of verificaBollettino response
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
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
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter VERSIONE_PRIMITIVE = '2', with where condition OBJ_ID = '14748' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                | outcome |
            | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        And job paInviaRt triggered after 3 seconds
        Then check outcome is OK of sendPaymentOutcomeV2 response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | password                              | #password#                                  |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_PARCHEGGIATA_NODO_MOD3 of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RISOLTA_OK of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | password                              | #password#                                  |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response
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
            | PSP_ID                     | $activatePaymentNotice.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNotice.idBrokerPSP          |
            | CHANNEL_ID                 | $activatePaymentNotice.idChannel            |
            | IDEMPOTENCY_KEY            | None                                        |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | NotNone                                     |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | NotNone                                     |
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
            | UPDATED_BY                 | sendPaymentOutcomeV2                        |
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
            | column                | value                                                                                             |
            | ID                    | NotNone                                                                                           |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                                 |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                               |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                                           |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                                       |
            | INSERTED_BY           | activatePaymentNotice,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcomeV2                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                                             |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                                   |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paInviaRt,paaInviaRT                         |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RT_ACCETTATA_PA                             |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | paInviaRt                                   |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
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
        And from $activatePaymentNoticeReq.idPSP xml check value $activatePaymentNotice.idPSP in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value $activatePaymentNotice.idBrokerPSP in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value $activatePaymentNotice.idChannel in position 0
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
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value $sendPaymentOutcomeV2.idPSP in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value $sendPaymentOutcomeV2.idBrokerPSP in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value $sendPaymentOutcomeV2.idChannel in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
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



    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_9
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT REQ  nodoInviaRPT  paaAttivaRPT RESP OK  spo+ -> paaInviaRT+ BIZ+ (NM3-12)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 2550  | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount   |
            | identificativoUnivocoVersamento   | 12$iuv                          |
            | codiceContestoPagamento           | paymentToken                    |
            | importoSingoloVersamento          | $activatePaymentNotice.amount   |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$iuv                          |
            | codiceContestoPagamento               | paymentToken                    |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | rptAttachment                   |
        Then saving activatePaymentNotice request in activatePaymentNotice
        And saving nodoInviaRPT request in nodoInviaRPT
        When calling primitive evolution activatePaymentNotice and nodoInviaRPT_$rpt with POST and POST in parallel with 2000 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check esito is OK of nodoInviaRPT response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # RE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                           |
            | TIPO_EVENTO | activatePaymentNotice,paaAttivaRPT,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys                | where_values                                            |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken             |
            | TIPO_EVENTO               | ('activatePaymentNotice','paaAttivaRPT','nodoInviaRPT') |
            | SOTTO_TIPO_EVENTO         | REQ                                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                                        |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                                     |
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
            | OUTCOME                    | NotNone                                     |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | NotNone                                     |
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
            | UPDATED_BY                 | sendPaymentOutcome                          |
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
            | column                | value                                                                          |
            | ID                    | NotNone                                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                              |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                            |
            | STATUS                | PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                                                        |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                    |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                                             |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                                   |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paaInviaRT                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
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
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO         | REQ                                         |
            | ESITO                     | RICEVUTA                                    |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
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
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO         | RESP                                        |
            | ESITO                     | INVIATA                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0



    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_10
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp2: activateV2 -> paaAttivaRPT REQ  nodoInviaRPT  paaAttivaRPT RESP OK  spoV2+ -> paaInviaRT+ BIZ+ (NM3-38)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 2400  | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNoticeV2.amount |
            | identificativoUnivocoVersamento   | 12$iuv                          |
            | codiceContestoPagamento           | paymentToken                    |
            | importoSingoloVersamento          | $activatePaymentNoticeV2.amount |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$iuv                          |
            | codiceContestoPagamento               | paymentToken                    |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | rptAttachment                   |
        Then saving activatePaymentNoticeV2 request in activatePaymentNoticeV2
        And saving nodoInviaRPT request in nodoInviaRPT
        When calling primitive evolution activatePaymentNoticeV2 and nodoInviaRPT_$rpt with POST and POST in parallel with 2000 ms delay
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check esito is OK of nodoInviaRPT response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # RE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                             |
            | TIPO_EVENTO | activatePaymentNoticeV2,paaAttivaRPT,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys                | where_values                                              |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeV2Response.paymentToken             |
            | TIPO_EVENTO               | ('activatePaymentNoticeV2','paaAttivaRPT','nodoInviaRPT') |
            | SOTTO_TIPO_EVENTO         | REQ                                                       |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                                          |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                                       |
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
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | NotNone                                       |
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
            | UPDATED_BY                 | sendPaymentOutcomeV2                          |
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
            | column                | value                                                                                  |
            | ID                    | NotNone                                                                                |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                    |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                                  |
            | STATUS                | PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                         |
            | INSERTED_TIMESTAMP    | NotNone                                                                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                 |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                          |
            | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | sendPaymentOutcomeV2                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                                           |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                                 |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paaInviaRT              |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
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
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                  |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO         | REQ                                           |
            | ESITO                     | RICEVUTA                                      |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                              |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                           |
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
            | where_keys                | where_values                                  |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO         | RESP                                          |
            | ESITO                     | INVIATA                                       |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                              |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_11
    Scenario: NM3 flow OK, FLOW con PA Old, PSP vp1 activate e PSP vp2 spo: activate -> paaAttivaRPT REQ  nodoInviaRPT  paaAttivaRPT RESP OK  spoV2+ -> paaInviaRT+ BIZ+ (NM3-61)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 2550  | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount   |
            | identificativoUnivocoVersamento   | 12$iuv                          |
            | codiceContestoPagamento           | paymentToken                    |
            | importoSingoloVersamento          | $activatePaymentNotice.amount   |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$iuv                          |
            | codiceContestoPagamento               | paymentToken                    |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | rptAttachment                   |
        Then saving activatePaymentNotice request in activatePaymentNotice
        And saving nodoInviaRPT request in nodoInviaRPT
        When calling primitive evolution activatePaymentNotice and nodoInviaRPT_$rpt with POST and POST in parallel with 2000 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check esito is OK of nodoInviaRPT response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        And wait 5 seconds for expiration
        # RE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                           |
            | TIPO_EVENTO | activatePaymentNotice,paaAttivaRPT,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys                | where_values                                            |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken             |
            | TIPO_EVENTO               | ('activatePaymentNotice','paaAttivaRPT','nodoInviaRPT') |
            | SOTTO_TIPO_EVENTO         | REQ                                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                                        |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                                     |
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
            | OUTCOME                    | NotNone                                     |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | NotNone                                     |
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
            | UPDATED_BY                 | sendPaymentOutcomeV2                        |
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
            | column                | value                                                                                |
            | ID                    | NotNone                                                                              |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                    |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                  |
            | STATUS                | PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                              |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                               |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                          |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcomeV2                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                                             |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                                   |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcomeV2,sendPaymentOutcomeV2,sendPaymentOutcomeV2,paaInviaRT              |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
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
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #intermediarioPSP2# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale32# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                        |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO         | REQ                                         |
            | ESITO                     | RICEVUTA                                    |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
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
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO         | RESP                                        |
            | ESITO                     | INVIATA                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGOK @NM3PAOLDPAGOK_12
    Scenario: NM3 flow OK, FLOW con PA Old, PSP vp2 activate e PSP vp1 spo: activateV2 -> paaAttivaRPT REQ  nodoInviaRPT  paaAttivaRPT RESP OK  spo+ -> paaInviaRT+ BIZ+ (NM3-78)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 2400  | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNoticeV2.amount |
            | identificativoUnivocoVersamento   | 12$iuv                          |
            | codiceContestoPagamento           | paymentToken                    |
            | importoSingoloVersamento          | $activatePaymentNoticeV2.amount |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$iuv                          |
            | codiceContestoPagamento               | paymentToken                    |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | rptAttachment                   |
        Then saving activatePaymentNoticeV2 request in activatePaymentNoticeV2
        And saving nodoInviaRPT request in nodoInviaRPT
        When calling primitive evolution activatePaymentNoticeV2 and nodoInviaRPT_$rpt with POST and POST in parallel with 2000 ms delay
        Then check outcome is OK of activatePaymentNoticeV2 response
        And check esito is OK of nodoInviaRPT response
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And wait 5 seconds for expiration
        # RE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                             |
            | TIPO_EVENTO | activatePaymentNoticeV2,paaAttivaRPT,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys                | where_values                                              |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeV2Response.paymentToken             |
            | TIPO_EVENTO               | ('activatePaymentNoticeV2','paaAttivaRPT','nodoInviaRPT') |
            | SOTTO_TIPO_EVENTO         | REQ                                                       |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                                          |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                                       |
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
            | OUTCOME                    | NotNone                                       |
            | PAYMENT_METHOD             | None                                          |
            | PAYMENT_CHANNEL            | NA                                            |
            | TRANSFER_DATE              | None                                          |
            | PAYER_ID                   | None                                          |
            | APPLICATION_DATE           | NotNone                                       |
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
            | UPDATED_BY                 | sendPaymentOutcome                            |
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
            | column                | value                                                                            |
            | ID                    | NotNone                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                              |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber                                            |
            | STATUS                | PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                   |
            | INSERTED_TIMESTAMP    | NotNone                                                                          |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                                    |
            | INSERTED_BY           | activatePaymentNoticeV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | NOTICE_STORED                                 |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | sendPaymentOutcome                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                         |
            | ID                    | NotNone                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNoticeV2.fiscalCode                                                                                           |
            | IUV                   | 12$iuv                                                                                                                        |
            | CCP                   | $activatePaymentNoticeV2Response.paymentToken                                                                                 |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paaInviaRT                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
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
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                  |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO         | REQ                                           |
            | ESITO                     | RICEVUTA                                      |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                              |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                           |
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
            | where_keys                | where_values                                  |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO               | nodoInviaRPT                                  |
            | SOTTO_TIPO_EVENTO         | RESP                                          |
            | ESITO                     | INVIATA                                       |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                              |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0




    @after
    Scenario: After restore
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'N', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter VERSIONE_PRIMITIVE = '1', with where condition OBJ_ID = '14748' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL