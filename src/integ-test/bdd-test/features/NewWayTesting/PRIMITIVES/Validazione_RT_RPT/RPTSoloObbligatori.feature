Feature: RPTSoloObbligatori 1577

  Background:
    Given systems up


  @ALL @PRIMITIVE @RPTKO @RPTKO_1
  Scenario: RPTSoloObbligatori
    Given RPT generation RPT_generation_noOptional with datatable vertical
      | identificativoDominio             | #creditor_institution_code_old# |
      | identificativoStazioneRichiedente | #id_station_old#                |
      | dataOraMessaggioRichiesta         | #timedate#                      |
      | dataEsecuzionePagamento           | #date#                          |
      | importoTotaleDaVersare            | 10.00                           |
      | identificativoUnivocoVersamento   | #iuv#                           |
      | codiceContestoPagamento           | CCD01                           |
      | tipoVersamento                    | PO                              |
      | importoSingoloVersamento          | 10.00                           |
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
      | OK                         | $iuv                   | $iuv                        |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station_old#            |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | #psp#                       |
      | identificativoCanale                  | #canale#                    |
      | rpt                                   | $rptAttachment              |
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
