Feature: Syntax checks for RT - OK 1586

  Background:
    Given systems up


  @ALL @PRIMITIVE @RPTSNTOK @RPTSNTOK_1
  Scenario Outline: Check OK on None RT tag
    Given RPT generation RPT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | #timedate#                  |
      | dataEsecuzionePagamento           | #date#                      |
      | importoTotaleDaVersare            | 10.00                       |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | BBT                         |
      | ibanAddebito                      | IT96R0123454321000000012345 |
      | importoSingoloVersamento          | 10.00                       |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | #psp#                       |
      | identificativoCanale                  | #canale#                    |
      | rpt                                   | $rptAttachment              |
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
      | OK                         | $iuv                   | $iuv                        |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    Given RT body generation RT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRicevuta          | #timedate#                  |
      | importoTotalePagato               | 10.00                       |
      | identificativoUnivocoVersamento   | $iuv                        |
      | identificativoUnivocoRiscossione  | $iuv                        |
      | CodiceContestoPagamento           | CCD01                       |
      | codiceEsitoPagamento              | 0                           |
      | singoloImportoPagato              | 10.00                       |
      | esitoSingoloPagamento             | TUTTO_OK                    |
      | dataEsitoSingoloPagamento         | #date#                      |
    And <elem> with <value> in rtAttachmentBody
    And RT rtAttachmentBody to base64
    And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
      | identificativoIntermediarioPSP  | #psp#                       |
      | identificativoCanale            | #canale#                    |
      | password                        | #password#                  |
      | identificativoPSP               | #psp#                       |
      | identificativoDominio           | #creditor_institution_code# |
      | identificativoUnivocoVersamento | $iuv                        |
      | codiceContestoPagamento         | CCD01                       |
      | forzaControlloSegno             | 1                           |
      | rt                              | $rtAttachment               |
    When psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRT response
    Examples:
      | SoapUI     | elem                                    | value |
      | RTSIN8.1   | pay_i:identificativoStazioneRichiedente | None  |
      | RTSIN38.1  | pay_i:codiceUnitOperAttestante          | None  |
      | RTSIN40.1  | pay_i:denomUnitOperAttestante           | None  |
      | RTSIN42.1  | pay_i:indirizzoAttestante               | None  |
      | RTSIN44.1  | pay_i:civicoAttestante                  | None  |
      | RTSIN46.1  | pay_i:capAttestante                     | None  |
      | RTSIN48.1  | pay_i:localitaAttestante                | None  |
      | RTSIN50.1  | pay_i:provinciaAttestante               | None  |
      | RTSIN52.1  | pay_i:nazioneAttestante                 | None  |
      | RTSIN70.1  | pay_i:codiceUnitOperBeneficiario        | None  |
      | RTSIN72.1  | pay_i:denomUnitOperBeneficiario         | None  |
      | RTSIN74.1  | pay_i:indirizzoBeneficiario             | None  |
      | RTSIN76.1  | pay_i:civicoBeneficiario                | None  |
      | RTSIN78.1  | pay_i:capBeneficiario                   | None  |
      | RTSIN80.1  | pay_i:localitaBeneficiario              | None  |
      | RTSIN82.1  | pay_i:provinciaBeneficiario             | None  |
      | RTSIN84.1  | pay_i:nazioneBeneficiario               | None  |
      | RTSIN86.1  | pay_i:soggettoVersante                  | None  |
      | RTSIN99.1  | pay_i:indirizzoVersante                 | None  |
      | RTSIN101.1 | pay_i:civicoVersante                    | None  |
      | RTSIN103.1 | pay_i:capVersante                       | None  |
      | RTSIN105.1 | pay_i:localitaVersante                  | None  |
      | RTSIN107.1 | pay_i:provinciaVersante                 | None  |
      | RTSIN109.1 | pay_i:nazioneVersante                   | None  |
      | RTSIN111.1 | pay_i:e-mailVersante                    | None  |
      | RTSIN128.1 | pay_i:indirizzoPagatore                 | None  |
      | RTSIN130.1 | pay_i:civicoPagatore                    | None  |
      | RTSIN132.1 | pay_i:capPagatore                       | None  |
      | RTSIN134.1 | pay_i:localitaPagatore                  | None  |
      | RTSIN136.1 | pay_i:provinciaPagatore                 | None  |
      | RTSIN138.1 | pay_i:nazionePagatore                   | None  |
      | RTSIN140.1 | pay_i:e-mailPagatore                    | None  |
      | RTSIN169.1 | pay_i:esitoSingoloPagamento             | None  |


  @ALL @PRIMITIVE @RPTSNTOK @RPTSNTOK_2
  Scenario Outline: Check OK on None RT with MB [RTSIN190.1]
    Given RPT generation RPT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | #timedate#                  |
      | dataEsecuzionePagamento           | #date#                      |
      | importoTotaleDaVersare            | 10.00                       |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | BBT                         |
      | ibanAddebito                      | IT96R0123454321000000012345 |
      | importoSingoloVersamento          | 10.00                       |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | #psp#                       |
      | identificativoCanale                  | #canale#                    |
      | rpt                                   | $rptAttachment              |
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
      | OK                         | $iuv                   | $iuv                        |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    Given MB generation MBD_generation_diff_DGV with datatable vertical
      | CodiceFiscale | 12345678901                                  |
      | Denominazione | #psp#                                        |
      | IUBD          | #iubd#                                       |
      | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
      | Importo       | 10.00                                        |
      | TipoBollo     | 01                                           |
      | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
    And RT body generation RT_generation_with_MBD with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRicevuta          | #timedate#                  |
      | importoTotalePagato               | 10.00                       |
      | identificativoUnivocoVersamento   | $iuv                        |
      | identificativoUnivocoRiscossione  | $iuv                        |
      | CodiceContestoPagamento           | CCD01                       |
      | codiceEsitoPagamento              | 0                           |
      | singoloImportoPagato              | 10.00                       |
      | esitoSingoloPagamento             | TUTTO_OK                    |
      | dataEsitoSingoloPagamento         | #date#                      |
    And <elem> with <value> in rtAttachmentBody
    And RT rtAttachmentBody to base64
    And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
      | identificativoIntermediarioPSP  | #psp#                       |
      | identificativoCanale            | #canale#                    |
      | password                        | #password#                  |
      | identificativoPSP               | #psp#                       |
      | identificativoDominio           | #creditor_institution_code# |
      | identificativoUnivocoVersamento | $iuv                        |
      | codiceContestoPagamento         | CCD01                       |
      | forzaControlloSegno             | 1                           |
      | rt                              | $rtAttachment               |
    When psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRT response
    Examples:
      | elem                   | value | SoapUI     |
      | pay_i:allegatoRicevuta | None  | RTSIN190.1 |