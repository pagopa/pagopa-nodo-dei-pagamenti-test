Feature: T001A_DYNAMIC_RPT_RT_Bollo_hash72char 494
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1MBIRPTOK @MOD1MBIRPTOK_1
    Scenario: T001A_DYNAMIC_RPT_RT_Bollo_hash72char
        Given MB generation MBD_generation_diff_DGV with datatable vertical
            | CodiceFiscale | 12345678901                                                              |
            | Denominazione | #psp#                                                                    |
            | IUBD          | #iubd#                                                                   |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                                            |
            | Importo       | 10.00                                                                    |
            | TipoBollo     | 01                                                                       |
            | DigestValue   | YWR5aWZ2c2hyZHZ1aW9qcnBvc20sdm9wbWtwYWR5aWZ2c2hyZHZ1aW9qcnBvc20sdm9wbWtw |
        And RPT generation RPT_generation_with_MBD_noIBAN with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | PO                          |
            | identificativoUnivocoVersamento   | #IUV#                       |
            | codiceContestoPagamento           | CCD01                       |
            | codiceIdentificativoUnivoco       | 11111111117                 |
            | importoSingoloVersamento          | 10.00                       |
            | commissioneCaricoPA               | 1.00                        |
        And RT generation RT_generation_with_MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $IUV                        |
            | identificativoUnivocoRiscossione  | $IUV                        |
            | CodiceContestoPagamento           | CCD01                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
            | testoAllegato                     | $bollo                      |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $IUV                        |
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