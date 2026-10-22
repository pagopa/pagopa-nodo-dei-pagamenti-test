Feature: process tests for nodoInviaCarrelloRPT[CRPTSEM] 326
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_1
    Scenario: process tests for nodoInviaCarrelloRPT - 1
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        Given from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_ID_CARRELLO_DUPLICATO of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_2
    Scenario Outline: process tests for nodoInviaCarrelloRPT - 2
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And <tag> with <tagvalue> in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoInviaCarrelloRPT response
        Examples:
            | tag                                   | tagvalue           | error                              | soapUI test |
            | identificativoIntermediarioPA         | intermediarioPA    | PPT_INTERMEDIARIO_PA_SCONOSCIUTO   | CRPTSEM2    |
            | identificativoStazioneIntermediarioPA | idIntermediario1   | PPT_STAZIONE_INT_PA_SCONOSCIUTA    | CRPTSEM4    |
            | password                              | password01         | PPT_AUTENTICAZIONE                 | CRPTSEM6    |
            | identificativoPSP                     | sconosciuto        | PPT_PSP_SCONOSCIUTO                | CRPTSEM7    |
            | identificativoPSP                     | NOT_ENABLED        | PPT_PSP_DISABILITATO               | CRPTSEM8    |
            | identificativoIntermediarioPSP        | sconosciuto        | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | CRPTSEM9    |
            | identificativoIntermediarioPSP        | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO | CRPTSEM10   |
            | identificativoCanale                  | sconosciuto        | PPT_CANALE_SCONOSCIUTO             | CRPTSEM11   |
            | identificativoCanale                  | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            | CRPTSEM15   |
            | identificativoDominio                 | 88888888888        | PPT_SEMANTICA                      | CRPTSEM18   |
            | identificativoUnivocoVersamento       | iuv                | PPT_SEMANTICA                      | CRPTSEM19   |
            | codiceContestoPagamento               | CCD0111111         | PPT_SEMANTICA                      | CRPTSEM20   |


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_3
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM3
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | INT_NOT_ENABLED                 |
            | identificativoStazioneIntermediarioPA | STZ_INT_NOT_ENABLED             |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_4
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM22
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        Given from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv-2                          |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_RPT_DUPLICATA of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_5
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM23
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        Given from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTORIZZAZIONE of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTOK @MOD1SEMCRPTOK_6
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM24
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv1#                          |
            | codiceContestoPagamento           | #ccp1#                          |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT96R0123454321000000012345     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RPT2 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv2#                          |
            | codiceContestoPagamento           | #ccp2#                          |
            | tipoVersamento                    | AD                              |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT96R0123454321000000012345     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $1iuv                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio1                | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento1      | $1iuv                           |
            | codiceContestoPagamento1              | $1ccp                           |
            | rpt1                                  | $rpt1Attachment                 |
            | identificativoDominio2                | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento2      | $2iuv                           |
            | codiceContestoPagamento2              | $2ccp                           |
            | rpt2                                  | $rpt2Attachment                 |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_7
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM25
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv1#                          |
            | codiceContestoPagamento           | #ccp1#                          |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT96R0123454321000000012345     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RPT2 generation RPT_generation_pagatore_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv2#                          |
            | codiceContestoPagamento           | #ccp2#                          |
            | tipoVersamento                    | AD                              |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT96R0123454321000000012345     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
            | codiceIdentificativoUnivoco       | RCCGLD09P09H512E                |
            | anagraficaVersante                | Gesualdo;Riccitelli1            |
            | civicoVersante                    | 113                             |
            | capVersante                       | 00185                           |
            | e-mailVersante                    | gesualdo.riccitelli1@poste.it   |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $1iuv                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio1                | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento1      | $1iuv                           |
            | codiceContestoPagamento1              | $1ccp                           |
            | rpt1                                  | $rpt1Attachment                 |
            | identificativoDominio2                | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento2      | $2iuv                           |
            | codiceContestoPagamento2              | $2ccp                           |
            | rpt2                                  | $rpt2Attachment                 |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_SEMANTICA of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_8
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM12
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_irrag initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_IRRAGGIUNGIBILE of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_9
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM13
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_delay initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | delay                       | 10000                                                     |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_TIMEOUT of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_10
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM14
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And esitoComplessivoOperazione with Empty in pspInviaCarrelloRPT
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_11
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM5
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_tipofirma initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediario_stz_disabled#    |
            | identificativoStazioneIntermediarioPA | #id_station_disabled#           |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | tipoFirma                             | 0                               |
            | rpt                                   | $rptAttachment                  |
        And tipoFirma with Empty in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_12
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM16
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | sconosciuto                 |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | sconosciuto                     |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_13
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM17
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | NOT_ENABLED                 |
            | identificativoStazioneRichiedente | #id_station_old#            |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv#                       |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | NOT_ENABLED                     |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_DISABILITATO of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTOK @MOD1SEMCRPTOK_14
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM21
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT_tipofirma initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | tipoFirma                             | 1                               |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_15
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSEM26
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTORIZZAZIONE of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTOK @MOD1SEMCRPTOK_16
    Scenario Outline: process tests for nodoInviaCarrelloRPT - CRPTSEM27
        Given RPT body generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And <tag> with <tag_value> in rptAttachmentBody
        And RPT rptAttachmentBody to base64
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        Examples:
            | tag                    | tag_value | soapUI test |
            | pay_i:soggettoVersante | None      | CRPTSEM27   |


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCRPTKO @MOD1SEMCRPTKO_17
    Scenario Outline: process tests for nodoInviaCarrelloRPT - CRPTSEM28
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv1#                          |
            | codiceContestoPagamento           | #ccp1#                          |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT96R0123454321000000012345     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RPT2 body generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv2#                          |
            | codiceContestoPagamento           | #ccp2#                          |
            | tipoVersamento                    | AD                              |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT96R0123454321000000012345     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And <tag> with <tag_value> in rpt2AttachmentBody
        And RPT2 rpt2AttachmentBody to base64
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $1iuv                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio1                | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento1      | $1iuv                           |
            | codiceContestoPagamento1              | $1ccp                           |
            | rpt1                                  | $rpt1Attachment                 |
            | identificativoDominio2                | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento2      | $2iuv                           |
            | codiceContestoPagamento2              | $2ccp                           |
            | rpt2                                  | $rpt2Attachment                 |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SEMANTICA of nodoInviaCarrelloRPT response
        Examples:
            | tag                    | tag_value | soapUI test |
            | pay_i:soggettoVersante | None      | CRPTSEM28   |
