Feature: TEST INSERT WFESP
    Background:
        Given systems up



    @ALL @FLOW  @INSERT @INSERT_27
    Scenario: FLOW WFESP con: nodoInviaRPT con response Ok della pspInviaRPT xy, nodoInviaRPT2 con stessa identica response del PSP, tutte con stessa stessa configurazione PSP multibeneficiario (INS-27)
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
        And from body with datatable vertical pspInviaRPT_noOptional initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                 |
            | identificativoCarrello      | $1iuv              |
            | parametriPagamentoImmediato | idBruciatura=$1iuv |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT1
            | identificativoIntermediarioPA         | #id_broker_old#                      |
            | identificativoStazioneIntermediarioPA | #id_station_old#                     |
            | identificativoDominio                 | #creditor_institution_code_old#      |
            | identificativoUnivocoVersamento       | $1iuv                                |
            | codiceContestoPagamento               | CCD01                                |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #id_broker_psp#                      |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | rpt                                   | $rptAttachment                       |
        When EC sends SOAP nodoInviaRPT1 to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT1 response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_secondary# |
            | identificativoStazioneRichiedente | #id_station_old#                      |
            | dataOraMessaggioRichiesta         | #timedate#                            |
            | dataEsecuzionePagamento           | #date#                                |
            | importoTotaleDaVersare            | 10.00                                 |
            | identificativoUnivocoVersamento   | $1iuv                                 |
            | codiceContestoPagamento           | CCD01                                 |
            | importoSingoloVersamento          | 10.00                                 |
        And from body with datatable vertical pspInviaRPT_noOptional initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                 |
            | identificativoCarrello      | $1iuv              |
            | parametriPagamentoImmediato | idBruciatura=$1iuv |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT2
            | identificativoIntermediarioPA         | #id_broker_old#                       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | identificativoDominio                 | #creditor_institution_code_secondary# |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | CCD01                                 |
            | password                              | #password#                            |
            | identificativoPSP                     | #psp#                                 |
            | identificativoIntermediarioPSP        | #id_broker_psp#                       |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO#  |
            | rpt                                   | $rptAttachment                        |
        When EC sends SOAP nodoInviaRPT2 to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT2 response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaRPT2 response
        # RPT
        And verify 1 record for the table RPT retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |





    @ALL @FLOW  @INSERT @INSERT_28
    Scenario: FLOW WFESP con: 2 pagamenti con wisp mod 1 e nodoInviaRPT con PSP che risponde uguale per entrambe (INS-28)
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
        And from body with datatable vertical pspInviaRPT_noOptional initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                 |
            | identificativoCarrello      | $1iuv              |
            | parametriPagamentoImmediato | idBruciatura=$1iuv |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT1
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp_AGID#                      |
            | identificativoIntermediarioPSP        | #broker_AGID#                   |
            | identificativoCanale                  | #canale_AGID_02#                |
            | rpt                                   | $rptAttachment                  |
        When EC sends SOAP nodoInviaRPT1 to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT1 response
        And retrieve session token from $nodoInviaRPT1Response.url
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
        Then check esito is OK of inoltroEsito/mod1 response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_secondary# |
            | identificativoStazioneRichiedente | #id_station_old#                      |
            | dataOraMessaggioRichiesta         | #timedate#                            |
            | dataEsecuzionePagamento           | #date#                                |
            | importoTotaleDaVersare            | 10.00                                 |
            | identificativoUnivocoVersamento   | $1iuv                                 |
            | codiceContestoPagamento           | CCD01                                 |
            | importoSingoloVersamento          | 10.00                                 |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT2
            | identificativoIntermediarioPA         | #id_broker_old#                       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | identificativoDominio                 | #creditor_institution_code_secondary# |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | CCD01                                 |
            | password                              | #password#                            |
            | identificativoPSP                     | #psp_AGID#                            |
            | identificativoIntermediarioPSP        | #broker_AGID#                         |
            | identificativoCanale                  | #canale_AGID_02#                      |
            | rpt                                   | $rptAttachment                        |
        When EC sends SOAP nodoInviaRPT2 to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT2 response
        And retrieve session token from $nodoInviaRPT2Response.url
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check email field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check urlRedirectEC field exists in informazioniPagamento response
        Given from body with datatable vertical inoltroEsitoMod1 initial json inoltroEsito/mod1
            | idPagamento                 | $sessionToken                        |
            | identificativoPsp           | #psp#                                |
            | tipoVersamento              | BP                                   |
            | identificativoIntermediario | #id_broker_psp#                      |
            | identificativoCanale        | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | tipoOperazione              | web                                  |
        When WISP sends REST POST inoltroEsito/mod1_json to nodo-dei-pagamenti
        Then check error is timeout of inoltroEsito/mod1 response
        # RPT
        And verify 1 record for the table RPT retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |




    @ALL @FLOW  @INSERT @INSERT_29
    Scenario: FLOW WFESP con: nodoInviaCarrelloRPT con response Ok della pspInviaCarrelloRPT xy, nodoInviaCarrelloRPT2 con stessa identica response del PSP, tutte con stessa stessa configurazione PSP multibeneficiario (INS-29)
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
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT1
            | identificativoIntermediarioPA         | #id_broker_old#                      |
            | identificativoStazioneIntermediarioPA | #id_station_old#                     |
            | identificativoCarrello                | $1iuv                                |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #id_broker_psp#                      |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | identificativoDominio                 | #creditor_institution_code_old#      |
            | identificativoUnivocoVersamento       | $1iuv                                |
            | codiceContestoPagamento               | CCD01                                |
            | rpt                                   | $rptAttachment                       |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                         |
            | identificativoCarrello      | $nodoInviaCarrelloRPT1.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT1.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT1 to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT1 response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_secondary# |
            | identificativoStazioneRichiedente | #id_station_old#                      |
            | dataOraMessaggioRichiesta         | #timedate#                            |
            | dataEsecuzionePagamento           | #date#                                |
            | importoTotaleDaVersare            | 10.00                                 |
            | identificativoUnivocoVersamento   | $1iuv                                 |
            | codiceContestoPagamento           | CCD01                                 |
            | importoSingoloVersamento          | 10.00                                 |
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT2
            | identificativoIntermediarioPA         | #id_broker_old#                       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | identificativoCarrello                | $1iuv                                 |
            | password                              | #password#                            |
            | identificativoPSP                     | #psp#                                 |
            | identificativoIntermediarioPSP        | #id_broker_psp#                       |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO#  |
            | identificativoDominio                 | #creditor_institution_code_secondary# |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | CCD01                                 |
            | rpt                                   | $rptAttachment                        |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                         |
            | identificativoCarrello      | $nodoInviaCarrelloRPT2.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT2.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT2 to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT2 response
        And check faultCode is PPT_CANALE_ERRORE_RESPONSE of nodoInviaCarrelloRPT2 response
        # CARRELLO_RPT
        And verify 1 record for the table CARRELLO_RPT retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |
        # CARRELLO_RPT_GI
        And verify 1 record for the table CARRELLO_RPT_GI retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |





    @ALL @FLOW  @INSERT @INSERT_30
    Scenario: FLOW WFESP con: 2 pagamenti con wisp mod 1 e nodoInviaCarrelloRPT con PSP che risponde uguale per entrambe (INS-30)
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
        And from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT1
            | identificativoIntermediarioPA         | #id_broker_old#                      |
            | identificativoStazioneIntermediarioPA | #id_station_old#                     |
            | identificativoCarrello                | $1iuv                                |
            | password                              | #password#                           |
            | identificativoPSP                     | #psp#                                |
            | identificativoIntermediarioPSP        | #id_broker_psp#                      |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | identificativoDominio                 | #creditor_institution_code_old#      |
            | identificativoUnivocoVersamento       | $1iuv                                |
            | codiceContestoPagamento               | CCD01                                |
            | rpt                                   | $rptAttachment                       |
        When EC sends SOAP nodoInviaCarrelloRPT1 to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT1 response
        And retrieve session token from $nodoInviaCarrelloRPT1Response.url
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
        Then check esito is OK of inoltroEsito/mod1 response
        Given from body with datatable vertical nodoInviaCarrelloRPT initial XML nodoInviaCarrelloRPT2
            | identificativoIntermediarioPA         | #id_broker_old#                       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | identificativoCarrello                | $1iuv                                 |
            | password                              | #password#                            |
            | identificativoPSP                     | #psp#                                 |
            | identificativoIntermediarioPSP        | #id_broker_psp#                       |
            | identificativoCanale                  | #canale_IMMEDIATO_MULTIBENEFICIARIO#  |
            | identificativoDominio                 | #creditor_institution_code_secondary# |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | CCD01                                 |
            | rpt                                   | $rptAttachment                        |
        When EC sends SOAP nodoInviaCarrelloRPT2 to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT2 response
        And retrieve session token from $nodoInviaCarrelloRPT2Response.url
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
        Then check esito is OK of inoltroEsito/mod1 response
        # CARRELLO_RPT
        And verify 1 record for the table CARRELLO_RPT retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |
        # CARRELLO_RPT_GI
        And verify 1 record for the table CARRELLO_RPT_GI retrived by the query on db wfesp with where datatable horizontal
            | where_keys                    | where_values       |
            | PARAMETRI_PAGAMENTO_IMMEDIATO | idBruciatura=$1iuv |