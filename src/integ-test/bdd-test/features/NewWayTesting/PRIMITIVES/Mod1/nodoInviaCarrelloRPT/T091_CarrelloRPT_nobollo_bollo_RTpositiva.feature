Feature: T091_CarrelloRPT_nobollo_bollo_RTpositiva 610

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_29
    Scenario: CarrelloRPT_nobollo_bollo_RTpositiva
        Given MB generation MBD_generation_diff_DGV with datatable vertical
            | CodiceFiscale | 12345678901                                  |
            | Denominazione | #psp#                                        |
            | IUBD          | #iubd#                                       |
            | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
            | Importo       | 10.00                                        |
            | TipoBollo     | 01                                           |
            | DigestValue   | 4HpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
        And RPT1 generation RPT_generation_with_2_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 20.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And RPT2 generation RPT_generation_with_2_payments_1MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 20.00                       |
            | commissioneCaricoPA               | 1.25                        |
            | identificativoUnivocoVersamento   | #iuv2#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation_full_with_2_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station#                    |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 20.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | identificativoUnivocoRiscossione  | $1iuv                           |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
            | esitoSingoloPagamento             | Pagamento effettuato            |
            | dataEsitoSingoloPagamento         | #date#                          |
        And RT2 generation RT_generation_full_with_2_payments_1MBD with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station#                    |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 20.00                           |
            | identificativoUnivocoVersamento   | $2iuv                           |
            | identificativoUnivocoRiscossione  | $2iuv                           |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
            | esitoSingoloPagamento             | Pagamento effettuato            |
            | dataEsitoSingoloPagamento         | #date#                          |
            | testoAllegato                     | $bollo                          |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrello#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio1                | #creditor_institution_code# |
            | identificativoUnivocoVersamento1      | $1iuv                       |
            | codiceContestoPagamento1              | CCD01                       |
            | rpt1                                  | $rpt1Attachment             |
            | identificativoDominio2                | #creditor_institution_code# |
            | identificativoUnivocoVersamento2      | $2iuv                       |
            | codiceContestoPagamento2              | CCD01                       |
            | rpt2                                  | $rpt2Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canaleRtPush#              |
            | password                        | #password#                  |
            | identificativoPSP               | idPsp1                      |
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $1iuv                       |
            | codiceContestoPagamento         | CCD01                       |
            | forzaControlloSegno             | 1                           |
            | rt                              | $rt1Attachment              |
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                       |
            | identificativoCanale            | #canaleRtPush#              |
            | password                        | #password#                  |
            | identificativoPSP               | idPsp1                      |
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $2iuv                       |
            | codiceContestoPagamento         | CCD01                       |
            | forzaControlloSegno             | 1                           |
            | rt                              | $rt2Attachment              |
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response