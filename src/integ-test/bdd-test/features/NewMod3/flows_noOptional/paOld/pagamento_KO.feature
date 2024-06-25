Feature: NM3 flows PA Old con pagamento KO

    Background:
        Given systems up


    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGKO @NM3PAOLDPAGKO_1 @after_3
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT nodoInviaRPT spo- -> paaInviaRT- BIZ- (NM3-7)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
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
            | COMPANY_NAME       | NotNone               |
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
            | CREDITOR_REFERENCE_ID | 12$iuv                        |
            | DUE_DATE              | NotNone                       |
            | RETENTION_DATE        | None                          |
            | AMOUNT                | $activatePaymentNotice.amount |
            | FLAG_FINAL_PAYMENT    | Y                             |
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
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                             |
            | ID                       | NotNone                           |
            | CREDITOR_REFERENCE_ID    | 12$iuv                            |
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
            | UPDATED_BY               | sendPaymentOutcome                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
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
            | column                | value                                                 |
            | ID                    | NotNone                                               |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                     |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                   |
            | STATUS                | PAYING,PAYING_RPT,FAILED                              |
            | INSERTED_TIMESTAMP    | NotNone                                               |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken           |
            | INSERTED_BY           | activatePaymentNotice,nodoInviaRPT,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
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
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_KO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
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



    @ALL @NM3 @NM3PAOLD @NM3PAOLDPAGKO @NM3PAOLDPAGKO_2 @after_3
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT  spo-  nodoInviaRPT -> paaInviaRT- BIZ- (NM3-8)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
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
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
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
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
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
            | COMPANY_NAME       | NotNone               |
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
            | CREDITOR_REFERENCE_ID | 12$iuv                        |
            | DUE_DATE              | NotNone                       |
            | RETENTION_DATE        | None                          |
            | AMOUNT                | $activatePaymentNotice.amount |
            | FLAG_FINAL_PAYMENT    | Y                             |
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
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                             |
            | ID                       | NotNone                           |
            | CREDITOR_REFERENCE_ID    | 12$iuv                            |
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
            | UPDATED_BY               | nodoInviaRPT                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
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
            | column                | value                                                 |
            | ID                    | NotNone                                               |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                     |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                   |
            | STATUS                | PAYING,FAILED_NORPT,FAILED                            |
            | INSERTED_TIMESTAMP    | NotNone                                               |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken           |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome,nodoInviaRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
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
            | STATUS                | FAILED                                      |
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
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_KO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
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





    @after1
    Scenario: After restore
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'N', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter VERSIONE_PRIMITIVE = '1', with where condition OBJ_ID = '14748' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL


    @after2
    Scenario: After restore
        Given generic update through the query param_update_generic_where_condition of the table CANALI_NODO the parameter VERSIONE_PRIMITIVE = '1', with where condition OBJ_ID = '14748' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL


    @after3
    Scenario: After restore
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'N', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL