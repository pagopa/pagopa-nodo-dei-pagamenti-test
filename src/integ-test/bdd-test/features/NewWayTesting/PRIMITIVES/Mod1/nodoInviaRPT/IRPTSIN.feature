Feature: process tests for nodoInviaRT[IRPTSIN] 329
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTKO @MOD1SINIRPTKO_1
    #IRPTSIN1
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
        And xmlns:soapenv set http://schemas.xmlsoap.org/ciao/envelope/ for soapenv:Envelope in nodoInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTOK @MOD1SINIRPTOK_1
    #IRPTSIN4
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
        And from body with datatable vertical nodoInviaRPTBody_2PPT initial XML nodoInviaRPT
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


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTKO @MOD1SINIRPTKO_2
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
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
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
            | tag                                   | tagvalue                             | error                 | soapUI test |
            | identificativoIntermediarioPA         | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN5    |
            | identificativoIntermediarioPA         | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN6    |
            | identificativoIntermediarioPA         | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN7    |
            | identificativoStazioneIntermediarioPA | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN8    |
            | identificativoStazioneIntermediarioPA | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN9    |
            | identificativoStazioneIntermediarioPA | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN10   |
            | identificativoDominio                 | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN11   |
            | identificativoDominio                 | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN12   |
            | identificativoDominio                 | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN13   |
            | identificativoUnivocoVersamento       | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN14   |
            | identificativoUnivocoVersamento       | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN15   |
            | identificativoUnivocoVersamento       | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN16   |
            | codiceContestoPagamento               | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN17   |
            | codiceContestoPagamento               | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN18   |
            | codiceContestoPagamento               | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN19   |
            | soapenv:Body                          | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN20   |
            | soapenv:Body                          | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN21   |
            | ws:nodoInviaRPT                       | RemoveParent                         | PPT_SINTASSI_EXTRAXSD | IRPTSIN22   |
            | ws:nodoInviaRPT                       | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN23   |
            | password                              | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN24   |
            | password                              | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN25   |
            | password                              | pwdpwdp                              | PPT_SINTASSI_EXTRAXSD | IRPTSIN26   |
            | password                              | as12df57g8q45er6                     | PPT_SINTASSI_EXTRAXSD | IRPTSIN27   |
            | identificativoPSP                     | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN28   |
            | identificativoPSP                     | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN29   |
            | identificativoPSP                     | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN30   |
            | identificativoIntermediarioPSP        | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN31   |
            | identificativoIntermediarioPSP        | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN31.1 |
            | identificativoIntermediarioPSP        | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN32   |
            | identificativoCanale                  | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN33   |
            | identificativoCanale                  | Empty                                | PPT_SINTASSI_EXTRAXSD | IRPTSIN33.1 |
            | identificativoCanale                  | as12df57g8q45er69t74yuiop45789asw123 | PPT_SINTASSI_EXTRAXSD | IRPTSIN34   |
            | rpt                                   | None                                 | PPT_SINTASSI_EXTRAXSD | IRPTSIN37   |
            | rpt                                   | Empty                                | PPT_SINTASSI_XSD      | IRPTSIN38   |


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTKO @MOD1SINIRPTKO_3
    #IRPTSIN39
    Scenario: process tests for nodoInviaRT
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
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
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
        Then check faultCode is PPT_SINTASSI_XSD of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTKO @MOD1SINIRPTKO_4
    #IRPTSIN40
    Scenario: process tests for nodoInviaRT
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
        And RPT rptAttachmentBody to base64
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old# |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rptAttachmentBody              |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTKO @MOD1SINIRPTKO_5
    #IRPTSIN41
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
        And from body with datatable vertical nodoInviaRPTBody_malformed initial XML nodoInviaRPT
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
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTKO @MOD1SINIRPTKO_7
    #IRPTSIN43
    Scenario: process tests for nodoInviaRT
        Given RPT generation RPT_generation_nestedBody with datatable vertical
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
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
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
        And xmlns:soapenv set http://schemas.xmlsoap.org/ciao/envelope/ for soapenv:Envelope in nodoInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRPTOK @MOD1SINIRPTOK_2
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
        And from body with datatable vertical nodoInviaRPT_tipoFirma initial XML nodoInviaRPT
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
            | tipoFirma                             | 1                               |
        And from body with datatable horizontal pspInviaRPT initial XML pspInviaRPT
            | esitoComplessivoOperazione | identificativoCarrello | parametriPagamentoImmediato |
            | OK                         | $iuv                   | idBruciatura=$iuv           |
        And <tag> with <tagvalue> in nodoInviaRPT
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Examples:
            | tag       | tagvalue | soapUI test |
            | tipoFirma | None     | IRPTSIN35   |
            | tipoFirma | Empty    | IRPTSIN35.1 |
            | tipoFirma | 9        | IRPTSIN36   |