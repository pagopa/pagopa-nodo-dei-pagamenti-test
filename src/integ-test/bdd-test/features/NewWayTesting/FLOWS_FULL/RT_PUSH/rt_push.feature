Feature: RT_PUSH

    Background:
        Given systems up    
    
    @ALL @FLOW @FLOW_FULL @RT_PUSH @RT_PUSH_1 
    Scenario: nodoInviaCarrelloRPT - PAG-2346 rt push 1 iban 1479 (old_rtpush_1)
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
        And RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 5.00                        |
            | tipoVersamento                    | BBT                         |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | $1carrello                  |
            | importoSingoloVersamento          | 5.00                        |
        Given RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 5.00                        |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | $1carrello                  |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 5.00                        |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#                    |
            | identificativoStazioneIntermediarioPA | #id_station#                         |
            | identificativoCarrello                | $1carrello                           |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #psp#                                |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | identificativoDominio                 | #creditor_institution_code#          |
            | identificativoUnivocoVersamento       | $1iuv                                |
            | codiceContestoPagamento               | $1carrello                           |
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
            | identificativoUnivocoVersamento | $1iuv                                |
            | codiceContestoPagamento         | $1carrello                           |
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
            | IUV        | $1iuv                     |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 8 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                       |
            | ID_SESSIONE | $sessionToken                               |
            | STATO       | RT_ACCETTATA_PA |
            | INSERTED_BY | nodoInviaCarrelloRPT   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # STATI_CARRELLO_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                  |
            | ID_SESSIONE | $sessionToken          |
            | STATO       | CART_ACCETTATO_PSP |
            | INSERTED_BY | nodoInviaCarrelloRPT   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |