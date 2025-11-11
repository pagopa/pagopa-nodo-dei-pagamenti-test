Feature: T001_CarrelloRPT_4RPT_5versamenti 507

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1VALNICROK @MOD1VALNICROK_3
    Scenario: CarrelloRPT_4RPT_5versamenti
        Given RPT1 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And pay_i:soggettoVersante with None in rpt1AttachmentBody
        And RPT rpt1AttachmentBody to base64 as rpt1Attachment
        And RPT2 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv2#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And pay_i:soggettoVersante with None in rpt2AttachmentBody
        And RPT rpt2AttachmentBody to base64 as rpt2Attachment
        And RPT3 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv3#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And pay_i:soggettoVersante with None in rpt3AttachmentBody
        And RPT rpt3AttachmentBody to base64 as rpt3Attachment
        And RPT4 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv4#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And pay_i:soggettoVersante with None in rpt4AttachmentBody
        And RPT rpt4AttachmentBody to base64 as rpt4Attachment
        And from body with datatable vertical nodoInviaCarrelloRPT_4elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #CARRELLO#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | identificativoDominio1                | #creditor_institution_code# |
            | identificativoUnivocoVersamento1      | $1iuv                       |
            | codiceContestoPagamento1              | CCD01                       |
            | rpt1                                  | $rpt1Attachment             |
            | identificativoDominio2                | #creditor_institution_code# |
            | identificativoUnivocoVersamento2      | $2iuv                       |
            | codiceContestoPagamento2              | CCD01                       |
            | rpt2                                  | $rpt2Attachment             |
            | identificativoDominio3                | #creditor_institution_code# |
            | identificativoUnivocoVersamento3      | $3iuv                       |
            | codiceContestoPagamento3              | CCD01                       |
            | rpt3                                  | $rpt3Attachment             |
            | identificativoDominio4                | #creditor_institution_code# |
            | identificativoUnivocoVersamento4      | $4iuv                       |
            | codiceContestoPagamento4              | CCD01                       |
            | rpt4                                  | $rpt4Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url field exists in nodoInviaCarrelloRPT response