Feature: RT PUSH flow

    Background:
        Given systems up


    @ALL @FLOW @FLOW_FULL @RT_PUSH @RT_PUSH_1
    Scenario: RT push, FLOW con PA New e PSP che utilizza: RPT e RT con MBD -> nodoInviaCarrelloRPT -> pspInviaCarrelloRPT, nodoInviaRT  BIZ+ (OLD_RTPush-1B)
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 5.00                        |
            | tipoVersamento                    | BBT                         |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | #ccp#                       |
            | importoSingoloVersamento          | 5.00                        |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 5.00                        |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 5.00                        |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#                    |
            | identificativoStazioneIntermediarioPA | #id_station#                         |
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
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                      |
            | identificativoCanale            | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | password                        | #password#                           |
            | identificativoPSP               | #psp#                                |
            | identificativoDominio           | #creditor_institution_code#          |
            | identificativoUnivocoVersamento | $iuv                                 |
            | codiceContestoPagamento         | $ccp                                 |
            | forzaControlloSegno             | 1                                    |
            | rt                              | $rtAttachment                        |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                                                                                     |
            | ID          | NotNone                                                                                                                                   |
            | ID_SESSIONE | $sessionToken,$sessionToken,$sessionToken,$sessionToken,NotNone,NotNone,NotNone,NotNone                                                   |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,pspInviaCarrelloRPT,pspInviaCarrelloRPT,nodoInviaRT,nodoInviaRT,nodoInviaRT,nodoInviaRT         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | $iuv                      |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $iuv         |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | RT_ACCETTATA_PA      |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # STATI_CARRELLO_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | CART_ACCETTATO_PSP   |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
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
            | SOMMA_VERSAMENTI    | NotNone                              |
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
        And from $nodoInviaRTReq.identificativoCanale xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $nodoInviaRTReq.password xml check value #password# in position 0
        And from $nodoInviaRTReq.identificativoPSP xml check value #id_broker_psp# in position 0
        And from $nodoInviaRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRTReq.forzaControlloSegno xml check value 1 in position 0
        And from $nodoInviaRTReq.rt xml check value NotNone in position 0
        # nodoInviaRT RES
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
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station# in position 0
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









    @ALL @FLOW @FLOW_FULL @RT_PUSH @RT_PUSH_2
    Scenario: RT push, FLOW con PA New e PSP che utilizza: MB, RPT e RT con MBD -> nodoInviaCarrelloRPT -> pspInviaCarrelloRPT, nodoInviaRT  BIZ+ (OLD_RTPush-2B)
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT generation RPT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | BBT                         |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | #ccp#                       |
            | importoSingoloVersamento          | 10.00                       |
        And RT generation RT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | testoAllegato                     | $bollo                      |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#                    |
            | identificativoStazioneIntermediarioPA | #id_station#                         |
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
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                      |
            | identificativoCanale            | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | password                        | #password#                           |
            | identificativoPSP               | #psp#                                |
            | identificativoDominio           | #creditor_institution_code#          |
            | identificativoUnivocoVersamento | $iuv                                 |
            | codiceContestoPagamento         | $ccp                                 |
            | forzaControlloSegno             | 1                                    |
            | rt                              | $rtAttachment                        |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                                                                                     |
            | ID          | NotNone                                                                                                                                   |
            | ID_SESSIONE | $sessionToken,$sessionToken,$sessionToken,$sessionToken,NotNone,NotNone,NotNone,NotNone                                                   |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,pspInviaCarrelloRPT,pspInviaCarrelloRPT,nodoInviaRT,nodoInviaRT,nodoInviaRT,nodoInviaRT         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | $iuv                      |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $iuv         |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | RT_ACCETTATA_PA      |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # STATI_CARRELLO_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | CART_ACCETTATO_PSP   |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
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
            | SOMMA_VERSAMENTI    | NotNone                              |
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
        And from $nodoInviaRTReq.identificativoCanale xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $nodoInviaRTReq.password xml check value #password# in position 0
        And from $nodoInviaRTReq.identificativoPSP xml check value #id_broker_psp# in position 0
        And from $nodoInviaRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRTReq.forzaControlloSegno xml check value 1 in position 0
        And from $nodoInviaRTReq.rt xml check value NotNone in position 0
        # nodoInviaRT RES
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
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station# in position 0
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







    @ALL @FLOW @FLOW_FULL @RT_PUSH @RT_PUSH_3
    Scenario: RT push, FLOW con PA New e PSP che utilizza: MB, RPT e RT con MBD and IBAN -> nodoInviaCarrelloRPT -> pspInviaCarrelloRPT, nodoInviaRT  BIZ+ (OLD_RTPush-3B)
        Given MB generation MBD_generation with datatable vertical
            | CodiceFiscale | #creditor_institution_code#                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 5.00                                         |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT generation RPT_generation_with_MBD_and_IBAN with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 11.00                       |
            | tipoVersamento                    | BBT                         |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | #ccp#                       |
        And RT generation RT_generation_with_MBD_and_IBAN with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 11.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | $ccp                        |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 5.00                        |
            | testoAllegato                     | $bollo                      |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#                    |
            | identificativoStazioneIntermediarioPA | #id_station#                         |
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
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                      |
            | identificativoCanale            | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | password                        | #password#                           |
            | identificativoPSP               | #psp#                                |
            | identificativoDominio           | #creditor_institution_code#          |
            | identificativoUnivocoVersamento | $iuv                                 |
            | codiceContestoPagamento         | $ccp                                 |
            | forzaControlloSegno             | 1                                    |
            | rt                              | $rtAttachment                        |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                                                                                     |
            | ID          | NotNone                                                                                                                                   |
            | ID_SESSIONE | $sessionToken,$sessionToken,$sessionToken,$sessionToken,NotNone,NotNone,NotNone,NotNone                                                   |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,pspInviaCarrelloRPT,pspInviaCarrelloRPT,nodoInviaRT,nodoInviaRT,nodoInviaRT,nodoInviaRT         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | $iuv                      |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $iuv         |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | RT_ACCETTATA_PA      |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # STATI_CARRELLO_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | CART_ACCETTATO_PSP   |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
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
            | SOMMA_VERSAMENTI    | NotNone                              |
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
        And from $nodoInviaRTReq.identificativoCanale xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $nodoInviaRTReq.password xml check value #password# in position 0
        And from $nodoInviaRTReq.identificativoPSP xml check value #id_broker_psp# in position 0
        And from $nodoInviaRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRTReq.forzaControlloSegno xml check value 1 in position 0
        And from $nodoInviaRTReq.rt xml check value NotNone in position 0
        # nodoInviaRT RES
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
        And from $paaInviaRTReq.identificativoStazioneIntermediarioPA xml check value #id_station# in position 0
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







    @ALL @FLOW @FLOW_FULL @RT_PUSH @RT_PUSH_4
    Scenario: RT push, FLOW con PA New e PSP che utilizza: RPT e RT -> nodoInviaRPT -> pspInviaRPT, nodoInviaRT  BIZ+ (OLD_RTPush-5B)
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | BBT                             |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | #ccp#                           |
            | importoSingoloVersamento          | 10.00                           |
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
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | $ccp                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canaleRtPush#                  |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                                                         |
            | identificativoCarrello      | $nodoInviaRPT.identificativoUnivocoVersamento              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $iuv                            |
            | codiceContestoPagamento         | $ccp                            |
            | forzaControlloSegno             | 0                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
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
            | column      | value                                                                                                                                     |
            | ID          | NotNone                                                                                                                                   |
            | ID_SESSIONE | $sessionToken,$sessionToken,$sessionToken,$sessionToken,NotNone,NotNone,NotNone,NotNone                                                   |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,pspInviaRPT,nodoInviaRT,nodoInviaRT,nodoInviaRT,nodoInviaRT                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | $iuv                      |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $iuv         |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value           |
            | ID_SESSIONE | $sessionToken   |
            | STATO       | RT_ACCETTATA_PA |
            | INSERTED_BY | nodoInviaRPT    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
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
            | SOMMA_VERSAMENTI    | NotNone                              |
            | INSERTED_TIMESTAMP  | NotNone                              |
            | UPDATED_TIMESTAMP   | NotNone                              |
            | ID_RICEVUTA         | NotNone                              |
            | ID_RICHIESTA        | NotNone                              |
            | CANALE              | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | NOTIFICA_PROCESSATA | N                                    |
            | GENERATA_DA         | PSP                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
        # RE #####
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
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value #creditor_institution_code_old# in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #psp# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleRtPush# in position 0
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
        And from $pspInviaRPTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $pspInviaRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaRPTReq.identificativoIntermediarioPSP xml check value #psp# in position 0
        And from $pspInviaRPTReq.identificativoCanale xml check value #canaleRtPush# in position 0
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
        And from $nodoInviaRTReq.identificativoCanale xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $nodoInviaRTReq.password xml check value #password# in position 0
        And from $nodoInviaRTReq.identificativoPSP xml check value #id_broker_psp# in position 0
        And from $nodoInviaRTReq.identificativoDominio xml check value #intermediarioPA# in position 0
        And from $nodoInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRTReq.forzaControlloSegno xml check value 0 in position 0
        And from $nodoInviaRTReq.rt xml check value NotNone in position 0
        # nodoInviaRT RES
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
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value #creditor_institution_code_old# in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
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








    @ALL @FLOW @FLOW_FULL @RT_PUSH @RT_PUSH_5
    Scenario: RT push, FLOW con PA New e PSP che utilizza: RPT e RT -> nodoInviaCarrelloRPT -> pspInviaCarrelloRPT, nodoInviaRT  BIZ+ (OLD_RTPush-6B)
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | BBT                             |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | #ccp#                           |
            | importoSingoloVersamento          | 10.00                           |
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
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $ccp                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canaleRtPush#                  |
            | identificativoDominio                 | #creditor_institution_code#     |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | $ccp                            |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $iuv                            |
            | codiceContestoPagamento         | $ccp                            |
            | forzaControlloSegno             | 0                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
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
            | column      | value                                                                                                                                     |
            | ID          | NotNone                                                                                                                                   |
            | ID_SESSIONE | $sessionToken,$sessionToken,$sessionToken,$sessionToken,NotNone,NotNone,NotNone,NotNone                                                   |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,pspInviaCarrelloRPT,pspInviaCarrelloRPT,nodoInviaRT,nodoInviaRT,nodoInviaRT,nodoInviaRT         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | $iuv                      |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $iuv         |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | RT_ACCETTATA_PA      |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # STATI_CARRELLO_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                |
            | ID_SESSIONE | $sessionToken        |
            | STATO       | CART_ACCETTATO_PSP   |
            | INSERTED_BY | nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # # RE #####
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
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPA xml check value #creditor_institution_code_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaCarrelloRPTReq.password xml check value #password# in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoPSP xml check value $nodoInviaCarrelloRPT.identificativoPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $nodoInviaCarrelloRPTReq.identificativoCanale xml check value #canaleRtPush# in position 0
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
        And from $pspInviaCarrelloRPTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoPSP xml check value #psp# in position 0
        And from $pspInviaCarrelloRPTReq.identificativoIntermediarioPSP xml check value $nodoInviaCarrelloRPT.identificativoIntermediarioPSP in position 0
        And from $pspInviaCarrelloRPTReq.identificativoCanale xml check value #canaleRtPush# in position 0
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
        And from $nodoInviaRTReq.identificativoCanale xml check value #canaleRtPush# in position 0
        And from $nodoInviaRTReq.password xml check value #password# in position 0
        And from $nodoInviaRTReq.identificativoPSP xml check value #psp# in position 0
        And from $nodoInviaRTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
        And from $nodoInviaRTReq.identificativoUnivocoVersamento xml check value $iuv in position 0
        And from $nodoInviaRTReq.codiceContestoPagamento xml check value $ccp in position 0
        And from $nodoInviaRTReq.forzaControlloSegno xml check value 0 in position 0
        And from $nodoInviaRTReq.rt xml check value NotNone in position 0
        # nodoInviaRT RES
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
        And from $paaInviaRTReq.identificativoIntermediarioPA xml check value #creditor_institution_code_old# in position 0
        And from $paaInviaRTReq.identificativoDominio xml check value #creditor_institution_code_old# in position 0
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