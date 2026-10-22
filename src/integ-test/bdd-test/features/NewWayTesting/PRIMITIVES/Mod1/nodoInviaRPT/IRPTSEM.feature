Feature: process tests for nodoInviaRT[IRPTSEM] 328
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_1
    Scenario Outline: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And <tag> with <tagvalue> in nodoInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        Then check faultCode is <error> of nodoInviaRPT response
        Examples:
            | tag                                   | tagvalue                        | error                              | soapUI test |
            | identificativoIntermediarioPA         | ciao                            | PPT_INTERMEDIARIO_PA_SCONOSCIUTO   | IRPTSEM1    |
            | identificativoStazioneIntermediarioPA | sconosciuto                     | PPT_STAZIONE_INT_PA_SCONOSCIUTA    | IRPTSEM3    |
            | identificativoDominio                 | sconosciuto                     | PPT_DOMINIO_SCONOSCIUTO            | IRPTSEM5    |
            | identificativoDominio                 | NOT_ENABLED                     | PPT_DOMINIO_DISABILITATO           | IRPTSEM6    |
            | identificativoDominio                 | 88888888888                     | PPT_SEMANTICA                      | IRPTSEM7    |
            | identificativoUnivocoVersamento       | IUV4066_2018-03-29_08:53:24.152 | PPT_SEMANTICA                      | IRPTSEM8    |
            | codiceContestoPagamento               | CCP01                           | PPT_SEMANTICA                      | IRPTSEM9    |
            | password                              | password01                      | PPT_AUTENTICAZIONE                 | IRPTSEM10   |
            | identificativoPSP                     | sconosciuto                     | PPT_PSP_SCONOSCIUTO                | IRPTSEM11   |
            | identificativoPSP                     | NOT_ENABLED                     | PPT_PSP_DISABILITATO               | IRPTSEM12   |
            | identificativoIntermediarioPSP        | sconosciuto                     | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  | IRPTSEM13   |
            | identificativoIntermediarioPSP        | INT_NOT_ENABLED                 | PPT_INTERMEDIARIO_PSP_DISABILITATO | IRPTSEM14   |
            | identificativoCanale                  | sconosciuto                     | PPT_CANALE_SCONOSCIUTO             | IRPTSEM15   |
            | identificativoCanale                  | CANALE_NOT_ENABLED              | PPT_CANALE_DISABILITATO            | IRPTSEM19   |
            | identificativoPSP                     | 40000000001                     | PPT_AUTORIZZAZIONE                 | IRPTSEM21   |
            | identificativoIntermediarioPSP        | 80000000001                     | PPT_AUTORIZZAZIONE                 | IRPTSEM21.1 |


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_2
    #IRPTSEM2
    Scenario: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediario_disabled#        |
            | identificativoStazioneIntermediarioPA | #id_station_int_disabled#       |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_3
    #IRPTSEM4
    Scenario: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_disabled#           |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_4
    #IRPTSEM22_siMock
    Scenario: process tests for nodoInviaRT
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv1#                          |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RPT2 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | #ccp2#                          |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RPT3 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | $2ccp                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rpt1Attachment                 |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
            | OK                         | $1iuv                  | idBruciatura=$1iuv          |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | $2ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rpt2Attachment                 |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
            | OK                         | $2ccp                  | idBruciatura=$2ccp          |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTOK @MOD1SEMIRPTOK_1
    # RPTSEM22_conRT
    Scenario: process tests for nodoInviaRT
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv1#                          |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RPT2 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RPT3 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | #ccp3#                          |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And RT1 generation RT_generation_full with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | identificativoUnivocoRiscossione  | $1iuv                           |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
            | esitoSingoloPagamento             | TUTTO_OK                        |
            | dataEsitoSingoloPagamento         | #date#                          |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rpt1Attachment                 |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
            | OK                         | $1iuv                  | idBruciatura=$1iuv          |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rpt2Attachment                 |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_RPT_DUPLICATA of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rt1Attachment                  |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
            | OK                         | $1iuv                  | idBruciatura=$1iuv          |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        Given from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | $3ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rpt3Attachment                 |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
            | OK                         | $3ccp                  | idBruciatura=$3ccp          |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_7
    #IRPTSEM23
    Scenario: process tests for nodoInviaRT
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | 2050-01-01                      |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | #iuv#                           |
            | codiceContestoPagamento           | CCD01                           |
            | tipoVersamento                    | BBT                             |
            | ibanAddebito                      | IT96R0123451234512345678904     |
            | ibanAccredito                     | IT45R0760103200000000001016     |
            | ibanAppoggio                      | IT96R0123454321000000012345     |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SEMANTICA of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTOK @MOD1SEMIRPTOK_2
    #IRPTSEM20
    Scenario: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
            | OK                         | $iuv                   | idBruciatura=$iuv           |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_8
    #IRPTSEM16
    Scenario: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT_irrag initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_CANALE_IRRAGGIUNGIBILE of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_9
    #IRPTSEM17
    Scenario: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT_delay initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_CANALE_TIMEOUT of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SEMIRPTKO @MOD1SEMIRPTKO_10
    Scenario: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | 91000000001_04                  |
            | rpt                                   | $rptAttachment                  |
        And from body with datatable horizontal pspInviaRPT_delay initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello                        | parametriPagamentoImmediato                                |
            | OK                         | $nodoInviaRPT.identificativoUnivocoVersamento | idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response