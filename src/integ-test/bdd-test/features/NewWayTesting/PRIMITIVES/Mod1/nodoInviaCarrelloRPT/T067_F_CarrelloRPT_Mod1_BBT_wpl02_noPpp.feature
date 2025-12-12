Feature: T067_F_CarrelloRPT_Mod1_BBT_wpl02_noPpp 589
  Background:
    Given systems up


  @ALL @PRIMITIVE @MOD1 @MOD1INCARPTKO @MOD1INCARPTKO_3
  Scenario: T067_F_CarrelloRPT_Mod1_BBT_wpl02_noPpp
    And replace canaleUsato content with WFESP_02_ila content
    And checks the value wpl02 of the record at column ID_SERV_PLUGIN of the table CANALI retrived by the query ID_Serv_Plugin on db nodo_cfg under macro Mod1
    Given RPT generation RPT_generation_complete with datatable vertical
      | identificativoDominio             | #creditor_institution_code# |
      | identificativoStazioneRichiedente | #id_station#                |
      | dataOraMessaggioRichiesta         | #timedate#                  |
      | dataEsecuzionePagamento           | #date#                      |
      | importoTotaleDaVersare            | 15.00                       |
      | identificativoUnivocoVersamento   | #iuv#                       |
      | codiceContestoPagamento           | checkNoPPP                  |
      | tipoVersamento                    | BBT                         |
      | ibanAddebito                      | IT96R0123454321000000012345 |
      | ibanAccredito                     | IT45R0760103200000000001016 |
      | ibanAppoggio                      | IT96R0123454321000000012345 |
      | importoSingoloVersamento          | 15.00                       |
    And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
      | identificativoIntermediarioPA         | #creditor_institution_code# |
      | identificativoStazioneIntermediarioPA | #id_station#                |
      | identificativoCarrello                | #carrello#                  |
      | password                              | #password#                  |
      | identificativoPSP                     | #psp#                       |
      | identificativoIntermediarioPSP        | #psp#                       |
      | identificativoCanale                  | #canale#                    |
      | identificativoDominio                 | #creditor_institution_code# |
      | identificativoUnivocoVersamento       | $iuv                        |
      | codiceContestoPagamento               | checkNoPPP                  |
      | rpt                                   | $rptAttachment              |
    And from body with datatable horizontal pspInviaCarrelloRPT_KO initial XML pspInviaCarrelloRPT
      | esitoComplessivoOperazione | faultCode           | faultString  | id      |
      | KO                         | CANALE_SYSTEM_ERROR | system error | wrapper |
    And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
    When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check faultCode is PPT_CANALE_ERRORE of nodoInviaCarrelloRPT response