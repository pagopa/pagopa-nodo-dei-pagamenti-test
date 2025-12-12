Feature: process tests for nodoChiediCopiaRT 805

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SINCCRTOK @MOD1SINCCRTOK_1
    Scenario: process tests for nodoChiediCopiaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | CCD01                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | rpt                                   | $rptAttachment              |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given RT generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $iuv                        |
            | identificativoUnivocoRiscossione  | $iuv                        |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | esitoSingoloPagamento             | REJECT                      |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canaleRtPush#              |
            | password                        | #password#                  |
            | identificativoPSP               | #psp#                       |
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $iuv                        |
            | codiceContestoPagamento         | CCD01                       |
            | forzaControlloSegno             | 1                           |
            | rt                              | $rtAttachment               |
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        Given from body with datatable vertical nodoChiediCopiaRT initial XML nodoChiediCopiaRT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $iuv                        |
            | codiceContestoPagamento               | CCD01                       |
        When EC sends SOAP nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response