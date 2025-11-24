Feature: T003_nodoInviaRT_esito=0_ibanSloveno 516

    Background:
        Given systems up
    #nell'RPT dominio e stazione definiti nel soapui

    @ALL @PRIMITIVE @MOD1 @MOD1NIRTOK @MOD1NIRTOK_5
    Scenario: nodoInviaRT_esito=0_ibanSloveno
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | 23232323232                 |
            | identificativoStazioneRichiedente | stazPaStress23              |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | PO                          |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | SI56107601000123438         |
            | ibanAppoggio                      | SI56107601000123438         |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation_full with datatable vertical
            | identificativoDominio             | 23232323232     |
            | identificativoStazioneRichiedente | #id_station#    |
            | dataOraMessaggioRicevuta          | #timedate#      |
            | importoTotalePagato               | 10.00           |
            | identificativoUnivocoVersamento   | $1iuv           |
            | identificativoUnivocoRiscossione  | $1iuv           |
            | CodiceContestoPagamento           | CCD01           |
            | codiceIdentificativoUnivoco       | CodiceIdentific |
            | codiceEsitoPagamento              | 0               |
            | esitoSingoloPagamento             | TUTTO_OK        |
            | singoloImportoPagato              | 10.00           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | intPaStress23   |
            | identificativoStazioneIntermediarioPA | stazPaStress23  |
            | identificativoCarrello                | $1iuv           |
            | password                              | #password#      |
            | identificativoPSP                     | #psp#           |
            | identificativoIntermediarioPSP        | #psp#           |
            | identificativoCanale                  | #canaleRtPush#  |
            | identificativoDominio                 | 23232323232     |
            | identificativoUnivocoVersamento       | $1iuv           |
            | codiceContestoPagamento               | CCD01           |
            | rpt                                   | $rpt1Attachment |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoDominio           | 23232323232    |
            | identificativoUnivocoVersamento | $1iuv          |
            | codiceContestoPagamento         | CCD01          |
            | password                        | #password#     |
            | identificativoPSP               | #psp#          |
            | identificativoIntermediarioPSP  | #psp#          |
            | identificativoCanale            | #canaleRtPush# |
            | rt                              | $rt1Attachment |
            | forzaControlloSegno             | 1              |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response