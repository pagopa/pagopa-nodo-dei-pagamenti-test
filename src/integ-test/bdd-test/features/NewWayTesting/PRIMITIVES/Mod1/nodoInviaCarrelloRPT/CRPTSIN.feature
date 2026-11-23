Feature: process tests for nodoInviaCarrelloRPT[CRPTSIN] 327
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_1
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSINSunnyDay
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


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_2
    Scenario Outline: process tests for nodoInviaCarrelloRPT - CRPTSIN1
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
        And <attribute> set <value> for <elem> in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoInviaCarrelloRPT response
        Examples:
            | elem             | attribute     | value                                     | error                 | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | PPT_SINTASSI_EXTRAXSD | CRPTSIN1    |


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_3
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN3
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
        And from body with datatable vertical nodoInviaCarrelloRPT_malformed initial XML nodoInviaCarrelloRPT
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
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response



    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_4
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN3
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
        And from body with datatable vertical nodoInviaCarrelloRPT_2intestazioneCarrello initial XML nodoInviaCarrelloRPT
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


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_5
    Scenario Outline: process tests for nodoInviaCarrelloRPT
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
        And from body with datatable vertical nodoInviaCarrelloRPT_full initial XML nodoInviaCarrelloRPT
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
            | requireLightPayment                   |                                 |
        And <tag> with <tagvalue> in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoInviaCarrelloRPT response
        Examples:
            | tag                                   | tagvalue                             | error                 | soapUI test |
            | identificativoIntermediarioPA         | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN5    |
            | identificativoIntermediarioPA         | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN6    |
            | identificativoIntermediarioPA         | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN7    |
            | identificativoStazioneIntermediarioPA | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN8    |
            | identificativoStazioneIntermediarioPA | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN9    |
            | identificativoStazioneIntermediarioPA | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN10   |
            | identificativoCarrello                | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN11   |
            | identificativoCarrello                | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN12   |
            | identificativoCarrello                | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN13   |
            | soapenv:Body                          | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN14   |
            | soapenv:Body                          | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN15   |
            | ws:nodoInviaCarrelloRPT               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN16   |
            | password                              | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN17   |
            | password                              | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN18   |
            | password                              | passwor                              | PPT_SINTASSI_EXTRAXSD | CRPTSIN19   |
            | password                              | passworpasswordd                     | PPT_SINTASSI_EXTRAXSD | CRPTSIN20   |
            | identificativoPSP                     | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN21   |
            | identificativoPSP                     | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN22   |
            | identificativoPSP                     | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN23   |
            | identificativoIntermediarioPSP        | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN24   |
            | identificativoIntermediarioPSP        | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN24.1 |
            | identificativoIntermediarioPSP        | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN25   |
            | identificativoCanale                  | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN26   |
            | identificativoCanale                  | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN26.1 |
            | identificativoCanale                  | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN27   |
            | listaRPT                              | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN28   |
            | listaRPT                              | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN29   |
            | listaRPT                              | RemoveParent                         | PPT_SINTASSI_EXTRAXSD | CRPTSIN29.1 |
            | identificativoDominio                 | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN30   |
            | identificativoDominio                 | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN31   |
            | identificativoDominio                 | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN32   |
            | identificativoUnivocoVersamento       | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN33   |
            | identificativoUnivocoVersamento       | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN34   |
            | identificativoUnivocoVersamento       | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN35   |
            | codiceContestoPagamento               | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN36   |
            | codiceContestoPagamento               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN37   |
            | codiceContestoPagamento               | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | CRPTSIN38   |
            | codiceContestoPagamento               | None                                 | PPT_SINTASSI_EXTRAXSD | CRPTSIN41   |
            | codiceContestoPagamento               | Empty                                | PPT_SINTASSI_EXTRAXSD | CRPTSIN42   |
            | requireLightPayment                   | 4                                    | PPT_SINTASSI_EXTRAXSD | CRPTSIN47   |


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_6
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN39
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


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_7
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN39.1
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
            | rpt                                   | $rptAttachment                  |
            | tipoFirma                             |                                 |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_8
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN40
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
            | rpt                                   | $rptAttachment                  |
            | tipoFirma                             | 1                               |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_9
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN43
        Given RPT generation RPT_generation_malformed with datatable vertical
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
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_XSD of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_10
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN44
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
            | rpt                                   | $rptAttachmentBody              |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_11
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN45
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


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_12
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN48
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
        And from body with datatable vertical nodoInviaCarrelloRPT_full initial XML nodoInviaCarrelloRPT
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
            | requireLightPayment                   | 00                              |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTOK @MOD1SINCRPTOK_13
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN49
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


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_14
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN50
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
        And from body with datatable vertical nodoInviaCarrelloRPT_cod_codiceConvenzione initial XML nodoInviaCarrelloRPT
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
            | codiceConvenzione                     | 00                              |
        And codiceConvenzione with Empty in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_15
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN51
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
        And from body with datatable vertical nodoInviaCarrelloRPT_cod_codiceConvenzione initial XML nodoInviaCarrelloRPT
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
            | codiceConvenzione                     | d5e9                            |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_16
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN52
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
        And from body with datatable vertical nodoInviaCarrelloRPT_cod_codiceConvenzione initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old#      |
            | identificativoStazioneIntermediarioPA | #id_station_old#                     |
            | identificativoCarrello                | $iuv                                 |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #psp#                                |
            | identificativoCanale                  | #canale#                             |
            | identificativoDominio                 | #creditor_institution_code_old#      |
            | identificativoUnivocoVersamento       | $iuv                                 |
            | codiceContestoPagamento               | CCD01                                |
            | rpt                                   | $rptAttachment                       |
            | codiceConvenzione                     | as12df57g8q45er69t74yuiop45789asw123 |
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINCRPTKO @MOD1SINCRPTKO_17
    Scenario: process tests for nodoInviaCarrelloRPT - CRPTSIN46
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
        And from body with datatable vertical nodoInviaCarrelloRPT_full initial XML nodoInviaCarrelloRPT
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
            | requireLightPayment                   | 00                              |
        And requireLightPayment with Empty in nodoInviaCarrelloRPT
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaCarrelloRPT response