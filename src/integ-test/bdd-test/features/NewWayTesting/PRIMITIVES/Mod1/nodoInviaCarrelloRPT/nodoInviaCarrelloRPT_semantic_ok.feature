Feature: checks semantic OK for nodoInviaCarrelloRPT 911

   Background:
      Given systems up

   # [SEM_MB_16]
   @ALL @PRIMITIVE @MOD1 @MOD1SEMNICROK @MOD1SEMNICROK_1
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
         | identificativoDominio             | #creditor_institution_code# |
         | identificativoStazioneRichiedente | #id_station#                |
         | dataOraMessaggioRichiesta         | #timedate#                  |
         | dataEsecuzionePagamento           | #date#                      |
         | importoTotaleDaVersare            | 1.50                        |
         | identificativoUnivocoVersamento   | #iuv2#                      |
         | codiceContestoPagamento           | $1ccp                       |
         | tipoVersamento                    | BBT                         |
         | ibanAddebito                      | IT96R0123451234512345678904 |
         | ibanAccredito                     | IT45R0760103200000000001016 |
         | ibanAppoggio                      | IT45R0760103200000000001016 |
         | importoSingoloVersamento          | 1.50                        |
      And from body with datatable vertical paaInviaRT initial XML paaInviaRT
         | esito | OK |
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista_multibeneficiario_full initial XML nodoInviaCarrelloRPT
         | identificativoIntermediarioPA         | #creditor_institution_code# |
         | identificativoStazioneIntermediarioPA | #id_station#                |
         | identificativoCarrello                | $1ccp                       |
         | password                              | #password#                  |
         | identificativoPSP                     | #psp#                       |
         | identificativoIntermediarioPSP        | #psp#                       |
         | identificativoCanale                  | #canale#                    |
         | identificativoDominio1                | #creditor_institution_code# |
         | identificativoUnivocoVersamento1      | $1iuv                       |
         | codiceContestoPagamento1              | $1ccp                       |
         | rpt1                                  | $rpt1Attachment             |
         | identificativoDominio2                | #creditor_institution_code# |
         | identificativoUnivocoVersamento2      | $2iuv                       |
         | codiceContestoPagamento2              | $1ccp                       |
         | rpt2                                  | $rpt2Attachment             |
         | requireLightPayment                   | 01                          |
         | multiBeneficiario                     | 1                           |
      And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
         | esitoComplessivoOperazione  | OK                                                        |
         | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
         | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
      And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
      And multiBeneficiario with false in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response