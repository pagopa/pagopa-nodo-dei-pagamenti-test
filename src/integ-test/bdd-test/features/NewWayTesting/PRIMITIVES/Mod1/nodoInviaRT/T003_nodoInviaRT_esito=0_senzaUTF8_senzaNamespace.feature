Feature: T003_nodoInviaRT_esito=0_senzaUTF8_senzaNamespace 518

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1NIRTOK @MOD1NIRTOK_7
    Scenario: nodoInviaRT_esito=0_senzaUTF8_senzaNamespace
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation_NO_namespace with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | esitoSingoloPagamento             | REJECT                      |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                                                         |
            | identificativoCarrello      | $nodoInviaRPT.identificativoUnivocoVersamento              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoDominio           | #creditor_institution_code#  |
            | identificativoUnivocoVersamento | $1iuv                        |
            | codiceContestoPagamento         | CCD01                        |
            | password                        | #password#                   |
            | identificativoPSP               | #psp#                        |
            | identificativoIntermediarioPSP  | #psp#                        |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP# |
            | rt                              | $rt1Attachment               |
            | forzaControlloSegno             | 1                            |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response

