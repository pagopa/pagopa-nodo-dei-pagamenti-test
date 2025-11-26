Feature: pspInviaCarrelloRPT_malformata_chiediAvanzamento 1417

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_6 @after
    # [pspChiediAvanzamentoRPT -> OK]
    Scenario: pspInviaCarrelloRPT_malformata_chiediAvanzamento
        Given nodo-dei-pagamenti has config parameter scheduler.pspChiediAvanzamentoRptPollerMaxRetry set to 1
        And RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | tipoVersamento                    | BBT                         |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | codiceContestoPagamento           | #ccp1#                      |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #id_broker#                 |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrello#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | $1ccp                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | malformata                                                |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        # DB Check
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                            |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ESITO_SCONOSCIUTO_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                     |
            | STATO  | RPT_ESITO_SCONOSCIUTO_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
            | CCP        | $1ccp        |
        Given from body with datatable vertical pspChiediAvanzamentoRPT initial XML pspChiediAvanzamentoRPT
            | value | OK |
        And PSP replies to nodo-dei-pagamenti with the pspChiediAvanzamentoRPT
        When job pspChiediAvanzamentoRpt triggered after 5 seconds
        And wait 10 seconds for expiration
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value                                                                                              |
            | STATO  | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ESITO_SCONOSCIUTO_PSP,RPT_ACCETTATA_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value             |
            | STATO  | RPT_ACCETTATA_PSP |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
            | CCP        | $1ccp        |
