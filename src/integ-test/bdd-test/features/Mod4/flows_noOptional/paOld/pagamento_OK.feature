Feature: NM4 e MOD4 flows con PA OLD pagamento OK


    Background:
        Given systems up


    @ALL @NM4 @NM4PAOLD @NM4PAOLDPAGOK @NM4PAOLDPAGOK_1 @after_1
    Scenario: NM4 flow OK, FLOW con PA Old e PSP New: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, activatePaymentNotice -> paaAttivaRPT, nodoInviaRPT, spo+ -> paaInviaRT+, BIZ+ (NM4-3)
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter QUARTO_MODELLO = 'Y', with where condition OBJ_ID = '16643' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL
        And from body with datatable horizontal nodoChiediCatalogoServizi_noOptional initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso_noOptional initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio      |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00010      | #creditor_institution_code_old# |
        And from body with datatable vertical paaChiediNumeroAvviso_noOptional initial XML paaChiediNumeroAvviso
            | esito                    | OK                                                                                                               |
            | auxDigit                 | 0                                                                                                                |
            | applicationCode          | 00                                                                                                               |
            | IUV                      | #iuv#                                                                                                            |
            | importoSingoloVersamento | 10.00                                                                                                            |
            | ibanAccredito            | IT45R0760103200000000001016                                                                                      |
            | causaleVersamento        | prova/RFDB/$nodoChiediNumeroAvviso.idDominioErogatoreServizio/TESTO/$nodoChiediNumeroAvviso.identificativoCanale |
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When psp sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is OK of nodoChiediNumeroAvviso response
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10                         |
            | dataEsecuzionePagamento           | 2016-09-16                                  |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code#                 |
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
        And wait 5 seconds for expiration
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                        |
            | CANALE           | $nodoInviaRPT.identificativoCanale           |
            | PSP              | $nodoInviaRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | PO                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
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
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
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
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
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
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $nodoInviaRPT.identificativoDominio         |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
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
            | RPT_ID                     | NotNone                                     |
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
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 12$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $nodoInviaRPT.identificativoDominio |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNotice.amount       |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNotice               |
            | UPDATED_BY               | sendPaymentOutcome                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                 |
            | ID                    | NotNone                                               |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken           |
            | STATUS                | PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED |
            | INSERTED_TIMESTAMP    | NotNone                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | NOTICE_STORED                               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
            | ORDER BY       | ID ASC                              |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                     |
            | ID                 | NotNone                   |
            | STATUS             | PAYING,PAID,NOTICE_STORED |
            | INSERTED_TIMESTAMP | NotNone                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
            | ORDER BY       | ID ASC                              |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value         |
            | ID                  | NotNone       |
            | STATUS              | NOTICE_STORED |
            | INSERTED_TIMESTAMP  | NotNone       |
            | UPDATED_TIMESTAMP   | NotNone       |
            | FK_POSITION_SERVICE | NotNone       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $nodoInviaRPT.identificativoDominio |
            | ORDER BY       | ID ASC                              |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                |
            | ID_SESSIONE | $activatePaymentNoticeResponse.paymentToken |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                         |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
        And verify 7 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO         | REQ                                         |
            | ESITO                     | RICEVUTA                                    |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
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
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO         | RESP                                        |
            | ESITO                     | INVIATA                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.paymentDescription xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 1
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO         | REQ                                         |
            | ESITO                     | INVIATA                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaRPT.identificativoIntermediarioPSP in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value $nodoInviaRPT.identificativoCanale in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO         | RESP                                        |
            | ESITO                     | RICEVUTA                                    |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
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
        And from $nodoInviaRPTReq.identificativoPSP xml check value $nodoInviaRPT.identificativoPSP in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value $nodoInviaRPT.identificativoCanale in position 0
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
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO         | REQ                                         |
            | ESITO                     | RICEVUTA                                    |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO         | RESP                                        |
            | ESITO                     | INVIATA                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | paaInviaRT                                  |
            | SOTTO_TIPO_EVENTO         | REQ                                         |
            | ESITO                     | INVIATA                                     |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0
        # paaInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values                                |
            | CODICE_CONTESTO_PAGAMENTO | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO               | paaInviaRT                                  |
            | SOTTO_TIPO_EVENTO         | RESP                                        |
            | ESITO                     | RICEVUTA                                    |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)                            |
            | ORDER BY                  | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0









    @ALL @NM4 @NM4PAOLD @NM4PAOLDPAGOK @NM4PAOLDPAGOK_2
    Scenario: NM4 flow OK, FLOW con PA Old e PSP Old, PSP che utilizza le primitive Mod4 a vecchio e RT Push: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, nodoInviaRPT, nodoInviaRT+ -> paaInviaRT+, BIZ+ (NM4-1)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_noOptional initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso_noOptional initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | idServizio | idDominioErogatoreServizio      |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00010      | #creditor_institution_code_old# |
        And from body with datatable vertical paaChiediNumeroAvviso_noOptional initial XML paaChiediNumeroAvviso
            | esito                    | OK                                                                                                               |
            | auxDigit                 | 0                                                                                                                |
            | applicationCode          | 00                                                                                                               |
            | IUV                      | #iuv#                                                                                                            |
            | importoSingoloVersamento | 10.00                                                                                                            |
            | ibanAccredito            | IT45R0760103200000000001016                                                                                      |
            | causaleVersamento        | prova/RFDB/$nodoChiediNumeroAvviso.idDominioErogatoreServizio/TESTO/$nodoChiediNumeroAvviso.identificativoCanale |
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends soap nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is OK of nodoChiediNumeroAvviso response
        Given from body with datatable vertical nodoAttivaRPT_noOptional initial XML nodoAttivaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #id_broker_psp#              |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | password                       | #password#                   |
            | codiceContestoPagamento        | #ccp#                        |
            | idIntermediarioPSPPagamento    | #id_broker_psp#              |
            | idCanalePagamento              | #canale_ATTIVATO_PRESSO_PSP# |
            | codificaInfrastrutturaPSP      | BARCODE-128-AIM              |
            | CCPost                         | #ccPoste#                    |
            | CodStazPA                      | 02                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | $iuv                         |
            | importoSingoloVersamento       | 10.00                        |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#         |
            | identificativoStazioneRichiedente | #id_station_old#                        |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10                     |
            | dataEsecuzionePagamento           | 2016-09-16                              |
            | importoTotaleDaVersare            | $nodoAttivaRPT.importoSingoloVersamento |
            | identificativoUnivocoVersamento   | $iuv                                    |
            | codiceContestoPagamento           | $ccp                                    |
            | importoSingoloVersamento          | $nodoAttivaRPT.importoSingoloVersamento |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#              |
            | identificativoStazioneIntermediarioPA | #id_station_old#             |
            | identificativoDominio                 | #creditor_institution_code#  |
            | identificativoUnivocoVersamento       | $iuv                         |
            | codiceContestoPagamento               | $ccp                         |
            | password                              | #password#                   |
            | identificativoPSP                     | #psp#                        |
            | identificativoIntermediarioPSP        | #id_broker_psp#              |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP# |
            | rpt                                   | $rptAttachment               |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given RT generation RT_generation with datatable vertical
            | identificativoDominio             | $nodoChiediNumeroAvviso.idDominioErogatoreServizio |
            | identificativoStazioneRichiedente | #id_station_old#                                   |
            | dataOraMessaggioRicevuta          | #timedate#                                         |
            | importoTotalePagato               | $nodoAttivaRPT.importoSingoloVersamento            |
            | identificativoUnivocoVersamento   | $iuv                                               |
            | identificativoUnivocoRiscossione  | $iuv                                               |
            | CodiceContestoPagamento           | $ccp                                               |
            | codiceEsitoPagamento              | 0                                                  |
            | singoloImportoPagato              | $nodoAttivaRPT.importoSingoloVersamento            |
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoDominio           | $nodoChiediNumeroAvviso.idDominioErogatoreServizio |
            | identificativoUnivocoVersamento | $iuv                                               |
            | codiceContestoPagamento         | $ccp                                               |
            | password                        | #password#                                         |
            | identificativoPSP               | #psp#                                              |
            | identificativoIntermediarioPSP  | #id_broker_psp#                                    |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#                       |
            | rt                              | $rtAttachment                                      |
            | forzaControlloSegno             | 1                                                  |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And wait 5 seconds for expiration
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                        |
            | CANALE           | $nodoInviaRPT.identificativoCanale           |
            | PSP              | $nodoInviaRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | PO                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                   |
            | ID                  | NotNone                                 |
            | ID_SESSIONE         | NotNone                                 |
            | CCP                 | $ccp                                    |
            | COD_ESITO           | 0                                       |
            | ESITO               | ESEGUITO                                |
            | DATA_RICEVUTA       | NotNone                                 |
            | DATA_RICHIESTA      | NotNone                                 |
            | ID_RICEVUTA         | NotNone                                 |
            | ID_RICHIESTA        | NotNone                                 |
            | SOMMA_VERSAMENTI    | $nodoAttivaRPT.importoSingoloVersamento |
            | INSERTED_TIMESTAMP  | NotNone                                 |
            | UPDATED_TIMESTAMP   | NotNone                                 |
            | ID_RICEVUTA         | NotNone                                 |
            | ID_RICHIESTA        | NotNone                                 |
            | CANALE              | #canale_ATTIVATO_PRESSO_PSP#            |
            | NOTIFICA_PROCESSATA | N                                       |
            | GENERATA_DA         | PSP                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RE #####
        # nodoAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoAttivaRPT       |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoAttivaRPTReq
        And from $nodoAttivaRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $nodoAttivaRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $nodoAttivaRPTReq.identificativoCanale xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $nodoAttivaRPTReq.password xml check value #password# in position 0
        And from $nodoAttivaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoAttivaRPTReq.identificativoIntermediarioPSPPagamento xml check value #psp# in position 0
        And from $nodoAttivaRPTReq.identificativoCanalePagamento xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.CCPost xml check value #ccPoste# in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.CodStazPA xml check value 02 in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.AuxDigit xml check value 0 in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.CodIUV xml check value $iuv in position 0
        And from $nodoAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        # nodoAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoAttivaRPT       |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoAttivaRPTResp
        And from $nodoAttivaRPTResp.esito xml check value OK in position 0
        And from $nodoAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $nodoAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
        And from $nodoAttivaRPTResp.datiPagamentoPA.causaleVersamento xml check value NotNone in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaAttivaRPT        |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaRPT.identificativoIntermediarioPSP in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value $nodoInviaRPT.identificativoCanale in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaAttivaRPT        |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoInviaRPT        |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value $nodoInviaRPT.identificativoPSP in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value $nodoInviaRPT.identificativoCanale in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoInviaRPT        |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0
        # pspInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaRPT         |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaRPTReq
        And from $pspInviaRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaRPTReq.identificativoCanale xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $pspInviaRPTReq.modelloPagamento xml check value 4 in position 0
        And from $pspInviaRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaRPTReq.elementoListaRPT.codiceContestoPagamento xml check value $ccp in position 0
        And from $pspInviaRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaRPT         |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaRPTResp
        And from $pspInviaRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
        # nodoInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoInviaRT         |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRTReq
        And from $nodoInviaRTReq.identificativoIntermediarioPSP xml check value #psp# in position 0
        And from $nodoInviaRTReq.identificativoCanale xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $nodoInviaRTReq.password xml check value #password# in position 0
        And from $nodoInviaRTReq.identificativoPSP xml check value #id_broker_psp# in position 0
        And from $nodoInviaRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRTReq.forzaControlloSegno xml check value 1 in position 0
        And from $nodoInviaRTReq.rt xml check value NotNone in position 0
        # nodoInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoInviaRT         |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRTResp
        And from $nodoInviaRTResp.esito xml check value OK in position 0
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaInviaRT          |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0
        # paaInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaInviaRT          |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0





    @ALL @NM4 @NM4PAOLD @NM4PAOLDPAGOK @NM4PAOLDPAGOK_3
    Scenario: NM4 flow OK, FLOW con PA Old e PSP Old, PSP che utilizza le primitive Mod4 a vecchio e RT Pull: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, nodoInviaRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+, BIZ+ (NM4-2)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_noOptional initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #id_broker_psp#                | #canaleRtPull_sec#   | #password# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso_noOptional initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | idServizio | idDominioErogatoreServizio      |
            | #psp#             | #id_broker_psp#                | #canaleRtPull_sec#   | #password# | 00010      | #creditor_institution_code_old# |
        And from body with datatable vertical paaChiediNumeroAvviso_noOptional initial XML paaChiediNumeroAvviso
            | esito                    | OK                                                                                                               |
            | auxDigit                 | 0                                                                                                                |
            | applicationCode          | 00                                                                                                               |
            | IUV                      | #iuv#                                                                                                            |
            | importoSingoloVersamento | 10.00                                                                                                            |
            | ibanAccredito            | IT45R0760103200000000001016                                                                                      |
            | causaleVersamento        | prova/RFDB/$nodoChiediNumeroAvviso.idDominioErogatoreServizio/TESTO/$nodoChiediNumeroAvviso.identificativoCanale |
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends soap nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is OK of nodoChiediNumeroAvviso response
        Given from body with datatable vertical nodoAttivaRPT_noOptional initial XML nodoAttivaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #id_broker_psp#              |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | password                       | #password#                   |
            | codiceContestoPagamento        | #ccp#                        |
            | idIntermediarioPSPPagamento    | #id_broker_psp#              |
            | idCanalePagamento              | #canale_ATTIVATO_PRESSO_PSP# |
            | codificaInfrastrutturaPSP      | BARCODE-128-AIM              |
            | CCPost                         | #ccPoste#                    |
            | CodStazPA                      | 02                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | $iuv                         |
            | importoSingoloVersamento       | 10.00                        |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#         |
            | identificativoStazioneRichiedente | #id_station_old#                        |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10                     |
            | dataEsecuzionePagamento           | 2016-09-16                              |
            | importoTotaleDaVersare            | $nodoAttivaRPT.importoSingoloVersamento |
            | identificativoUnivocoVersamento   | $iuv                                    |
            | codiceContestoPagamento           | $ccp                                    |
            | importoSingoloVersamento          | $nodoAttivaRPT.importoSingoloVersamento |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#             |
            | identificativoStazioneIntermediarioPA | #id_station_old#            |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | $ccp                        |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #id_broker_psp#             |
            | identificativoCanale                  | #canaleRtPull_sec#          |
            | rpt                                   | $rptAttachment              |
        Given RT generation RT_generation with datatable vertical
            | identificativoDominio             | $nodoChiediNumeroAvviso.idDominioErogatoreServizio |
            | identificativoStazioneRichiedente | #id_station_old#                                   |
            | dataOraMessaggioRicevuta          | #timedate#                                         |
            | importoTotalePagato               | $nodoAttivaRPT.importoSingoloVersamento            |
            | identificativoUnivocoVersamento   | $iuv                                               |
            | identificativoUnivocoRiscossione  | $iuv                                               |
            | CodiceContestoPagamento           | $ccp                                               |
            | codiceEsitoPagamento              | 0                                                  |
            | singoloImportoPagato              | $nodoAttivaRPT.importoSingoloVersamento            |
        And from body with datatable horizontal pspInviaRPT_noOptional initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And from body with datatable horizontal pspChiediListaRT_noOptional initial XML pspChiediListaRT
            | identificativoDominio           | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code_old# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT_noOptional initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 5 seconds for expiration
        When EC sends soap nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        And job paInviaRt triggered after 10 seconds
        And wait 5 seconds for expiration
        Then check esito is OK of nodoInviaRPT response
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                        |
            | CANALE           | $nodoInviaRPT.identificativoCanale           |
            | PSP              | $nodoInviaRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | PO                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                   |
            | ID                  | NotNone                                 |
            | ID_SESSIONE         | NotNone                                 |
            | CCP                 | $ccp                                    |
            | COD_ESITO           | 0                                       |
            | ESITO               | ESEGUITO                                |
            | DATA_RICEVUTA       | NotNone                                 |
            | DATA_RICHIESTA      | NotNone                                 |
            | ID_RICEVUTA         | NotNone                                 |
            | ID_RICHIESTA        | NotNone                                 |
            | SOMMA_VERSAMENTI    | $nodoAttivaRPT.importoSingoloVersamento |
            | INSERTED_TIMESTAMP  | NotNone                                 |
            | UPDATED_TIMESTAMP   | NotNone                                 |
            | ID_RICEVUTA         | NotNone                                 |
            | ID_RICHIESTA        | NotNone                                 |
            | CANALE              | #canaleRtPull_sec#                      |
            | NOTIFICA_PROCESSATA | N                                       |
            | GENERATA_DA         | PSP                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RE #####
        # nodoAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoAttivaRPT       |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoAttivaRPTReq
        And from $nodoAttivaRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $nodoAttivaRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $nodoAttivaRPTReq.identificativoCanale xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $nodoAttivaRPTReq.password xml check value #password# in position 0
        And from $nodoAttivaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoAttivaRPTReq.identificativoIntermediarioPSPPagamento xml check value #psp# in position 0
        And from $nodoAttivaRPTReq.identificativoCanalePagamento xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.CCPost xml check value #ccPoste# in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.CodStazPA xml check value 02 in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.AuxDigit xml check value 0 in position 0
        And from $nodoAttivaRPTReq.codiceIdRPT.aim128.CodIUV xml check value $iuv in position 0
        And from $nodoAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        # nodoAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoAttivaRPT       |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoAttivaRPTResp
        And from $nodoAttivaRPTResp.esito xml check value OK in position 0
        And from $nodoAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $nodoAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
        And from $nodoAttivaRPTResp.datiPagamentoPA.causaleVersamento xml check value NotNone in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaAttivaRPT        |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaRPT.identificativoIntermediarioPSP in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value $nodoAttivaRPT.identificativoCanale in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaAttivaRPT        |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value IT45R0760103200000000001016 in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoInviaRPT        |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value $nodoInviaRPT.identificativoPSP in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value $nodoInviaRPT.identificativoCanale in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | nodoInviaRPT        |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 1 in position 0
        # pspInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaRPT         |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaRPTReq
        And from $pspInviaRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaRPTReq.identificativoCanale xml check value #canaleRtPull_sec# in position 0
        And from $pspInviaRPTReq.modelloPagamento xml check value 1 in position 0
        And from $pspInviaRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaRPTReq.elementoListaRPT.codiceContestoPagamento xml check value $ccp in position 0
        And from $pspInviaRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaRPT         |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaRPTResp
        And from $pspInviaRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
        # pspChiediRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspChiediRT         |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspChiediRTReq
        And from $pspChiediRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspChiediRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspChiediRTReq.codiceContestoPagamento xml check value $ccp in position 0
        # pspChiediRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspChiediRT         |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspChiediRTResp
        And from $pspChiediRTResp.rt xml check value NotNone in position 0
        # pspInviaAckRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaAckRT       |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaAckRTReq
        And from $pspInviaAckRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaAckRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaAckRTReq.codiceContestoPagamento xml check value $ccp in position 0
        # pspInviaAckRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaAckRT       |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaAckRTResp
        And from $pspInviaAckRTResp.esito xml check value OK in position 0
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaInviaRT          |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0
        # paaInviaRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaInviaRT          |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0




    @after1
    Scenario: After restore
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'N', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter QUARTO_MODELLO = 'N', with where condition OBJ_ID = '16643' under macro update_query on db nodo_cfg
        And wait 3 seconds after triggered refresh job ALL