Feature: T069_CarrelloRPT_Mod2_AD_noPpp 592

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_16
    Scenario: CarrelloRPT_AD_noIdCart
        Given replace canaleUsato content with #canale_DIFFERITO_MOD2# content
        And checks the value idPsp1 of the record at column ID_SERV_PLUGIN of the table CANALI retrived by the query chekPlugin on db nodo_cfg under macro Mod1
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | checkNoPPP                  |
            | codiceContestoPagamento           | #ccp#                       |
            | tipoVersamento                    | AD                          |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrelloMills#             |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale_DIFFERITO_MOD2#     |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | checkNoPPP                  |
            | codiceContestoPagamento               | $ccp                        |
            | rpt                                   | $rptAttachment              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response







