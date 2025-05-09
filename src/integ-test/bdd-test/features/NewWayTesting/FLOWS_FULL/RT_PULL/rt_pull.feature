Feature: RT PULL flow

    Background:
        Given systems up


    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_1
    Scenario: RT pull, FLOW con PA Old e PSP Old: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, RPT con IBAN, nodoInviaCarrelloRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+ (OLD_RTPull-4A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canaleRtPull_sec#   | #password# | 00010      | #creditor_institution_code# |
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
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10         |
            | dataEsecuzionePagamento           | 2016-09-16                  |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | codiceContestoPagamento           | $ccp                        |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station_old#            |
            | identificativoCarrello                | $ccp                        |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPull_sec#          |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | $ccp                        |
            | rpt                                   | $rptAttachment              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio       | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 1 seconds for expiration
        When EC sends soap nodoInviaCarrelloRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And wait 1 seconds for expiration
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                                |
            | CANALE           | $nodoInviaCarrelloRPT.identificativoCanale           |
            | PSP              | $nodoInviaCarrelloRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaCarrelloRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | PO                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                             |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
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
        # nodoInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                  |
            | ESITO              | RICEVUTA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReq
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaCarrelloRPTReq.password xml check value #password# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoCanale xml check value $nodoInviaCarrelloRPT.identificativoCanale in position 0
        And from $nodoInviaCarrelloRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                 |
            | ESITO              | INVIATA              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReqResp
        And from $nodoInviaCarrelloRPTReqResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $nodoInviaCarrelloRPTReqResp.url xml check value NotNone in position 0
        # pspInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTReq
        And from $pspInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoCanale xml check value #canaleRtPull_sec# in position 0
        And from $pspInviaCarrelloRPTReq.modelloPagamento xml check value 1 in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTResp
        And from $pspInviaCarrelloRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaCarrelloRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaCarrelloRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
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



    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_2
    Scenario: RT pull, FLOW con PA Old e PSP Old, PSP che utilizza flag 'RT Push' e 'Recovery' disabilitati e identificativoIntermediarioPA e identificativoStazioneIntermediarioPA irraggiungibili: nodoInviaRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, paaInviaRT+, BIZ+ (OLD_RTPull-29A)
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | irraggiungibile                 |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10             |
            | dataEsecuzionePagamento           | 2016-09-16                      |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | #ccp#                           |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | irraggiungibile                 |
            | identificativoStazioneIntermediarioPA | irraggiungibile                 |
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
            | identificativoStazioneRichiedente | irraggiungibile                 |
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
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 1 seconds for expiration
        When EC sends soap nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And wait 1 seconds for expiration
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
            | column | value                                                                                                                                          |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ERRORE_INVIO_A_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                |
            | STATO  | RT_ERRORE_INVIO_A_PA |
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
            | ID_STAZIONE           | irraggiungibile                 |
            | ID_INTERMEDIARIO_PA   | irraggiungibile                 |
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
            | STATO_RPT             | RT_ERRORE_INVIO_A_PA            |
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
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value irraggiungibile in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value irraggiungibile in position 0
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
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value irraggiungibile in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value irraggiungibile in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0




    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_3
    Scenario: RT pull, FLOW con PA Old e PSP Old: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, RPT con IBAN e MBD nodoInviaCarrelloRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+ (OLD_RTPull-5A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canaleRtPull_sec#   | #password# | 00010      | #creditor_institution_code# |
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
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | $iuv                                         |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT generation RPT_generation_with_IBAN_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10         |
            | dataEsecuzionePagamento           | 2016-09-16                  |
            | importoTotaleDaVersare            | 20.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | codiceContestoPagamento           | $ccp                        |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station_old#            |
            | identificativoCarrello                | $ccp                        |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPull_sec#          |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | $ccp                        |
            | rpt                                   | $rptAttachment              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And RT generation RT_generation_with_IBAN_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 20.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | testoAllegato                     | $bollo                      |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio       | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 1 seconds for expiration
        When EC sends soap nodoInviaCarrelloRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And wait 1 seconds for expiration
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                                |
            | CANALE           | $nodoInviaCarrelloRPT.identificativoCanale           |
            | PSP              | $nodoInviaCarrelloRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaCarrelloRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | BBT                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                             |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
            | SOMMA_VERSAMENTI    | 20.00              |
            | INSERTED_TIMESTAMP  | NotNone            |
            | UPDATED_TIMESTAMP   | NotNone            |
            | ID_RICEVUTA         | NotNone            |
            | ID_RICHIESTA        | NotNone            |
            | CANALE              | #canaleRtPull_sec# |
            | NOTIFICA_PROCESSATA | N                  |
            | GENERATA_DA         | PSP                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
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
        # nodoInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                  |
            | ESITO              | RICEVUTA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReq
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaCarrelloRPTReq.password xml check value #password# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoCanale xml check value $nodoInviaCarrelloRPT.identificativoCanale in position 0
        And from $nodoInviaCarrelloRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                 |
            | ESITO              | INVIATA              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReqResp
        And from $nodoInviaCarrelloRPTReqResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $nodoInviaCarrelloRPTReqResp.url xml check value NotNone in position 0
        # pspInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTReq
        And from $pspInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoCanale xml check value #canaleRtPull_sec# in position 0
        And from $pspInviaCarrelloRPTReq.modelloPagamento xml check value 1 in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTResp
        And from $pspInviaCarrelloRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaCarrelloRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaCarrelloRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
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







    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_4
    Scenario: RT pull, FLOW con PA Old e PSP Old: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, RPT con MBD, nodoInviaCarrelloRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+ (OLD_RTPull-6A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canaleRtPull_sec#   | #password# | 00010      | #creditor_institution_code# |
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
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | $iuv                                         |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT generation RPT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | codiceContestoPagamento           | $ccp                        |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station_old#            |
            | identificativoCarrello                | $ccp                        |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPull_sec#          |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | $ccp                        |
            | rpt                                   | $rptAttachment              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And RT generation RT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | testoAllegato                     | $bollo                      |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio       | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 1 seconds for expiration
        When EC sends soap nodoInviaCarrelloRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And wait 1 seconds for expiration
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                                |
            | CANALE           | $nodoInviaCarrelloRPT.identificativoCanale           |
            | PSP              | $nodoInviaCarrelloRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaCarrelloRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | PO                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                             |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
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
        # nodoInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                  |
            | ESITO              | RICEVUTA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReq
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaCarrelloRPTReq.password xml check value #password# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoCanale xml check value $nodoInviaCarrelloRPT.identificativoCanale in position 0
        And from $nodoInviaCarrelloRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                 |
            | ESITO              | INVIATA              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReqResp
        And from $nodoInviaCarrelloRPTReqResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $nodoInviaCarrelloRPTReqResp.url xml check value NotNone in position 0
        # pspInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTReq
        And from $pspInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoCanale xml check value #canaleRtPull_sec# in position 0
        And from $pspInviaCarrelloRPTReq.modelloPagamento xml check value 1 in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTResp
        And from $pspInviaCarrelloRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaCarrelloRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaCarrelloRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
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



    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_5
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
        And wait 1 seconds for expiration
        When EC sends soap nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And wait 1 seconds for expiration
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



    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_6
    Scenario: RT pull, FLOW con PA Old e PSP Old, PSP che utilizza flag 'RT Push' e 'Recovery' disabilitati e che l'RT sia rifiutata dal nodo per tag errato e non inviata alla PA: nodoInviaRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+, BIZ+ (OLD_RTPull-24A)
        Given RPT generation RPT_generation with datatable vertical
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
        And replace rt tag in pspChiediRT with tagErrato
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 1 seconds for expiration
        When EC sends soap nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
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
            | column | value                                                                                                       |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_RIFIUTATA_NODO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value             |
            | STATO  | RPT_ACCETTATA_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RT
        And verify 0 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RETRY_PA_INVIA_RT
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
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
        And from $pspChiediRTResp.tagErrato xml check value NotNone in position 0




    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_7
    Scenario: RT pull, FLOW con PA Old e PSP Old, PSP che utilizza flag 'RT Push' e 'Recovery' disabilitati e che la RT abbia un formato errato nella pspChiediRT: nodoInviaRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+, BIZ+ (OLD_RTPull-23A)
        Given RPT generation RPT_generation with datatable vertical
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
        And rt with e3J0QXR0YWNobWVudH0= in pspChiediRT
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 1 seconds for expiration
        When EC sends soap nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
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
            | column | value                                                                                                       |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_RIFIUTATA_NODO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                     |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value             |
            | STATO  | RPT_ACCETTATA_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RT
        And verify 0 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RETRY_PA_INVIA_RT
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
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
        And from $pspChiediRTResp.rt xml check value e3J0QXR0YWNobWVudH0= in position 0



    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_8
    Scenario: RT pull, FLOW con PA Old e PSP Old, PSP che utilizza flag 'RT Push' e 'Recovery' disabilitati e che l'RT sia rifiutata dalla PA: nodoInviaRPT, job rt-pull -> pspChiediListaRT, pspChiediRT, pspInviaAckRT, paaInviaRT+, BIZ+ (OLD_RTPull-22A)
        Given RPT generation RPT_generation with datatable vertical
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
        And from body with datatable horizontal pspInviaAckRT initial XML pspInviaAckRT
            | esito |
            | OK    |
        And from body with datatable horizontal paaInviaRT_KO initial XML paaInviaRT
            | faultCode        | faultString                | id     | description | esito |
            | PAA_SINTASSI_XSD | RT non valida rispetto XSD | mockPa | test        | KO    |
        And EC replies to nodo-dei-pagamenti with the paaInviaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        And wait 1 seconds for expiration
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
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_RIFIUTATA_PA |
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
            | STATO  | RT_RIFIUTATA_PA |
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
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
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
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTReq
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value #id_broker_old# in position 0
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $paaInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $paaInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $paaInviaRTReq.rt xml check value NotNone in position 0




    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_9
    Scenario: RT pull, FLOW con PA Old e PSP Old: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, RPT con IBAN, UPD ENABLED su CANALI, nodoInviaCarrelloRPT, job rt-pull -> job rtPullRecoveryPush, paaInviaRT+ (OLD_RTPull-8A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale                 | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | 00010      | #creditor_institution_code# |
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
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10         |
            | dataEsecuzionePagamento           | 2016-09-16                  |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | codiceContestoPagamento           | $ccp                        |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#                    |
            | identificativoStazioneIntermediarioPA | #id_station_old#                     |
            | identificativoCarrello                | $ccp                                 |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #psp#                                |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | identificativoDominio                 | #creditor_institution_code#          |
            | identificativoUnivocoVersamento       | $iuv                                 |
            | codiceContestoPagamento               | $ccp                                 |
            | rpt                                   | $rptAttachment                       |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio       | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        And update for table CANALI with parameter ENABLED = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values    |
            | TARGET_PATH | servizi/MockPSP |
        And update for table CANALI with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                         |
            | ID_CANALE  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
        And waiting after triggered refresh job ALL
        When EC sends soap nodoInviaCarrelloRPT to nodo-dei-pagamenti
        And job rtPullRecoveryPush triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And waiting after triggered refresh job ALL
        And update for table CANALI with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values    |
            | TARGET_PATH | servizi/MockPSP |
        And waiting after triggered refresh job ALL
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And verify the HTTP status code of rtPullRecoveryPush response is 200
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        And wait 1 seconds for expiration
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                                |
            | CANALE           | $nodoInviaCarrelloRPT.identificativoCanale           |
            | PSP              | $nodoInviaCarrelloRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaCarrelloRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | PO                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                             |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                |
            | ID                  | NotNone                              |
            | ID_SESSIONE         | NotNone                              |
            | CCP                 | $ccp                                 |
            | COD_ESITO           | 0                                    |
            | ESITO               | ESEGUITO                             |
            | DATA_RICEVUTA       | NotNone                              |
            | DATA_RICHIESTA      | NotNone                              |
            | ID_RICEVUTA         | NotNone                              |
            | ID_RICHIESTA        | NotNone                              |
            | SOMMA_VERSAMENTI    | 10.00                                |
            | INSERTED_TIMESTAMP  | NotNone                              |
            | UPDATED_TIMESTAMP   | NotNone                              |
            | ID_RICEVUTA         | NotNone                              |
            | ID_RICHIESTA        | NotNone                              |
            | CANALE              | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | NOTIFICA_PROCESSATA | N                                    |
            | GENERATA_DA         | PSP                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
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
        # nodoInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                  |
            | ESITO              | RICEVUTA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReq
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaCarrelloRPTReq.password xml check value #password# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoCanale xml check value $nodoInviaCarrelloRPT.identificativoCanale in position 0
        And from $nodoInviaCarrelloRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                 |
            | ESITO              | INVIATA              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReqResp
        And from $nodoInviaCarrelloRPTReqResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $nodoInviaCarrelloRPTReqResp.url xml check value NotNone in position 0
        # pspInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTReq
        And from $pspInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoCanale xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $pspInviaCarrelloRPTReq.modelloPagamento xml check value 1 in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTResp
        And from $pspInviaCarrelloRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaCarrelloRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaCarrelloRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
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




    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_10
    Scenario: RT pull, FLOW con PA Old e PSP Old: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, RPT con IBAN e MBD, UPD ENABLED su CANALI, nodoInviaCarrelloRPT, job rt-pull -> job rtPullRecoveryPush, paaInviaRT+ (OLD_RTPull-9A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale                 | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | 00010      | #creditor_institution_code# |
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
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | $iuv                                         |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT generation RPT_generation_with_IBAN_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | 2016-09-16T11:24:10         |
            | dataEsecuzionePagamento           | 2016-09-16                  |
            | importoTotaleDaVersare            | 20.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | codiceContestoPagamento           | $ccp                        |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#                    |
            | identificativoStazioneIntermediarioPA | #id_station_old#                     |
            | identificativoCarrello                | $ccp                                 |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #psp#                                |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | identificativoDominio                 | #creditor_institution_code#          |
            | identificativoUnivocoVersamento       | $iuv                                 |
            | codiceContestoPagamento               | $ccp                                 |
            | rpt                                   | $rptAttachment                       |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And RT generation RT_generation_with_IBAN_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 20.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | testoAllegato                     | $bollo                      |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio       | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        And update for table CANALI with parameter ENABLED = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values    |
            | TARGET_PATH | servizi/MockPSP |
        And update for table CANALI with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                         |
            | ID_CANALE  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
        And waiting after triggered refresh job ALL
        When EC sends soap nodoInviaCarrelloRPT to nodo-dei-pagamenti
        And job rtPullRecoveryPush triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And waiting after triggered refresh job ALL
        And update for table CANALI with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values    |
            | TARGET_PATH | servizi/MockPSP |
        And waiting after triggered refresh job ALL
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And verify the HTTP status code of rtPullRecoveryPush response is 200
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        And wait 1 seconds for expiration
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                                |
            | CANALE           | $nodoInviaCarrelloRPT.identificativoCanale           |
            | PSP              | $nodoInviaCarrelloRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaCarrelloRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | BBT                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                             |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                |
            | ID                  | NotNone                              |
            | ID_SESSIONE         | NotNone                              |
            | CCP                 | $ccp                                 |
            | COD_ESITO           | 0                                    |
            | ESITO               | ESEGUITO                             |
            | DATA_RICEVUTA       | NotNone                              |
            | DATA_RICHIESTA      | NotNone                              |
            | ID_RICEVUTA         | NotNone                              |
            | ID_RICHIESTA        | NotNone                              |
            | SOMMA_VERSAMENTI    | 20.00                                |
            | INSERTED_TIMESTAMP  | NotNone                              |
            | UPDATED_TIMESTAMP   | NotNone                              |
            | ID_RICEVUTA         | NotNone                              |
            | ID_RICHIESTA        | NotNone                              |
            | CANALE              | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | NOTIFICA_PROCESSATA | N                                    |
            | GENERATA_DA         | PSP                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
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
        # nodoInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                  |
            | ESITO              | RICEVUTA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReq
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaCarrelloRPTReq.password xml check value #password# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoCanale xml check value $nodoInviaCarrelloRPT.identificativoCanale in position 0
        And from $nodoInviaCarrelloRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                 |
            | ESITO              | INVIATA              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReqResp
        And from $nodoInviaCarrelloRPTReqResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $nodoInviaCarrelloRPTReqResp.url xml check value NotNone in position 0
        # pspInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTReq
        And from $pspInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoCanale xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $pspInviaCarrelloRPTReq.modelloPagamento xml check value 1 in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTResp
        And from $pspInviaCarrelloRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaCarrelloRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaCarrelloRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
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




    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_11
    Scenario: RT pull, FLOW con PA Old e PSP Old: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, RPT con MBD, nodoInviaCarrelloRPT, job rt-pull ->  job rtPullRecoveryPush, paaInviaRT+ (OLD_RTPull-10A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale                 | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | 00010      | #creditor_institution_code# |
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
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | $iuv                                         |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT generation RPT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | codiceContestoPagamento           | $ccp                        |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#                    |
            | identificativoStazioneIntermediarioPA | #id_station_old#                     |
            | identificativoCarrello                | $ccp                                 |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #psp#                                |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | identificativoDominio                 | #creditor_institution_code#          |
            | identificativoUnivocoVersamento       | $iuv                                 |
            | codiceContestoPagamento               | $ccp                                 |
            | rpt                                   | $rptAttachment                       |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And RT generation RT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | testoAllegato                     | $bollo                      |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio       | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        And update for table CANALI with parameter ENABLED = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values    |
            | TARGET_PATH | servizi/MockPSP |
        And update for table CANALI with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys | where_values                         |
            | ID_CANALE  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
        And waiting after triggered refresh job ALL
        When EC sends soap nodoInviaCarrelloRPT to nodo-dei-pagamenti
        And job rtPullRecoveryPush triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        And waiting after triggered refresh job ALL
        And update for table CANALI with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values    |
            | TARGET_PATH | servizi/MockPSP |
        And waiting after triggered refresh job ALL
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And verify the HTTP status code of rtPullRecoveryPush response is 200
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column           | value                                                |
            | CANALE           | $nodoInviaCarrelloRPT.identificativoCanale           |
            | PSP              | $nodoInviaCarrelloRPT.identificativoPSP              |
            | INTERMEDIARIOPSP | $nodoInviaCarrelloRPT.identificativoIntermediarioPSP |
            | TIPO_VERSAMENTO  | PO                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                                                                     |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                             |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value           |
            | STATO  | RT_ACCETTATA_PA |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                |
            | ID                  | NotNone                              |
            | ID_SESSIONE         | NotNone                              |
            | CCP                 | $ccp                                 |
            | COD_ESITO           | 0                                    |
            | ESITO               | ESEGUITO                             |
            | DATA_RICEVUTA       | NotNone                              |
            | DATA_RICHIESTA      | NotNone                              |
            | ID_RICEVUTA         | NotNone                              |
            | ID_RICHIESTA        | NotNone                              |
            | SOMMA_VERSAMENTI    | 10.00                                |
            | INSERTED_TIMESTAMP  | NotNone                              |
            | UPDATED_TIMESTAMP   | NotNone                              |
            | ID_RICEVUTA         | NotNone                              |
            | ID_RICHIESTA        | NotNone                              |
            | CANALE              | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | NOTIFICA_PROCESSATA | N                                    |
            | GENERATA_DA         | PSP                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                          |
            | IUV        | $nodoInviaCarrelloRPT.identificativoUnivocoVersamento |
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
        And from $paaAttivaRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $nodoAttivaRPT.importoSingoloVersamento in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
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
        # nodoInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                  |
            | ESITO              | RICEVUTA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReq
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaCarrelloRPTReq.password xml check value #password# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoCanale xml check value $nodoInviaCarrelloRPT.identificativoCanale in position 0
        And from $nodoInviaCarrelloRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values         |
            | ID_SESSIONE        | $sessionToken        |
            | TIPO_EVENTO        | nodoInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                 |
            | ESITO              | INVIATA              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)     |
            | ORDER BY           | DATA_ORA_EVENTO ASC  |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaCarrelloRPTReqResp
        And from $nodoInviaCarrelloRPTReqResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $nodoInviaCarrelloRPTReqResp.url xml check value NotNone in position 0
        # pspInviaCarrelloRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTReq
        And from $pspInviaCarrelloRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value #id_broker_psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoCanale xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $pspInviaCarrelloRPTReq.modelloPagamento xml check value 1 in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $pspInviaCarrelloRPTReq.elementoListaRPT.rpt xml check value NotNone in position 0
        # pspInviaCarrelloRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | pspInviaCarrelloRPT |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspInviaCarrelloRPTResp
        And from $pspInviaCarrelloRPTResp.esitoComplessivoOperazione xml check value OK in position 0
        And from $pspInviaCarrelloRPTResp.identificativoCarrello xml check value NotNone in position 0
        And from $pspInviaCarrelloRPTResp.parametriPagamentoImmediato xml check value NotNone in position 0
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






    @ALL @FLOW @FLOW_FULL @RTPULL @RTPULL_12 @after
    Scenario: RT pull, FLOW con PA Old e PSP Old: nodoChiediCatalogoServizi, nodoChiedinumeroAvviso -> paaChiediNumeroAvviso, nodoAttivaRPT -> paaAttivaRPT, RPT con MBD, nodoInviaRPT, job rt-pull ->  pspChiediListaRT, pspChiediRT, pspInviaAckRT Timeout -> job pspRetryAckNegative -> paaInviaRT+ (OLD_RTPull-12A)
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #id_broker_psp#                | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        Given from body with datatable horizontal nodoChiediNumeroAvviso initial XML nodoChiediNumeroAvviso
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | idServizio | idDominioErogatoreServizio  |
            | #psp#             | #id_broker_psp#                | #canaleRtPull_sec#   | #password# | 00010      | #creditor_institution_code# |
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
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | $iuv                                         |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT generation RPT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | codiceContestoPagamento           | $ccp                        |
            | importoSingoloVersamento          | 10.00                       |
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
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And RT generation RT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | testoAllegato                     | $bollo                      |
        And from body with datatable horizontal pspChiediListaRT initial XML pspChiediListaRT
            | identificativoDominio       | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code# | $iuv                            | $ccp                    |
        And from body with datatable horizontal pspChiediRT initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And from body with datatable horizontal pspInviaAckRT initial XML pspInviaAckRT
            | esito   |
            | timeout |
        And update parameter scheduler.pspRetryAckNegativePollerMaxRetry on configuration keys with value 1
        And update parameter scheduler.jobName_pspRetryAckNegative.enabled on configuration keys with value false
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 2 seconds
        Then check esito is OK of nodoInviaRPT response
        And wait 1 seconds for expiration
        And retrieve session token from $nodoInviaRPTResponse.url
        Given PSP2 replies to nodo-dei-pagamenti with the pspInviaAckRT
        And update parameter scheduler.jobName_pspRetryAckNegative.enabled on configuration keys with value true
        When job pspRetryAckNegative triggered after 2 seconds
        And job paInviaRt triggered after 2 seconds
        Then wait 2 seconds for expiration
        And execution query getSchedulerPspRetryAckNegativePollerMaxRetry to get value on the table CONFIGURATION_KEYS, with the columns CONFIG_VALUE under macro RTPull with db name nodo_cfg
        And through the query getSchedulerPspRetryAckNegativePollerMaxRetry retrieve param schedulerPspRetryAckNegativePollerMaxRetry at position 0 and save it under the key schedulerPspRetryAckNegativePollerMaxRetry
        And replace ccp content with $nodoInviaRPT.codiceContestoPagamento content
        And execution query by_iuv_and_ccp to get value on the table RETRY_PSP_ACK, with the columns RETRY under macro RTPull with db name nodo_online
        And through the query by_iuv_and_ccp retrieve param retry at position 0 and save it under the key retry
        And check value $schedulerPspRetryAckNegativePollerMaxRetry is equal to value $retry
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
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | nodoInviaRPT        |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value #intermediarioPA# in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value $nodoInviaRPT.identificativoPSP in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value $nodoInviaRPT.identificativoCanale in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | ID_SESSIONE        | $sessionToken       |
            | TIPO_EVENTO        | nodoInviaRPT        |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.url xml check value NotNone in position 0
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
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaAckRT       |
            | SOTTO_TIPO_EVENTO         | REQ                 |
            | ESITO                     | INVIATA             |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
        # pspInviaAckRT RESP
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys                | where_values        |
            | CODICE_CONTESTO_PAGAMENTO | $ccp                |
            | TIPO_EVENTO               | pspInviaAckRT       |
            | SOTTO_TIPO_EVENTO         | RESP                |
            | ESITO                     | RICEVUTA            |
            | INSERTED_TIMESTAMP        | TRUNC(SYSDATE-1)    |
            | ORDER BY                  | DATA_ORA_EVENTO ASC |
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