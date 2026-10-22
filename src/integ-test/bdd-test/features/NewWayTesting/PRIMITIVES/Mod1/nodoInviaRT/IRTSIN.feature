Feature: process tests for nodoInviaRT[IRTSIN] 330
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTKO @MOD1SINIRTKO_1
    Scenario Outline: tests for nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRT_NO_forzaControlloSegno initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | INVIA_RT_SINTASSI               |
            | codiceContestoPagamento         | CCD01                           |
            | rt                              | $rt1Attachment                  |
        And <attribute> set <value> for <elem> in nodoInviaRT
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRT response
        Examples:
            | elem             | attribute     | value                                     | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | IRTSIN1     |



    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTKO @MOD1SINIRTKO_2
    Scenario Outline: tests for nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRT_NO_forzaControlloSegno initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | INVIA_RT_SINTASSI               |
            | codiceContestoPagamento         | CCD01                           |
            | rt                              | $rt1Attachment                  |
        And <tag> with <tagvalue> in nodoInviaRT
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoInviaRT response
        Examples:
            | tag                             | tagvalue                             | error                 | soapUI test |
            | soapenv:Body                    | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN2     |
            | soapenv:Body                    | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN3     |
            | identificativoIntermediarioPSP  | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN4     |
            | identificativoIntermediarioPSP  | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN5     |
            | identificativoPSP               | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | PPT_SINTASSI_EXTRAXSD | IRTSIN6     |
            | identificativoCanale            | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN7     |
            | identificativoCanale            | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN8     |
            | identificativoCanale            | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | PPT_SINTASSI_EXTRAXSD | IRTSIN9     |
            | password                        | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN10    |
            | password                        | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN11    |
            | password                        | pwdpwdp                              | PPT_SINTASSI_EXTRAXSD | IRTSIN12    |
            | password                        | pwdpwdpwdpwdpwdp                     | PPT_SINTASSI_EXTRAXSD | IRTSIN13    |
            | identificativoPSP               | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN14    |
            | identificativoPSP               | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN15    |
            | identificativoPSP               | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | PPT_SINTASSI_EXTRAXSD | IRTSIN16    |
            | identificativoDominio           | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN17    |
            | identificativoDominio           | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN18    |
            | identificativoDominio           | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | PPT_SINTASSI_EXTRAXSD | IRTSIN19    |
            | identificativoUnivocoVersamento | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN20    |
            | identificativoUnivocoVersamento | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN21    |
            | identificativoPSP               | IUV823567329_2018-05-22_11:34:37.938 | PPT_SINTASSI_EXTRAXSD | IRTSIN22    |
            | codiceContestoPagamento         | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN23    |
            | codiceContestoPagamento         | Empty                                | PPT_SINTASSI_EXTRAXSD | IRTSIN24    |
            | codiceContestoPagamento         | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | PPT_SINTASSI_EXTRAXSD | IRTSIN25    |
            | rt                              | None                                 | PPT_SINTASSI_EXTRAXSD | IRTSIN28    |
            | rt                              | Empty                                | PPT_SINTASSI_XSD      | IRTSIN29    |


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTOK @MOD1SINIRTOK_1
    Scenario Outline: tests for nodoInviaRPT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRT_NO_forzaControlloSegno initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | rt                              | $rt1Attachment                  |
        And <tag> with <tagvalue> in nodoInviaRT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        Examples:
            | tag       | tagvalue | soapUI test |
            | tipoFirma | None     | IRTSIN26    |
            | tipoFirma | 6        | IRTSIN27    |


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTOK @MOD1SINIRTOK_2
    #IRTSIN27.1
    Scenario: tests for nodoInviaRPT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRT_NO_forzaControlloSegno initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | rt                              | $rt1Attachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTKO @MOD1SINIRTKO_3
    #IRTSIN30
    Scenario: tests for nodoInviaRPT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And RT body generation RT_generation_codIdentUnivoco with datatable vertical
            | identificativoDominio             | 90000000001                         |
            | identificativoStazioneRichiedente | 90000000001_01                      |
            | dataOraMessaggioRicevuta          | #timedate#                          |
            | importoTotalePagato               | 1234.56                             |
            | identificativoUnivocoVersamento   | INVIA_RT_SINTASSI                   |
            | identificativoUnivocoRiscossione  | INVIA_RT_SINTASSI                   |
            | CodiceContestoPagamento           | CCD01                               |
            | codiceIdentificativoUnivoco       | CodiceIdentificativoUnivocoBenefici |
            | codiceEsitoPagamento              | 0                                   |
            | singoloImportoPagato              | 1234.56                             |
            | esitoSingoloPagamento             | REJECT                              |
        And remove xml declaration from rtAttachmentBody
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRT_NO_forzaControlloSegno initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | rt                              | $rtAttachmentBody               |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTOK @MOD1SINIRTOK_3
    #IRTSIN32
    Scenario: tests for nodoInviaRPT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRT_NO_forzaControlloSegno initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | rt                              | $rt1Attachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTKO @MOD1SINIRTKO_4
    #IRTSIN33
    Scenario Outline: tests for nodoInviaRPT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rt1Attachment                  |
        And <elem> with <value> in nodoInviaRT
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRT response
        Examples:
            | elem                | value |
            | forzaControlloSegno | Empty |


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTKO @MOD1SINIRTKO_5
    #IRTSIN34
    Scenario: tests for nodoInviaRPT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 5                               |
            | rt                              | $rt1Attachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTOK @MOD1SINIRTOK_4
    #IRTSIN35
    Scenario: tests for nodoInviaRPT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 001                             |
            | rt                              | $rt1Attachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response


    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTKO @MOD1SINIRTKO_6
    #IRTSIN36
    Scenario: tests for nodoInviaRT and nodoInviaRT
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
            | ibanAccredito                     | IT96R0123454321000000012345     |
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
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #intermediarioPAOld# |
            | identificativoStazioneIntermediarioPA | #id_station_old#     |
            | identificativoDominio                 | #intermediarioPAOld# |
            | identificativoUnivocoVersamento       | $1iuv                |
            | codiceContestoPagamento               | CCD01                |
            | password                              | #password#           |
            | identificativoPSP                     | #psp#                |
            | identificativoIntermediarioPSP        | #psp#                |
            | identificativoCanale                  | #canaleRtPush#       |
            | rpt                                   | $rpt1Attachment      |
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | forzaControlloSegno             | 100                             |
            | rt                              | $rt1Attachment                  |
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoInviaRT response



    @ALL @PRIMITIVE @MOD1 @MOD1SINIRTKO @MOD1SINIRTKO_7
    #IRTSIN31
    Scenario: tests for nodoInviaRT and nodoInviaRT
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RT2 generation RT_generation_malformed with datatable vertical
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
        And from body with datatable vertical nodoInviaRT_NO_forzaControlloSegno initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #psp#                           |
            | identificativoCanale            | #canaleRtPush#                  |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | CCD01                           |
            | rt                              | $rt2Attachment                  |
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response