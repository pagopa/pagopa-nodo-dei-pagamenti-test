Feature: RT PULL flow

    Background:
        Given systems up



    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_4 @prova
    Scenario: RT pull, FLOW con PA Old e PSP Old, PSP che utilizza flag 'RT Push' e 'Recovery' disabilitati e che l'RT vada in esito sconosciuto PA.: nodoInviaRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+, BIZ+ (OLD_RTPull-25A)
        Given update parameter scheduler.jobName_paRetryPaInviaRtNegative.enabled on configuration keys with value false
        And waiting after triggered refresh job ALL
        And RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10             |
            | dataEsecuzionePagamento           | 2016-09-16                      |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | #ccp#                           |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | $ccp                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canaleRtPull_sec#              |
            | rpt                                   | $rptAttachment                  |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $iuv                            |
            | identificativoUnivocoRiscossione  | $iuv                            |
            | CodiceContestoPagamento           | $ccp                            |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio           | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code_old# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And from body with datatable horizontal paaInviaRT_Timeout_KO initial XML paaInviaRT
            | esito | delay |
            | OK    | 10000 |
        And EC replies to nodo-dei-pagamenti with the paaInviaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        When EC sends soap nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And wait 2 seconds for expiration
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
            | column | value                                                                                                                                             |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ESITO_SCONOSCIUTO_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                   |
            | STATO  | RT_ESITO_SCONOSCIUTO_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value              |
            | ID                  | NotNone            |
            | ID_SESSIONE         | NotNone            |
            | CCP                 | $ccp               |
            | COD_ESITO           | 0                  |
            | ESITO               | ESEGUITO           |
            | DATA_RICEVUTA       | NotNone            |
            | DATA_RICHIESTA      | NotNone            |
            | ID_RICEVUTA         | NotNone            |
            | ID_RICHIESTA        | NotNone            |
            | SOMMA_VERSAMENTI    | 10.00              |
            | INSERTED_TIMESTAMP  | NotNone            |
            | UPDATED_TIMESTAMP   | NotNone            |
            | ID_RICEVUTA         | NotNone            |
            | ID_RICHIESTA        | NotNone            |
            | CANALE              | #canaleRtPull_sec# |
            | NOTIFICA_PROCESSATA | N                  |
            | GENERATA_DA         | PSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RETRY_PA_INVIA_RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | ID_SESSIONE           | NotNone                         |
            | ID_STAZIONE           | #id_station_old#                |
            | ID_INTERMEDIARIO_PA   | #id_broker_old#                 |
            | ID_CANALE             | #canaleRtPull_sec#              |
            | ID_SESSIONE_ORIGINALE | NotNone                         |
            | ID_DOMINIO            | #creditor_institution_code_old# |
            | IUV                   | $iuv                            |
            | CCP                   | $ccp                            |
            | STATO                 | TO_RETRY                        |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | INSERTED_BY           | paInviaRt                       |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | RETRY                 | NotNone                         |
            | STATO_RPT             | RT_ESITO_SCONOSCIUTO_PA         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
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
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value #id_broker_old# in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
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
        # paaInviaRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | paaInviaRT          |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA_KO          |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value #id_broker_old# in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0