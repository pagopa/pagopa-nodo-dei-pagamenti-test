Feature: T012_RT_allegato=BD 526
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1NIRTOK @MOD1NIRTOK_16
    Scenario: RT_allegato=BD
        Given MB generation MBD_generation_diff_DGV with datatable vertical
            | CodiceFiscale | 12345678901                                  |
            | Denominazione | idPsp1                                       |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT1 generation RPT_generation_with_MBD_noIBAN with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | codiceIdentificativoUnivoco       | 11111111117                 |
            | tipoVersamento                    | BBT                         |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | commissioneCaricoPA               | 1.00                        |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation_with_MBD_esitoPagamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | esitoSingoloPagamento             | Pagamento effettuato        |
            | testoAllegato                     | $bollo                      |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
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
        And check redirect is 1 of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
            | identificativoDominio           | #intermediarioPA# |
            | identificativoUnivocoVersamento | $1iuv             |
            | codiceContestoPagamento         | CCD01             |
            | password                        | #password#        |
            | identificativoPSP               | idPsp1            |
            | identificativoIntermediarioPSP  | #psp#             |
            | identificativoCanale            | #canaleRtPush#    |
            | rt                              | $rt1Attachment    |
            | forzaControlloSegno             | 1                 |
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response