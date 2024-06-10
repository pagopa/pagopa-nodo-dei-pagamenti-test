Feature: NM3 flows PA Old con attivazione fallita

    Background:
        Given systems up


    @ALL @NM3 @NM3ATTFALLITA @NM3ATTFALLITAPAOLD @NM3ATTFALLITAPAOLD_1
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT timeout  resp KO a activate BIZ attivazione fallita nodoInviaRPT -> resp KO a RPT (NM3-15)
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_timeout initial XML paaAttivaRPT
            | delay |
            | 10000 |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of activatePaymentNotice response
        And check description is Timeout risposta dalla Stazione. of activatePaymentNotice response
        And execution query to get value result_query on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And through the query result_query retrieve param ccp at position 0 and save it under the key ccp
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount   |
            | identificativoUnivocoVersamento   | 12$iuv                          |
            | codiceContestoPagamento           | $ccp                            |
            | importoSingoloVersamento          | $activatePaymentNotice.amount   |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$iuv                          |
            | codiceContestoPagamento               | $ccp                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | $rptAttachment                  |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        # RPT_ACTIVATIONS
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values           |
            | PAYMENT_TOKEN | $ccp                   |
            | ORDER BY      | INSERTED_TIMESTAMP ASC |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                             |
            | ID                         | NotNone                           |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID      | 12$iuv                            |
            | PAYMENT_TOKEN              | $ccp                              |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode |
            | STATION_ID                 | #id_station_old#                  |
            | STATION_VERSION            | 1                                 |
            | PSP_ID                     | #pspFittizio#                     |
            | BROKER_PSP_ID              | #brokerFittizio#                  |
            | CHANNEL_ID                 | #canaleFittizio#                  |
            | IDEMPOTENCY_KEY            | None                              |
            | AMOUNT                     | $activatePaymentNotice.amount     |
            | FEE                        | None                              |
            | OUTCOME                    | None                              |
            | PAYMENT_METHOD             | None                              |
            | PAYMENT_CHANNEL            | NA                                |
            | TRANSFER_DATE              | None                              |
            | PAYER_ID                   | None                              |
            | APPLICATION_DATE           | None                              |
            | INSERTED_TIMESTAMP         | NotNone                           |
            | UPDATED_TIMESTAMP          | NotNone                           |
            | FK_PAYMENT_PLAN            | NotNone                           |
            | RPT_ID                     | NotNone                           |
            | PAYMENT_TYPE               | MOD3                              |
            | CARRELLO_ID                | None                              |
            | ORIGINAL_PAYMENT_TOKEN     | None                              |
            | FLAG_IO                    | N                                 |
            | RICEVUTA_PM                | None                              |
            | FLAG_ACTIVATE_RESP_MISSING | Y                                 |
            | FLAG_PAYPAL                | None                              |
            | INSERTED_BY                | nodoInviaRPT                      |
            | UPDATED_BY                 | nodoInviaRPT                      |
            | TRANSACTION_ID             | None                              |
            | CLOSE_VERSION              | None                              |
            | FEE_PA                     | None                              |
            | BUNDLE_ID                  | None                              |
            | BUNDLE_PA_ID               | None                              |
            | PM_INFO                    | None                              |
            | MBD                        | N                                 |
            | FEE_SPO                    | None                              |
            | PAYMENT_NOTE               | None                              |
            | FLAG_STANDIN               | None                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                               |
            | ID                    | NotNone                             |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber |
            | STATUS                | PAYING_RPT,CANCELLED                |
            | INSERTED_TIMESTAMP    | NotNone                             |
            | CREDITOR_REFERENCE_ID | 12$iuv                              |
            | PAYMENT_TOKEN         | $ccp                                |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | ID ASC                              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                               |
            | ID                    | NotNone                             |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber |
            | CREDITOR_REFERENCE_ID | 12$iuv                              |
            | PAYMENT_TOKEN         | $ccp                                |
            | STATUS                | CANCELLED                           |
            | INSERTED_TIMESTAMP    | NotNone                             |
            | UPDATED_TIMESTAMP     | NotNone                             |
            | FK_POSITION_PAYMENT   | NotNone                             |
            | INSERTED_BY           | nodoInviaRPT                        |
            | UPDATED_BY            | nodoInviaRPT                        |
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
            | column                | value                                                                            |
            | ID                    | NotNone                                                                          |
            | ID_SESSIONE           | NotNone                                                                          |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                          |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                |
            | IUV                   | 12$iuv                                                                           |
            | CCP                   | $ccp                                                                             |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT                              |
            | INSERTED_TIMESTAMP    | NotNone                                                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 4 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                             |
            | ID_SESSIONE        | NotNone                           |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode |
            | IUV                | 12$iuv                            |
            | CCP                | $ccp                              |
            | STATO              | RT_GENERATA_NODO                  |
            | INSERTED_BY        | nodoInviaRPT                      |
            | UPDATED_BY         | nodoInviaRPT                      |
            | INSERTED_TIMESTAMP | NotNone                           |
            | UPDATED_TIMESTAMP  | NotNone                           |
            | PUSH               | None                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                      | value                             |
            | ID_SESSIONE                 | NotNone                           |
            | IDENT_DOMINIO               | $activatePaymentNotice.fiscalCode |
            | IUV                         | 12$iuv                            |
            | CCP                         | $ccp                              |
            | BIC_ADDEBITO                | NotNone                           |
            | DATA_MSG_RICH               | NotNone                           |
            | FLAG_CANC                   | N                                 |
            | IBAN_ADDEBITO               | NotNone                           |
            | ID_MSG_RICH                 | NotNone                           |
            | STAZ_INTERMEDIARIOPA        | #id_station_old#                  |
            | INTERMEDIARIOPA             | #id_broker_old#                   |
            | CANALE                      | #canaleFittizio#                  |
            | PSP                         | #pspFittizio#                     |
            | INTERMEDIARIOPSP            | #brokerFittizio#                  |
            | TIPO_VERSAMENTO             | PO                                |
            | NUM_VERSAMENTI              | 1                                 |
            | RT_SIGNATURE_CODE           | 0                                 |
            | SOMMA_VERSAMENTI            | 10                                |
            | PARAMETRI_PROFILO_PAGAMENTO | None                              |
            | FK_CARRELLO                 | None                              |
            | INSERTED_TIMESTAMP          | NotNone                           |
            | UPDATED_TIMESTAMP           | NotNone                           |
            | RICEVUTA_PM                 | N                                 |
            | WISP_2                      | N                                 |
            | FLAG_SECONDA                | None                              |
            | FLAG_IO                     | N                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                      |
            | IUV           | 12$iuv                            |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode |
            | CCP           | $ccp                              |
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                      |
            | IUV           | 12$iuv                            |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode |
            | CCP           | $ccp                              |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                             |
            | ID_SESSIONE         | NotNone                           |
            | IDENT_DOMINIO       | $activatePaymentNotice.fiscalCode |
            | IUV                 | 12$iuv                            |
            | CCP                 | $ccp                              |
            | COD_ESITO           | 1                                 |
            | ESITO               | NON_ESEGUITO                      |
            | DATA_RICEVUTA       | NotNone                           |
            | DATA_RICHIESTA      | NotNone                           |
            | ID_RICEVUTA         | NotNone                           |
            | ID_RICHIESTA        | NotNone                           |
            | SOMMA_VERSAMENTI    | 0                                 |
            | INSERTED_TIMESTAMP  | NotNone                           |
            | UPDATED_TIMESTAMP   | NotNone                           |
            | CANALE              | #canaleFittizio#                  |
            | NOTIFICA_PROCESSATA | N                                 |
            | GENERATA_DA         | NMP                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                      |
            | IUV           | 12$iuv                            |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode |
            | CCP           | $ccp                              |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                      |
            | IUV           | 12$iuv                            |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode |
            | CCP           | $ccp                              |

        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values          |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                  |
            | TIPO_EVENTO               | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO         | REQ                   |
            | ESITO                     | RICEVUTA              |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)      |
            | ORDER BY                  | DATA_ORA_EVENTO ASC   |
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
            | where_keys                | where_values          |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                  |
            | TIPO_EVENTO               | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO         | RESP                  |
            | ESITO                     | INVIATA               |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)      |
            | ORDER BY                  | DATA_ORA_EVENTO ASC   |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value KO in position 0
        And from $activatePaymentNoticeResp.fault.faultCode xml check value PPT_STAZIONE_INT_PA_TIMEOUT in position 0
        And from $activatePaymentNoticeResp.fault.faultString xml check value Timeout risposta dalla Stazione. in position 0
        And from $activatePaymentNoticeResp.fault.id xml check value NodoDeiPagamentiSPC in position 0
        And from $activatePaymentNoticeResp.fault.description xml check value Timeout risposta dalla Stazione. in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaAttivaRPT        |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA_KO          |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
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
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleFittizio# in position 0
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



    @ALL @NM3 @NM3ATTFALLITA @NM3ATTFALLITAPAOLD @NM3ATTFALLITAPAOLD_2
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1: activate -> paaAttivaRPT KO  resp KO a activate BIZ attivazione fallita nodoInviaRPT -> resp KO a RPT (NM3-16)
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_KO initial XML paaAttivaRPT
            | faultCode              | faultString         | id                          | description                            | esito |
            | PAA_SEMANTICA_EXTRAXSD | errore semantico PA | #creditor_institution_code# | Errore semantico emesso dalla PA esito | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And execution query to get value result_query on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        And through the query result_query retrieve param ccp at position 0 and save it under the key ccp
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount   |
            | identificativoUnivocoVersamento   | 12$iuv                          |
            | codiceContestoPagamento           | $ccp                            |
            | importoSingoloVersamento          | $activatePaymentNotice.amount   |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$iuv                          |
            | codiceContestoPagamento               | $ccp                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | $rptAttachment                  |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
        And check description is RPT non attivata of nodoInviaRPT response
        # RPT_ACTIVATIONS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID | 12$iuv                            |
            | PAYMENT_TOKEN         | $ccp                              |
            | PAAATTIVARPTRESP      | Y                                 |
            | NODOINVIARPTREQ       | N                                 |
            | PAAATTIVARPTERROR     | N                                 |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | INSERTED_BY           | activatePaymentNotice             |
            | UPDATED_BY            | activatePaymentNotice             |
            | RETRY_PENDING         | N                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                      |
            | PAYMENT_TOKEN  | $ccp                              |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode |
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values           |
            | PAYMENT_TOKEN | $ccp                   |
            | ORDER BY      | INSERTED_TIMESTAMP ASC |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                             |
            | ID                         | NotNone                           |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode |
            | CREDITOR_REFERENCE_ID      | 12$iuv                            |
            | PAYMENT_TOKEN              | $ccp                              |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode |
            | STATION_ID                 | #id_station_old#                  |
            | STATION_VERSION            | 1                                 |
            | PSP_ID                     | #pspFittizio#                     |
            | BROKER_PSP_ID              | #brokerFittizio#                  |
            | CHANNEL_ID                 | #canaleFittizio#                  |
            | IDEMPOTENCY_KEY            | None                              |
            | AMOUNT                     | $activatePaymentNotice.amount     |
            | FEE                        | None                              |
            | OUTCOME                    | None                              |
            | PAYMENT_METHOD             | None                              |
            | PAYMENT_CHANNEL            | NA                                |
            | TRANSFER_DATE              | None                              |
            | PAYER_ID                   | None                              |
            | APPLICATION_DATE           | None                              |
            | INSERTED_TIMESTAMP         | NotNone                           |
            | UPDATED_TIMESTAMP          | NotNone                           |
            | FK_PAYMENT_PLAN            | NotNone                           |
            | RPT_ID                     | NotNone                           |
            | PAYMENT_TYPE               | MOD3                              |
            | CARRELLO_ID                | None                              |
            | ORIGINAL_PAYMENT_TOKEN     | None                              |
            | FLAG_IO                    | N                                 |
            | RICEVUTA_PM                | None                              |
            | FLAG_ACTIVATE_RESP_MISSING | Y                                 |
            | FLAG_PAYPAL                | None                              |
            | INSERTED_BY                | nodoInviaRPT                      |
            | UPDATED_BY                 | nodoInviaRPT                      |
            | TRANSACTION_ID             | None                              |
            | CLOSE_VERSION              | None                              |
            | FEE_PA                     | None                              |
            | BUNDLE_ID                  | None                              |
            | BUNDLE_PA_ID               | None                              |
            | PM_INFO                    | None                              |
            | MBD                        | N                                 |
            | FEE_SPO                    | None                              |
            | PAYMENT_NOTE               | None                              |
            | FLAG_STANDIN               | None                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS
        And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                |
            | ID                    | NotNone                              |
            | ID_SESSIONE           | NotNone                              |
            | ID_SESSIONE_ORIGINALE | NotNone                              |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode    |
            | IUV                   | 12$iuv                               |
            | CCP                   | $ccp                                 |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_RIFIUTATA_NODO |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT            |
            | INSERTED_TIMESTAMP    | NotNone                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 2 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RPT
        And verify 0 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                      |
            | IUV           | 12$iuv                            |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode |
            | CCP           | $ccp                              |
        # RT
        And verify 0 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                      |
            | IUV           | 12$iuv                            |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode |
            | CCP           | $ccp                              |

        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values          |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                  |
            | TIPO_EVENTO               | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO         | REQ                   |
            | ESITO                     | RICEVUTA              |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)      |
            | ORDER BY                  | DATA_ORA_EVENTO ASC   |
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
            | where_keys                | where_values          |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                  |
            | TIPO_EVENTO               | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO         | RESP                  |
            | ESITO                     | INVIATA               |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)      |
            | ORDER BY                  | DATA_ORA_EVENTO ASC   |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value KO in position 0
        And from $activatePaymentNoticeResp.fault.faultCode xml check value PPT_ERRORE_EMESSO_DA_PAA in position 0
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
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
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
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleFittizio# in position 0
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
        And from $nodoInviaRPTResp.fault.faultCode xml check value PPT_SEMANTICA in position 0
        And from $nodoInviaRPTResp.fault.description xml check value RPT non attivata in position 0
        And from $nodoInviaRPTResp.esito xml check value KO in position 0