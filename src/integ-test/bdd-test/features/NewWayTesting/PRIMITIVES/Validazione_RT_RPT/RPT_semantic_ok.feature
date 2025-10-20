Feature: Semantic checks for nodoInviaRPT - OK 1579

  Background:
    Given systems up


  @ALL @PRIMITIVE @RPTSEMOK @RPTSEMOK_1
  Scenario Outline: Check OK Step Expected
    Given RPT body generation RPT_generation with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | 2022-07-07T11:24:10         |
      | dataEsecuzionePagamento           | 2022-07-07                  |
      | importoTotaleDaVersare            | 1.01                        |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | PO                          |
      | importoSingoloVersamento          | 1.01                        |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And <elem> with <value> in rptAttachmentBody
    And RPT rptAttachmentBody to base64
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
      | OK                         | $iuv                   | $iuv                        |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code#  |
      | identificativoStazioneIntermediarioPA | #id_station#                 |
      | identificativoDominio                 | #creditor_institution_code#  |
      | identificativoUnivocoVersamento       | $iuv                         |
      | codiceContestoPagamento               | CCD01                        |
      | password                              | #password#                   |
      | identificativoPSP                     | #psp#                        |
      | identificativoIntermediarioPSP        | #psp#                        |
      | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP# |
      | rpt                                   | $rptAttachment               |
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    Examples:
      | elem                            | value                       | SoapUI   |
      | pay_i:dataOraMessaggioRichiesta | 2022-07-07T11:24:10         | RPTSEM1  |
      | pay_i:dataEsecuzionePagamento   | 2022-07-08                  | PTSEM4   |
      | pay_i:ibanAccredito             | IT96R0123454321000000012345 | RPTSEM8  |
      | pay_i:causaleVersamento         | /RF/RPTSEM_200000/5.00      | RPTSEM19 |
      | pay_i:causaleVersamento         | /RFS/RPTSEM_200004/5.00     | RPTSEM20 |
      | pay_i:causaleVersamento         | /RFS/RPTSEM_200000/5.00     | RPTSEM21 |
      | pay_i:causaleVersamento         | /RFS/RPTSEM_200000/6.00     | RPTSEM22 |
      | pay_i:causaleVersamento         | /RFS/6.00                   | RPTSEM23 |



  @ALL @PRIMITIVE @RPTSEMOK @RPTSEMOK_2
  Scenario Outline: Check OK Step Expected tag combination
    Given RPT body generation RPT_generation_full with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | 2022-07-07T11:24:10         |
      | dataEsecuzionePagamento           | 2022-07-07                  |
      | importoTotaleDaVersare            | 1.01                        |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | CCD01                       |
      | tipoVersamento                    | PO                          |
      | ibanAccredito                     | IT96R0123454321000000012345 |
      | ibanAddebito                      | IT96R0123454321000000012345 |
      | ibanAppoggio                      | IT96R0123454321000000012345 |
      | importoSingoloVersamento          | 1.01                        |
      | anagraficaPagatore                | Gesualdo;Riccitelli         |
      | indirizzoPagatore                 | via del gesu                |
      | civicoPagatore                    | 11                          |
    And <elem1> with <value1> in rptAttachmentBody
    And <elem2> with <value2> in rptAttachmentBody
    And RPT rptAttachmentBody to base64
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
      | OK                         | $iuv                   | $iuv                        |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code#  |
      | identificativoStazioneIntermediarioPA | #id_station#                 |
      | identificativoDominio                 | #creditor_institution_code#  |
      | identificativoUnivocoVersamento       | $iuv                         |
      | codiceContestoPagamento               | CCD01                        |
      | password                              | #password#                   |
      | identificativoPSP                     | #psp#                        |
      | identificativoIntermediarioPSP        | #psp#                        |
      | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP# |
      | rpt                                   | $rptAttachment               |
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    Examples:
      | elem1                           | value1 | elem2                             | value2 | SoapUI  |
      | pay_i:tipoIdentificativoUnivoco | F      | pay_i:codiceIdentificativoUnivoco | PI     | RPTSEM2 |
      | pay_i:tipoIdentificativoUnivoco | F      | pay_i:codiceIdentificativoUnivoco | PI     | RPTSEM3 |