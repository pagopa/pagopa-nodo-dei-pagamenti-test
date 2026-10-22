Feature: process tests for pspInviaCarrelloRPT[CRPTRES13] 339
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MODCRPTRESKO @MODCRPTRESKO_4
    Scenario: tests for pspInviaCarrelloRPT
        Given RPT generation RPT_generation_complete with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
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
        And from body with datatable vertical pspInviaCarrelloRPT_malformed_2faultRponse initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $iuv                     |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #intermediarioPA#               |
            | identificativoStazioneIntermediarioPA | #id_station#                    |
            | identificativoCarrello                | $iuv                            |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canaleRtPush#                  |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response
