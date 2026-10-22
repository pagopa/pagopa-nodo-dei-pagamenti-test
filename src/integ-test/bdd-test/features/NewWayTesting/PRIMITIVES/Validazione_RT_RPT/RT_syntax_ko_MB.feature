Feature: Syntax checks for RT with MB - KO 1585

  Background:
    Given systems up

  @ALL @PRIMITIVE @RTMBSNTKO @RTMBSNTKO_1
  Scenario Outline: Execute nodoInviaRPT
    Given MB generation MBD_generation with datatable vertical
      | CodiceFiscale | 12345678901                                  |
      | Denominazione | #psp#                                        |
      | IUBD          | #iubd#                                       |
      | OraAcquisto   | 2022-02-06T15:00:44.659+01:00                |
      | Importo       | 10.00                                        |
      | TipoBollo     | 01                                           |
      | DigestValue   | wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E= |
    And RPT generation RPT_generation_with_MBD_noIBAN with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | #timedate#                  |
      | dataEsecuzionePagamento           | #date#                      |
      | importoTotaleDaVersare            | 10.00                       |
      | ibanAddebito                      | IT45R0760103200000000001016 |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceIdentificativoUnivoco       | 11111111117                 |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | BBT                         |
      | importoSingoloVersamento          | 10.00                       |
      | commissioneCaricoPA               | 1.00                        |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
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
    Given RT body generation RT_generation_with_MBD with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRicevuta          | #timedate#                  |
      | importoTotalePagato               | 10.00                       |
      | identificativoUnivocoVersamento   | $iuv                        |
      | identificativoUnivocoRiscossione  | $iuv                        |
      | CodiceContestoPagamento           | CCD01                       |
      | codiceEsitoPagamento              | 0                           |
      | singoloImportoPagato              | 10.00                       |
    And <elem> with <value> in rtAttachmentBody
    And RT rtAttachmentBody to base64
    And from body with datatable vertical nodoInviaRT initial XML nodoInviaRT
      | identificativoIntermediarioPSP  | #psp#                       |
      | identificativoCanale            | #canaleRtPush#              |
      | password                        | #password#                  |
      | identificativoPSP               | #psp#                       |
      | identificativoDominio           | #creditor_institution_code# |
      | identificativoUnivocoVersamento | $iuv                        |
      | codiceContestoPagamento         | CCD01                       |
      | forzaControlloSegno             | 1                           |
      | rt                              | $rtAttachment               |
    When psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response
    Examples:
      | SoapUI   | elem                       | value         |
      | RTSIN190 | pay_i:allegatoRicevuta     | Empty         |
      | RTSIN191 | pay_i:allegatoRicevuta     | Occurrences,2 |
      | RTSIN192 | pay_i:tipoAllegatoRicevuta | None          |
      | RTSIN193 | pay_i:tipoAllegatoRicevuta | Empty         |
      | RTSIN194 | pay_i:tipoAllegatoRicevuta | AB            |
      | RTSIN195 | pay_i:tipoAllegatoRicevuta | ABD           |
      | RTSIN196 | pay_i:tipoAllegatoRicevuta | B             |
      | RTSIN197 | pay_i:testoAllegato        | None          |
      | RTSIN198 | pay_i:testoAllegato        | Empty         |
      | RTSIN199 | pay_i:testoAllegato        | prova         |