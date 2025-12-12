Feature: T074_CarrelloRPT_autSogg=OTH 598
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_20
    Scenario: CarrelloRPT_autSogg=OTH
        Given RPT1 body generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And pay_i:autenticazioneSoggetto with OTH in rpt1AttachmentBody
        And RPT1 rpt1AttachmentBody to base64
        And RPT2 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | Err$1iuv                    |
            | codiceContestoPagamento           | CCD02                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrello#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp_AGID#                  |
            | identificativoIntermediarioPSP        | #broker_AGID#               |
            | identificativoCanale                  | #canale_AGID_BBT#           |
            | identificativoDominio1                | #creditor_institution_code# |
            | identificativoUnivocoVersamento1      | $1iuv                       |
            | codiceContestoPagamento1              | CCD01                       |
            | rpt1                                  | $rpt1Attachment             |
            | identificativoDominio2                | #creditor_institution_code# |
            | identificativoUnivocoVersamento2      | Err$1iuv                    |
            | codiceContestoPagamento2              | CCD02                       |
            | rpt2                                  | $rpt2Attachment             |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
