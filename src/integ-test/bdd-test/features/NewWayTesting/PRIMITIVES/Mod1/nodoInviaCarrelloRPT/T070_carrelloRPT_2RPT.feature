Feature: T070_carrelloRPT_2RPT 595

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_17
    Scenario: carrelloRPT_2RPT
        Given RPT1 body generation RPT_generation_with_2_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 12.40                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BP                          |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 6.20                        |
        And pay_i:soggettoVersante with None in rpt1AttachmentBody
        And RPT1 rpt1AttachmentBody to base64
        And RPT2 body generation RPT_generation_with_2_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 12.40                       |
            | identificativoUnivocoVersamento   | #iuv2#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 6.20                        |
        And pay_i:soggettoVersante with None in rpt2AttachmentBody
        And RPT2 rpt2AttachmentBody to base64
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
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
        And check url field exists in nodoInviaCarrelloRPT response