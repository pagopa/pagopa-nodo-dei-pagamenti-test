Feature: process tests for pspInviaCarrelloRPT 343
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1CRPTRESKO @MOD1CRPTRESKO_11
    Scenario Outline: Check faultCode error on non-existent or invalid field
        Given RPT1 generation RPT_generation_full with datatable vertical
            | identificativoDominio             | #intermediarioPA#           |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | #iuv1#                      |
            | codiceContestoPagamento           | CCD01                       |
            | tipoVersamento                    | BBT                         |
            | ibanAddebito                      | IT45R0760103200000000001016 |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical pspInviaCarrelloRPT_resp initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione | KO                       |
            | identificativoCarrello     | $1iuv                    |
            | id                         | IDPSPFNZ                 |
            | faultCode1                 | CANALE_BUSTA_ERRATA      |
            | faultString1               | La busta non è corretta  |
            | faultCode2                 | CANALE_FIRMA_SCONOSCIUTA |
            | faultString2               | La firma è sconosciuta   |
        And <field> with <value> in pspInviaCarrelloRPT
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
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
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check faultCode is <resp_error> of nodoInviaCarrelloRPT response
        Examples:
            | field                          | value | resp_error                 | soapUI test |
            | soapenv:Body                   | Empty | PPT_CANALE_ERRORE_RESPONSE | CRPTRES3    |
            | soapenv:Body                   | None  | PPT_CANALE_ERRORE_RESPONSE | CRPTRES4    |
            | ws:pspInviaCarrelloRPTResponse | Empty | PPT_CANALE_ERRORE_RESPONSE | CRPTRES5    |
            | fault                          | Empty | PPT_CANALE_ERRORE_RESPONSE | CRPTRES6    |
            | faultCode                      | Empty | PPT_CANALE_ERRORE_RESPONSE | CRPTRES8    |
            | faultCode                      | CIAO  | PPT_CANALE_ERRORE_RESPONSE | CRPTRES9    |
            | faultString                    | Empty | PPT_CANALE_ERRORE_RESPONSE | CRPTRES10   |
            | id                             | Empty | PPT_CANALE_ERRORE_RESPONSE | CRPTRES11   |
            | serial                         | CIAO  | PPT_CANALE_ERRORE_RESPONSE | CRPTRES12   |
            | esitoComplessivoOperazione     | None  | PPT_CANALE_ERRORE_RESPONSE | CRPTRES14   |
            | esitoComplessivoOperazione     | CIAO  | PPT_CANALE_ERRORE_RESPONSE | CRPTRES17   |
            | listaErroriRPT                 | Empty | PPT_CANALE_ERRORE_RESPONSE | CRPTRES22   |