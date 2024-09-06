Feature: TEST INSERT
    Background:
        Given systems up

    # test scritti a valle della segnalazione fatta verso pagoPA nella mail con oggetto [External] Modifiche applicative e db per PostgreSQL

    @ALL @FLOW @INSERT @INSERT_1
    Scenario: nodoInviaCarrelloRPT in PPT_CANALE_ERRORE_RESPONSE
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | CCD01                           |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $1iuv                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale#                        |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT response



    @ALL @FLOW @INSERT @INSERT_2
    Scenario: nodoInviaCarrelloRPT ---> nodoInoltroEsito/mod1 in PPT_CANALE_ERRORE_RESPONSE
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | CCD01                           |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoCarrello                | $1iuv                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp_AGID#                      |
            | identificativoIntermediarioPSP        | #broker_AGID#                   |
            | identificativoCanale                  | #canale_AGID_BBT#               |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | rpt                                   | $rptAttachment                  |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check email field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check urlRedirectEC field exists in informazioniPagamento response
        Given from body with datatable vertical inoltroEsitoMod1 initial json inoltroEsito/mod1
            | idPagamento                 | $sessionToken |
            | identificativoPsp           | #psp#         |
            | tipoVersamento              | BP            |
            | identificativoIntermediario | #psp#         |
            | identificativoCanale        | #canale#      |
            | tipoOperazione              | web           |
        When WISP sends REST POST inoltroEsito/mod1_json to nodo-dei-pagamenti
        Then check error is timeout of inoltroEsito/mod1 response


    @ALL @FLOW @INSERT @INSERT_3
    Scenario: nodoInviaRPT ---> nodoInoltroEsito/mod1 in PPT_CANALE_ERRORE_RESPONSE
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | CCD01                           |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp_AGID#                      |
            | identificativoIntermediarioPSP        | #broker_AGID#                   |
            | identificativoCanale                  | #canale_AGID_BBT#               |
            | rpt                                   | $rptAttachment                  |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check email field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check urlRedirectEC field exists in informazioniPagamento response

        Given from body with datatable vertical inoltroEsitoMod1 initial json inoltroEsito/mod1
            | idPagamento                 | $sessionToken |
            | identificativoPsp           | #psp#         |
            | tipoVersamento              | BP            |
            | identificativoIntermediario | #psp#         |
            | identificativoCanale        | #canale#      |
            | tipoOperazione              | web           |
        When WISP sends REST POST inoltroEsito/mod1_json to nodo-dei-pagamenti
        Then check error is timeout of inoltroEsito/mod1 response