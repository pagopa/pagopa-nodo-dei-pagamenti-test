Feature: T066_CarrelloRPT_soloObbligatori 581

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_6
    Scenario: CarrelloRPT_soloObbligatori
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | #ccp#                       |
            | tipoVersamento                    | PO                          |
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
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | $ccp                        |
            | rpt                                   | $rptAttachment              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url field exists in nodoInviaCarrelloRPT response

