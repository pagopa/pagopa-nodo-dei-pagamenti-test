Feature: process tests for pspInviaCarrelloRPT 344
    Background:
        Given systems up
        And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_12
    Scenario: tests for pspInviaCarrelloRPT
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | OK                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And serial with None in pspInviaCarrelloRPT
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_13
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES23]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2 | value2            | soapUI test |
            | serial | removeOccurrence,1 | fault | clearOccurrence,2 | CRPTRES23   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_14
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES24]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2 | value2                   | soapUI test |
            | serial | removeOccurrence,1 | fault | removeParentOccurrence,2 | CRPTRES24   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_15
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES25]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2     | value2             | soapUI test |
            | serial | removeOccurrence,1 | faultCode | removeOccurrence,2 | CRPTRES25   |

    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_16
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES26]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2     | value2                  | soapUI test |
            | serial | removeOccurrence,1 | faultCode | changeOccurrence,2,CIAO | CRPTRES26   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_17
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES27]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2       | value2             | soapUI test |
            | serial | removeOccurrence,1 | faultString | removeOccurrence,2 | CRPTRES27   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_18
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES28]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2 | value2             | soapUI test |
            | serial | removeOccurrence,1 | id    | removeOccurrence,2 | CRPTRES28   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_20
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES29]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZabc              |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2 | value2                         | soapUI test |
            | serial | removeOccurrence,1 | id    | changeOccurrence,2,IDPSPFNZabc | CRPTRES29   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_21
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES30]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1             | elem2 | value2                         | soapUI test |
            | serial | removeOccurrence,1 | id    | changeOccurrence,2,IDPSPFNZabc | CRPTRES30   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_22
    Scenario Outline: Execute nodoInviaCarrelloRPT request [CRPTRES31]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And replace in pspInviaCarrelloRPT tag <elem1> with <value1>
        And replace in pspInviaCarrelloRPT tag <elem2> with <value2>
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
        Examples:
            | elem1  | value1                  | elem2  | value2             | soapUI test |
            | serial | changeOccurrence,2,CIAO | serial | removeOccurrence,1 | CRPTRES31   |


    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_23
    Scenario: Execute nodoInviaCarrelloRPT request [CRPTRES32]
        Given RPT1 generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT96R0123451234512345678904 |
            | ibanAccredito                     | IT45R0760103200000000001016 |
            | ibanAppoggio                      | IT96R0123454321000000012345 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#           |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoCarrello                | $1iuv                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canaleRtPush#              |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | rpt                                   | $rpt1Attachment             |
        And from body with datatable vertical pspInviaCarrelloRPT_resp_2Fault initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                      |
            | identificativoCarrello     | $1iuv                   |
            | id                         | IDPSPFNZ                |
            | faultCode                  | CANALE_BUSTA_ERRATA     |
            | faultString                | La busta non è corretta |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response