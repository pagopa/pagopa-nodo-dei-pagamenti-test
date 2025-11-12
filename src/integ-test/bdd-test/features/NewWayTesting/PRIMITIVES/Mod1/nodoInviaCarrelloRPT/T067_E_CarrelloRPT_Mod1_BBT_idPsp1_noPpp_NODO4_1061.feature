Feature: T067_E_CarrelloRPT_Mod1_BBT_idPsp1_noPpp_NODO4_1061 588

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTKO @MOD1INCARPTKO_2
    Scenario: CarrelloRPT_Mod1_BBT_idPsp1_noPpp_NODO4_1061
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #IUV#                       |
            | codiceContestoPagamento           | checkNoPPP                  |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And replace canaleUsato content with WFESP_01_gabri content
        And checks the value idPsp1 of the record at column ID_SERV_PLUGIN of the table CANALI retrived by the query chekPlugin on db nodo_cfg under macro Mod1
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrelloMills#             |
            | password                              | #password#                  |
            | identificativoPSP                     | WFESP                       |
            | identificativoIntermediarioPSP        | WFESP                       |
            | identificativoCanale                  | WFESP_01_gabri              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $IUV                        |
            | codiceContestoPagamento               | checkNoPPP                  |
            | rpt                                   | $rptAttachment              |
        And from body with datatable horizontal pspInviaCarrelloRPT_KO initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | faultCode          | faultString  | id      |
            | KO                         | CANALE_PPP_ASSENTI | system error | wrapper |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE of nodoInviaCarrelloRPT response