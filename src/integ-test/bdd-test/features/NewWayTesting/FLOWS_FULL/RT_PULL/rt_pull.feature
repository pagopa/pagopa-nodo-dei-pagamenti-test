Feature: RT PULL flow

    Background:
        Given systems up



    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_1
    Scenario: RT pull, FLOW con PA Old e PSP Old, PSP che utilizza le primitive Mod4 a vecchio e RT Pull: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, nodoInviaRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+, BIZ+ (OLD_RTPull-4A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio           |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | idServizio | idDominioErogatoreServizio      |
            | #psp#             | #id_broker_psp#                | #canaleRtPull_sec#   | #password# | 00010      | #creditor_institution_code_old# |
        And from body with datatable vertical paaChiediNumeroAvviso_full initial XML paaChiediNumeroAvviso
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
        Given from body with datatable vertical nodoAttivaRPT_full initial XML nodoAttivaRPT
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
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
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
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
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
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio           | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code_old# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
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
        And wait 1 seconds for expiration
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