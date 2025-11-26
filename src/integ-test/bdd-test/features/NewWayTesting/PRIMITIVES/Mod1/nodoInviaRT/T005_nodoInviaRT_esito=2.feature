Feature: T005_nodoInviaRT_esito=2 520
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1NIRTOK @MOD1NIRTOK_11
    Scenario: test nodoInviaRT_esito=
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | tipoVersamento                    | BBT                         |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | codiceContestoPagamento           | CCD01                       |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation_NO_namespace with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 1.00                        |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 2                           |
            | singoloImportoPagato              | 1.00                        |
            | esitoSingoloPagamento             | PARTIAL                     |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                                                         |
            | identificativoCarrello      | $nodoInviaRPT.identificativoUnivocoVersamento              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $1iuv                       |
            | codiceContestoPagamento         | CCD01                       |
            | password                        | #password#                  |
            | identificativoPSP               | #psp#                       |
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canaleRtPush#              |
            | rt                              | $rt1Attachment              |
            | forzaControlloSegno             | 1                           |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response



