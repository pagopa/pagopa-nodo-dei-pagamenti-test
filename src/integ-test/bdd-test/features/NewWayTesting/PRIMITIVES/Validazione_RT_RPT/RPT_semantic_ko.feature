Feature: Syntax checks for SEMANTIC RPT 1578

  Background:
    Given systems up


  @ALL @PRIMITIVE @RPTSEMKO @RPTSEMKO_1
  # [RPTSEM7]
  # pay_i:tipoVersamento with PO in RPT
  Scenario Outline: Check faultCode PPT_AUTORIZZAZIONE error on invalid RPT tag [RPTSEM7]
    Given RPT body generation RPT_generation with datatable vertical
      | identificativoDominio             | #creditor_institution_code_old# |
      | identificativoStazioneRichiedente | #id_station#                    |
      | dataOraMessaggioRichiesta         | #timedate#                      |
      | dataEsecuzionePagamento           | #date#                          |
      | importoTotaleDaVersare            | 1.01                            |
      | identificativoUnivocoVersamento   | #iuv#                           |
      | codiceContestoPagamento           | CCD01                           |
      | tipoVersamento                    | PO                              |
      | importoSingoloVersamento          | 1.01                            |
      | anagraficaPagatore                | Gesualdo;Riccitelli             |
      | indirizzoPagatore                 | via del gesu                    |
      | civicoPagatore                    | 11                              |
    And <elem> with <value> in rptAttachmentBody
    And RPT rptAttachmentBody to base64
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
      | OK                         | $iuv                   | $iuv                        |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | 91000000001                 |
      | identificativoCanale                  | 91000000001_04              |
      | rpt                                   | $rptAttachment              |
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
    Examples:
      | elem                 | value | SoapUI  |
      | pay_i:tipoVersamento | PO    | RPTSEM7 |


  @ALL @PRIMITIVE @RPTSEMKO @RPTSEMKO_2
  # [RPTSEM18]
  Scenario Outline: Check faultCode PPT_SEMANTICA error on invalid RPT tag [RPTSEM18]
    Given RPT body generation RPT_generation with datatable vertical
      | identificativoDominio             | #creditor_institution_code_old# |
      | identificativoStazioneRichiedente | #id_station#                    |
      | dataOraMessaggioRichiesta         | #timedate#                      |
      | dataEsecuzionePagamento           | #date#                          |
      | importoTotaleDaVersare            | 1.01                            |
      | identificativoUnivocoVersamento   | #iuv#                           |
      | codiceContestoPagamento           | CCD01                           |
      | tipoVersamento                    | PO                              |
      | importoSingoloVersamento          | 1.01                            |
      | anagraficaPagatore                | Gesualdo;Riccitelli             |
      | indirizzoPagatore                 | via del gesu                    |
      | civicoPagatore                    | 11                              |
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
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
    Examples:
      | elem                | value | SoapUI   |
      | pay_i:ibanAccredito | None  | RPTSEM18 |



  @ALL @PRIMITIVE @RPTSEMKO @RPTSEMKO_3
  # [RPTSEM9]
  Scenario Outline: Check faultCode PPT_AUTORIZZAZIONE error on invalid RPT tag [RPTSEM9]
    Given RPT body generation RPT_generation with datatable vertical
      | identificativoDominio             | #creditor_institution_code_old# |
      | identificativoStazioneRichiedente | #id_station#                    |
      | dataOraMessaggioRichiesta         | #timedate#                      |
      | dataEsecuzionePagamento           | #date#                          |
      | importoTotaleDaVersare            | 1.01                            |
      | identificativoUnivocoVersamento   | #iuv#                           |
      | codiceContestoPagamento           | CCD01                           |
      | tipoVersamento                    | PO                              |
      | importoSingoloVersamento          | 1.01                            |
      | anagraficaPagatore                | Gesualdo;Riccitelli             |
      | indirizzoPagatore                 | via del gesu                    |
      | civicoPagatore                    | 11                              |
    And <elem1> with <value1> in rptAttachmentBody
    And <elem2> with <value2> in rptAttachmentBody
    And RPT rptAttachmentBody to base64
    And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
      | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
      | OK                         | $iuv                   | $iuv                        |
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | CCD01                       |
      | password                              | #password#                  |
      | identificativoPSP                     | idPsp1                      |
      | identificativoIntermediarioPSP        | 91000000001                 |
      | identificativoCanale                  | 91000000001_04              |
      | rpt                                   | $rptAttachment              |
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
    Examples:
      | elem1              | value1 | elem2                | value2 | SoapUI  |
      | pay_i:ibanAddebito | None   | pay_i:tipoVersamento | AD     | RPTSEM9 |



  @ALL @PRIMITIVE @RPTSEMKO @RPTSEMKO_4
  # [RPTSEM16]
  Scenario Outline: Check faultCode PPT_AUTORIZZAZIONE error on invalid RPT tag [RPTSEM16]
    Given RPT body generation RPT_generation with datatable vertical
      | identificativoDominio             | #creditor_institution_code_old# |
      | identificativoStazioneRichiedente | #id_station#                    |
      | dataOraMessaggioRichiesta         | #timedate#                      |
      | dataEsecuzionePagamento           | #date#                          |
      | importoTotaleDaVersare            | 1.01                            |
      | identificativoUnivocoVersamento   | #iuv#                           |
      | codiceContestoPagamento           | CCD01                           |
      | tipoVersamento                    | PO                              |
      | importoSingoloVersamento          | 1.01                            |
      | anagraficaPagatore                | Gesualdo;Riccitelli             |
      | indirizzoPagatore                 | via del gesu                    |
      | civicoPagatore                    | 11                              |
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
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_IBAN_NON_CENSITO of nodoInviaRPT response
    Examples:
      | elem                | value                         | SoapUI   |
      | pay_i:ibanAccredito | IT96R0123454321000000012345ZZ | RPTSEM16 |


  @ALL @PRIMITIVE @RPTSEMKO @RPTSEMKO_5
  # [RPTSEM17]
  Scenario: Check faultCode PPT_SEMANTICA error on invalid RPT tag [RPTSEM17]
    Given RPT generation RPT_generation_with_MBD_complete with datatable vertical
      | identificativoDominio             | #creditor_institution_code_old# |
      | identificativoStazioneRichiedente | #id_station#                    |
      | dataOraMessaggioRichiesta         | #timedate#                      |
      | dataEsecuzionePagamento           | #date#                          |
      | importoTotaleDaVersare            | 1.01                            |
      | identificativoUnivocoVersamento   | #iuv#                           |
      | codiceIdentificativoUnivoco       | 11111111117                     |
      | codiceContestoPagamento           | CCD01                           |
      | tipoVersamento                    | PO                              |
      | importoSingoloVersamento          | 1.01                            |
      | commissioneCaricoPA               | 1.25                            |
      | anagraficaPagatore                | Gesualdo;Riccitelli             |
      | indirizzoPagatore                 | via del gesu                    |
      | civicoPagatore                    | 11                              |
    And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
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
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response


  @ALL @PRIMITIVE @RPTSEMKO @RPTSEMKO_6
  # [RPTSEM12]
  Scenario: 2 datiSingoloVersamento + tipoVersamento = PO [RPTSEM12]
    Given RPT generation RPT_generation_with_2_payments with datatable vertical
      | identificativoDominio             | #creditor_institution_code_old# |
      | identificativoStazioneRichiedente | #id_station#                    |
      | dataOraMessaggioRichiesta         | #timedate#                      |
      | dataEsecuzionePagamento           | #date#                          |
      | importoTotaleDaVersare            | 10.00                           |
      | identificativoUnivocoVersamento   | #iuv#                           |
      | codiceContestoPagamento           | CCD01                           |
      | tipoVersamento                    | PO                              |
      | ibanAccredito                     | IT96R0123454321000000012345     |
      | ibanAddebito                      | IT96R0123454321000000012345     |
      | ibanAppoggio                      | IT96R0123454321000000012345     |
      | importoSingoloVersamento          | 2.40                            |
      | anagraficaPagatore                | Gesualdo;Riccitelli             |
      | indirizzoPagatore                 | via del gesu                    |
      | civicoPagatore                    | 11                              |
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
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response