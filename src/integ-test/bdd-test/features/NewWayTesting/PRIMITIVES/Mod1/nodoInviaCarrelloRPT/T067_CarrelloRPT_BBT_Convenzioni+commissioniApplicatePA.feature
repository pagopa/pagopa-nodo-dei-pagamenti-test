Feature: T067_CarrelloRPT_BBT_Convenzioni+commissioniApplicatePA 584

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_12
    Scenario: CarrelloRPT_BBT_Convenzioni+commissioniApplicatePA
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | PO                          |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And RT generation RT_generation_comm_PA_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | CCD01                       |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | esitoSingoloPagamento             | Pagamento effettuato        |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT_cod_codiceConvenzione initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrello#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rptAttachment              |
            | codiceConvenzione                     | codiceConvenzione$iuv       |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url field exists in nodoInviaCarrelloRPT response
        #DB check
        And wait 20 seconds for expiration
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                 |
            | CODICE_CONVENZIONE | codiceConvenzione$iuv |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table CARRELLO retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values |
            | ID_CARRELLO | $carrello    |
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canale#                    |
            | password                        | #password#                  |
            | identificativoPSP               | #psp#                       |
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $iuv                        |
            | codiceContestoPagamento         | CCD01                       |
            | forzaControlloSegno             | 1                           |
            | rt                              | $rtAttachment               |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
