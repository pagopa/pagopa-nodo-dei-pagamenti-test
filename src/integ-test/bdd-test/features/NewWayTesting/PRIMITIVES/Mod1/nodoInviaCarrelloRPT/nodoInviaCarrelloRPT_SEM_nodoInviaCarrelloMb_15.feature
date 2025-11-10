Feature: Semantic checks for nodoInviaCarrelloRPT 921

   Background:
      Given systems up

   # [SEM_MB_15]
   @ALL @PRIMITIVE @MOD1 @MOD1SEMNIVCRKO @MOD1SEMNIVCRKO_1
   Scenario: Semantic checks for nodoInviaCarrelloRPT
      Given RPT1 generation RPT_generation_complete with datatable vertical
         | identificativoDominio             | #creditor_institution_code# |
         | identificativoStazioneRichiedente | #id_station#                |
         | dataOraMessaggioRichiesta         | #timedate#                  |
         | dataEsecuzionePagamento           | #date#                      |
         | importoTotaleDaVersare            | 1.50                        |
         | identificativoUnivocoVersamento   | #iuv1#                      |
         | codiceContestoPagamento           | #ccp1#                      |
         | tipoVersamento                    | BBT                         |
         | ibanAddebito                      | IT96R0123451234512345678904 |
         | ibanAccredito                     | IT96R0123454321000000012345 |
         | ibanAppoggio                      | IT96R0123454321000000012345 |
         | importoSingoloVersamento          | 1.50                        |
      And RPT2 generation RPT_generation_complete with datatable vertical
         | identificativoDominio             | #creditor_institution_code_secondary# |
         | identificativoStazioneRichiedente | #id_station#                          |
         | dataOraMessaggioRichiesta         | #timedate#                            |
         | dataEsecuzionePagamento           | #date#                                |
         | importoTotaleDaVersare            | 1.50                                  |
         | identificativoUnivocoVersamento   | $1iuv                                 |
         | codiceContestoPagamento           | $1ccp                                 |
         | tipoVersamento                    | BBT                                   |
         | ibanAddebito                      | IT96R0123451234512345678904           |
         | ibanAccredito                     | IT96R0123454321000000012345           |
         | ibanAppoggio                      | IT96R0123454321000000012345           |
         | importoSingoloVersamento          | 1.50                                  |
      And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista_multibeneficiario_full initial XML nodoInviaCarrelloRPT
         | identificativoIntermediarioPA         | #intermediarioPA#                     |
         | identificativoStazioneIntermediarioPA | #id_station#                          |
         | identificativoCarrello                | $1ccp                                 |
         | password                              | #password#                            |
         | identificativoPSP                     | #psp#                                 |
         | identificativoIntermediarioPSP        | #psp#                                 |
         | identificativoCanale                  | #canale#                              |
         | identificativoDominio1                | #creditor_institution_code#           |
         | identificativoUnivocoVersamento1      | $1iuv                                 |
         | codiceContestoPagamento1              | $1ccp                                 |
         | rpt1                                  | $rpt1Attachment                       |
         | identificativoDominio2                | #creditor_institution_code_secondary# |
         | identificativoUnivocoVersamento2      | $1iuv                                 |
         | codiceContestoPagamento2              | $1ccp                                 |
         | rpt2                                  | $rpt2Attachment                       |
         | requireLightPayment                   | 01                                    |
         | multiBeneficiario                     | 1                                     |
      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_SEMANTICA of nodoInviaCarrelloRPT response
      And check description is Flag multibeneficiario non disponibile per pagamenti diversi da WISP2 of nodoInviaCarrelloRPT response