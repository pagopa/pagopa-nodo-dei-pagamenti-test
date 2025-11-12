Feature: T067_CarrelloRPT_BBT_Convenzioni_35caratteriStrani 585

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_10
    Scenario: CarrelloRPT_BBT_Convenzioni_35caratteriStrani
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #IUV#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | PO                          |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And RT generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $IUV                        |
            | identificativoUnivocoRiscossione  | $IUV                        |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | esitoSingoloPagamento             | Pagamento effettuato        |
        And from body with datatable vertical nodoInviaCarrelloRPT_cod_codiceConvenzione initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code#       |
            | identificativoStazioneIntermediarioPA | #id_station#                      |
            | identificativoCarrello                | #carrello#                        |
            | password                              | #password#                        |
            | identificativoPSP                     | #psp#                             |
            | identificativoIntermediarioPSP        | #psp#                             |
            | identificativoCanale                  | #canaleRtPush#                    |
            | identificativoDominio                 | #creditor_institution_code#       |
            | identificativoUnivocoVersamento       | $IUV                              |
            | codiceContestoPagamento               | CCD01                             |
            | rpt                                   | $rptAttachment                    |
            | codiceConvenzione                     | car@tter!/tr$% ? #[]o'a=?-_\(+*e^ |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url field exists in nodoInviaCarrelloRPT response
        #DB check
        And replace idCarrello content with $carrello content
        And wait 20 seconds for expiration
        And checks the value $nodoInviaCarrelloRPT.codiceConvenzione of the record at column CODICE_CONVENZIONE of the table CARRELLO retrived by the query codice_convenzione on db nodo_online under macro Mod1

