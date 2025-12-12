Feature: T001_CarrelloRPT_4RPT_5versamenti_validazioneXSD 508

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_2
    Scenario Outline: CarrelloRPT_4RPT_5versamenti_validazioneXSD
        Given RPT1 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | validateXSD                 |
            | codiceContestoPagamento           | #ccp1#                      |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And <elem2> with <value2> in rpt1AttachmentBody
        And <elem1> with <value1> in rpt1AttachmentBody
        And RPT1 rpt1AttachmentBody to base64
        And RPT2 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | validateXSD                 |
            | codiceContestoPagamento           | #ccp2#                      |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And <elem2> with <value2> in rpt2AttachmentBody
        And <elem1> with <value1> in rpt2AttachmentBody
        And RPT2 rpt2AttachmentBody to base64
        And RPT3 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | validateXSD                 |
            | codiceContestoPagamento           | #ccp3#                      |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And <elem2> with <value2> in rpt3AttachmentBody
        And <elem1> with <value1> in rpt3AttachmentBody
        And RPT3 rpt3AttachmentBody to base64
        And RPT4 body generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | validateXSD                 |
            | codiceContestoPagamento           | #ccp4#                      |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And <elem2> with <value2> in rpt4AttachmentBody
        And <elem1> with <value1> in rpt4AttachmentBody
        And RPT4 rpt4AttachmentBody to base64
        And from body with datatable vertical nodoInviaCarrelloRPT_4elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | #carrello#                  |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | identificativoDominio1                | #creditor_institution_code# |
            | identificativoUnivocoVersamento1      | validateXSD                 |
            | codiceContestoPagamento1              | $1ccp                       |
            | rpt1                                  | $rpt1Attachment             |
            | identificativoDominio2                | #creditor_institution_code# |
            | identificativoUnivocoVersamento2      | validateXSD                 |
            | codiceContestoPagamento2              | $2ccp                       |
            | rpt2                                  | $rpt2Attachment             |
            | identificativoDominio3                | #creditor_institution_code# |
            | identificativoUnivocoVersamento3      | validateXSD                 |
            | codiceContestoPagamento3              | $3ccp                       |
            | rpt3                                  | $rpt3Attachment             |
            | identificativoDominio4                | #creditor_institution_code# |
            | identificativoUnivocoVersamento4      | validateXSD                 |
            | codiceContestoPagamento4              | $4ccp                       |
            | rpt4                                  | $rpt4Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url field exists in nodoInviaCarrelloRPT response
        Examples:
            | elem1                             | value1      | elem2                  | value2 |
            | pay_i:codiceIdentificativoUnivoco | 11111111117 | pay_i:soggettoVersante | None   |