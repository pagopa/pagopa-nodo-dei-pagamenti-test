Feature: process tests for 5 RPT 5 Versamenti 794

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1INCARPTOK @MOD1INCARPTOK_5
    Scenario: process tests for 5 RPT 5 Versamenti
        Given RPT1 generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT45R0760103200000000001016 |
            | importoSingoloVersamento          | 1.50                        |
        And RPT2 generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv2#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT45R0760103200000000001016 |
            | importoSingoloVersamento          | 1.50                        |
        And RPT3 generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv3#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT45R0760103200000000001016 |
            | importoSingoloVersamento          | 1.50                        |
        And RPT4 generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv4#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT45R0760103200000000001016 |
            | importoSingoloVersamento          | 1.50                        |
        And RPT5 generation RPT_generation_with_5_payments with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 7.50                        |
            | identificativoUnivocoVersamento   | #iuv5#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123454321000000012345 |
            | ibanAccredito                     | IT96R0123454321000000012345 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 1.50                        |
        And from body with datatable vertical nodoInviaCarrelloRPT_5elemLista initial XML nodoInviaCarrelloRPT
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
            | identificativoDominio5                | #creditor_institution_code# |
            | identificativoUnivocoVersamento5      | $5iuv                       |
            | codiceContestoPagamento5              | CCD01                       |
            | rpt5                                  | $rpt5Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response