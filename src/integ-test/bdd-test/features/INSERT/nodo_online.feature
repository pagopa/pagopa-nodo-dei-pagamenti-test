Feature: TEST INSERT
    Background:
        Given systems up

    # test scritti a valle della necessità di inserire un partizionamento durante la migrazione da Oracle a Postgres

    @ALL @FLOW  @INSERT @INSERT_1
    Scenario: nodoInviaCarrelloRPT - serve duplicato carrello e poi verificare che non ci siano duplicati nella tabella STATI_CARRELLO_SNAPSHOT e STATI_CARRELLO_SNAPSHOT_GI
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And generate 2 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | 44444444444    |
            | identificativoStazioneRichiedente | 44444444444_01 |
            | dataOraMessaggioRichiesta         | #timedate#     |
            | dataEsecuzionePagamento           | #date#         |
            | importoTotaleDaVersare            | 10.00          |
            | tipoVersamento                    | BBT            |
            | identificativoUnivocoVersamento   | $1iuv          |
            | codiceContestoPagamento           | CCD01          |
            | importoSingoloVersamento          | 10.00          |
        And RPT2 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | 44444444445    |
            | identificativoStazioneRichiedente | 44444444444_01 |
            | dataOraMessaggioRichiesta         | #timedate#     |
            | dataEsecuzionePagamento           | #date#         |
            | importoTotaleDaVersare            | 10.00          |
            | tipoVersamento                    | BBT            |
            | identificativoUnivocoVersamento   | $2iuv          |
            | codiceContestoPagamento           | CCD01          |
            | importoSingoloVersamento          | 10.00          |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | identificativoCarrello                | $1iuv             |
            | password                              | #password#        |
            | identificativoPSP                     | #psp_AGID#        |
            | identificativoIntermediarioPSP        | #broker_AGID#     |
            | identificativoCanale                  | #canale_AGID_BBT# |
            | identificativoDominio1                | 44444444444       |
            | identificativoUnivocoVersamento1      | $1iuv             |
            | codiceContestoPagamento1              | CCD01             |
            | rpt1                                  | $rpt1Attachment   |
            | identificativoDominio2                | 44444444445       |
            | identificativoUnivocoVersamento2      | $2iuv             |
            | codiceContestoPagamento2              | CCD01             |
            | rpt2                                  | $rpt2Attachment   |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url contains acardste of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                          |
            | ID          | NotNone                                                        |
            | ID_SESSIONE | $sessionToken                                                  |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO     |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC       |
        And verify 3 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
            | ORDER BY   | ID ASC       |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                          |
            | ID          | NotNone                                                        |
            | ID_SESSIONE | $sessionToken                                                  |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO     |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $2iuv        |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC       |
        And verify 3 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $2iuv        |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                       |
            | ID_SESSIONE | $sessionToken                               |
            | STATO       | RPT_PARCHEGGIATA_NODO,RPT_PARCHEGGIATA_NODO |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        And verify 2 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # STATI_CARRELLO_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                  |
            | ID_SESSIONE | $sessionToken          |
            | STATO       | CART_PARCHEGGIATO_NODO |
            | INSERTED_BY | nodoInviaCarrelloRPT   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444444    |
            | identificativoUnivocoVersamento       | $1iuv          |
            | codiceContestoPagamento               | CCD01          |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_PARCHEGGIATA_NODO of nodoChiediStatoRPT response
        And check url contains https://acardste.vaservices.eu:1443/wallet of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444445    |
            | identificativoUnivocoVersamento       | $2iuv          |
            | codiceContestoPagamento               | CCD01          |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_PARCHEGGIATA_NODO of nodoChiediStatoRPT response
        And check url contains https://acardste.vaservices.eu:1443/wallet of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | identificativoCarrello                | $1iuv             |
            | password                              | #password#        |
            | identificativoPSP                     | #psp_AGID#        |
            | identificativoIntermediarioPSP        | #broker_AGID#     |
            | identificativoCanale                  | #canale_AGID_BBT# |
            | identificativoDominio1                | 44444444444       |
            | identificativoUnivocoVersamento1      | $1iuv             |
            | codiceContestoPagamento1              | CCD01             |
            | rpt1                                  | $rpt1Attachment   |
            | identificativoDominio2                | 44444444445       |
            | identificativoUnivocoVersamento2      | $2iuv             |
            | codiceContestoPagamento2              | CCD01             |
            | rpt2                                  | $rpt2Attachment   |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        And check faultCode is PPT_ID_CARRELLO_DUPLICATO of nodoInviaCarrelloRPT response
        # STATI_CARRELLO_SNAPSHOT
        And verify 1 record for the table STATI_CARRELLO_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $sessionToken |
        # STATI_CARRELLO_SNAPSHOT_GI
        And verify 1 record for the table STATI_CARRELLO_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values |
            | ID_CARRELLO | $1iuv        |



    @ALL @FLOW  @INSERT @INSERT_3
    Scenario: nodoInviaCarrelloRPT - caso duplicato rpt; Verificare che non vi siano duplicati sulla tabella RPT e RPT_GI
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And generate 2 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | 44444444444       |
            | identificativoStazioneRichiedente | 44444444444_01    |
            | dataOraMessaggioRichiesta         | #timedate#        |
            | dataEsecuzionePagamento           | #date#            |
            | importoTotaleDaVersare            | 10.00             |
            | tipoVersamento                    | BBT               |
            | identificativoUnivocoVersamento   | avanzaErrResponse |
            | codiceContestoPagamento           | #ccp1#            |
            | importoSingoloVersamento          | 10.00             |
        And RPT2 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | 44444444445       |
            | identificativoStazioneRichiedente | 44444444444_01    |
            | dataOraMessaggioRichiesta         | #timedate#        |
            | dataEsecuzionePagamento           | #date#            |
            | importoTotaleDaVersare            | 10.00             |
            | tipoVersamento                    | BBT               |
            | identificativoUnivocoVersamento   | avanzaErrResponse |
            | codiceContestoPagamento           | #ccp2#            |
            | importoSingoloVersamento          | 10.00             |
        And RPT3 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | 44444444445       |
            | identificativoStazioneRichiedente | 44444444444_01    |
            | dataOraMessaggioRichiesta         | #timedate#        |
            | dataEsecuzionePagamento           | #date#            |
            | importoTotaleDaVersare            | 10.00             |
            | tipoVersamento                    | BBT               |
            | identificativoUnivocoVersamento   | avanzaErrResponse |
            | codiceContestoPagamento           | $1ccp             |
            | importoSingoloVersamento          | 10.00             |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | identificativoCarrello                | $1iuv             |
            | password                              | #password#        |
            | identificativoPSP                     | #psp_AGID#        |
            | identificativoIntermediarioPSP        | #broker_AGID#     |
            | identificativoCanale                  | #canale_AGID_BBT# |
            | identificativoDominio1                | 44444444444       |
            | identificativoUnivocoVersamento1      | avanzaErrResponse |
            | codiceContestoPagamento1              | $1ccp             |
            | rpt1                                  | $rpt1Attachment   |
            | identificativoDominio2                | 44444444445       |
            | identificativoUnivocoVersamento2      | avanzaErrResponse |
            | codiceContestoPagamento2              | $2ccp             |
            | rpt2                                  | $rpt2Attachment   |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And check url contains acardste of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        And replace iuv content with avanzaErrResponse content
        And replace iuv2 content with avanzaErrResponse content
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                          |
            | ID          | NotNone                                                        |
            | ID_SESSIONE | $sessionToken                                                  |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO     |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        And verify 3 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                          |
            | ID          | NotNone                                                        |
            | ID_SESSIONE | $sessionToken                                                  |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO     |
            | INSERTED_BY | nodoInviaCarrelloRPT,nodoInviaCarrelloRPT,nodoInviaCarrelloRPT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        And verify 3 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $2ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        Given from body with datatable vertical pspInviaCarrelloRPT_timeout initial xml pspInviaCarrelloRPT
            | esitoComplessivoOperazione | malformata |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        And from body with datatable vertical inoltroEsitoMod1 initial json inoltroEsito/mod1
            | idPagamento                 | $sessionToken |
            | identificativoPsp           | #psp#         |
            | tipoVersamento              | BBT           |
            | identificativoIntermediario | #psp#         |
            | identificativoCanale        | #canale#      |
            | tipoOperazione              | web           |
        When WISP sends REST POST inoltroEsito/mod1_json to nodo-dei-pagamenti
        Then check error is timeout of inoltroEsito/mod1 response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | password                              | #password#        |
            | identificativoDominio                 | 44444444444       |
            | identificativoUnivocoVersamento       | avanzaErrResponse |
            | codiceContestoPagamento               | $1ccp             |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_PARCHEGGIATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_INVIATA_A_PSP of nodoChiediStatoRPT response
        And checks stato contains RPT_ESITO_SCONOSCIUTO_PSP of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | identificativoCarrello                | $2ccp             |
            | password                              | #password#        |
            | identificativoPSP                     | #psp_AGID#        |
            | identificativoIntermediarioPSP        | #broker_AGID#     |
            | identificativoCanale                  | #canale_AGID_BBT# |
            | identificativoDominio1                | 44444444444       |
            | identificativoUnivocoVersamento1      | avanzaErrResponse |
            | codiceContestoPagamento1              | $1ccp             |
            | rpt1                                  | $rpt1Attachment   |
            | identificativoDominio2                | 44444444445       |
            | identificativoUnivocoVersamento2      | avanzaErrResponse |
            | codiceContestoPagamento2              | $2ccp             |
            | rpt2                                  | $rpt2Attachment   |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        Then check faultCode is PPT_RPT_DUPLICATA of nodoInviaCarrelloRPT response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | password                              | #password#        |
            | identificativoDominio                 | 44444444445       |
            | identificativoUnivocoVersamento       | avanzaErrResponse |
            | codiceContestoPagamento               | $2ccp             |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_PARCHEGGIATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_INVIATA_A_PSP of nodoChiediStatoRPT response
        And checks stato contains RPT_ESITO_SCONOSCIUTO_PSP of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | identificativoCarrello                | $2ccp             |
            | password                              | #password#        |
            | identificativoPSP                     | #psp_AGID#        |
            | identificativoIntermediarioPSP        | #broker_AGID#     |
            | identificativoCanale                  | #canale_AGID_BBT# |
            | identificativoDominio1                | 44444444444       |
            | identificativoUnivocoVersamento1      | avanzaErrResponse |
            | codiceContestoPagamento1              | $1ccp             |
            | rpt1                                  | $rpt1Attachment   |
            | identificativoDominio2                | 44444444445       |
            | identificativoUnivocoVersamento2      | avanzaErrResponse |
            | codiceContestoPagamento2              | $1ccp             |
            | rpt2                                  | $rpt3Attachment   |
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
        Then check faultCode is PPT_RPT_DUPLICATA of nodoInviaCarrelloRPT response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | 44444444444       |
            | identificativoStazioneIntermediarioPA | 44444444444_01    |
            | password                              | #password#        |
            | identificativoDominio                 | 44444444445       |
            | identificativoUnivocoVersamento       | avanzaErrResponse |
            | codiceContestoPagamento               | $1ccp             |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RIFIUTATA_NODO of nodoChiediStatoRPT response
        When WISP sends rest GET notificaAnnullamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 404
        And check error is Il Pagamento indicato non esiste of notificaAnnullamento response
        # RPT
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RPT
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $2ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                        |
            | IDENT_DOMINIO | $nodoInviaCarrelloRPT.identificativoIntermediarioPA |
            | IUV           | avanzaErrResponse                                   |
            | CCP           | $1ccp                                               |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                              |


    @ALL @FLOW  @INSERT @INSERT_4
    Scenario: nodoInviaRPT - caso duplicato rpt; Verificare che non vi siano duplicati sulla tabella RPT e RPT_GI
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | identificativoUnivocoVersamento   | RPTdaRifPsp                 |
            | codiceContestoPagamento           | #ccp1#                      |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical pspInviaRPT_canale_errore initial XML pspInviaRPT
            | faultCode | CANALE_SYSTEM_ERROR |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker#                 |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | RPTdaRifPsp                 |
            | codiceContestoPagamento               | $1ccp                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | rpt                                   | $rptAttachment              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_CANALE_ERRORE of nodoInviaRPT response
        And check id is #psp# of nodoInviaRPT response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | RPTdaRifPsp                 |
            | codiceContestoPagamento               | $1ccp                       |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RIFIUTATA_PSP of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker#                 |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | RPTdaRifPsp                 |
            | codiceContestoPagamento               | $1ccp                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp#                       |
            | identificativoIntermediarioPSP        | #psp#                       |
            | identificativoCanale                  | #canale#                    |
            | rpt                                   | $rptAttachment              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_RPT_DUPLICATA of nodoInviaRPT response
        And check id is NodoDeiPagamentiSPC of nodoInviaRPT response
        # RPT
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | RPTdaRifPsp            |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                        |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio |
            | IUV           | RPTdaRifPsp                         |
            | CCP           | $1ccp                               |
            | ORDER BY      | INSERTED_TIMESTAMP ASC              |


    @ALL @FLOW  @INSERT @INSERT_5
    Scenario: nodoInviaRPT - prima nodoInviaRPT va in errore invio a PSP, rimando la stessa nodoInviasRPT e non deve essere rifiutata per duplicato
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | 44444444444     |
            | identificativoStazioneRichiedente | 44444444444_01  |
            | dataOraMessaggioRichiesta         | #timedate#      |
            | dataEsecuzionePagamento           | #date#          |
            | importoTotaleDaVersare            | 10.00           |
            | tipoVersamento                    | PO              |
            | identificativoUnivocoVersamento   | irraggiungibile |
            | codiceContestoPagamento           | #ccp1#          |
            | importoSingoloVersamento          | 10.00           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | 44444444444     |
            | identificativoStazioneIntermediarioPA | 44444444444_01  |
            | identificativoDominio                 | 44444444444     |
            | identificativoUnivocoVersamento       | irraggiungibile |
            | codiceContestoPagamento               | $1ccp           |
            | password                              | #password#      |
            | identificativoPSP                     | irraggiungibile |
            | identificativoIntermediarioPSP        | irraggiungibile |
            | identificativoCanale                  | irraggiungibile |
            | rpt                                   | $rpt1Attachment |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_CANALE_IRRAGGIUNGIBILE of nodoInviaRPT response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | 44444444444     |
            | identificativoStazioneIntermediarioPA | 44444444444_01  |
            | password                              | #password#      |
            | identificativoDominio                 | 44444444444     |
            | identificativoUnivocoVersamento       | irraggiungibile |
            | codiceContestoPagamento               | $1ccp           |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ERRORE_INVIO_A_PSP of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | 44444444444                  |
            | identificativoStazioneIntermediarioPA | 44444444444_01               |
            | identificativoDominio                 | 44444444444                  |
            | identificativoUnivocoVersamento       | irraggiungibile              |
            | codiceContestoPagamento               | $1ccp                        |
            | password                              | #password#                   |
            | identificativoPSP                     | #psp#                        |
            | identificativoIntermediarioPSP        | #id_broker_psp#              |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP# |
            | rpt                                   | $rpt1Attachment              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        # RPT
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | irraggiungibile        |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                        |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio |
            | IUV           | irraggiungibile                     |
            | CCP           | $1ccp                               |
            | ORDER BY      | INSERTED_TIMESTAMP ASC              |
        # STATI_RPT_SNAPSHOT
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | irraggiungibile        |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | irraggiungibile        |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |


    @ALL @FLOW  @INSERT @INSERT_9
    Scenario: RT pull con tripla duplicata - fare un cambio stato sulla tabella RPT_STATI_SNAPSHOT -> stato a prima della rt pull -> rilancio la rt pull con i relativi override
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | CCD01                           |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | identificativoUnivocoRiscossione  | $1iuv                           |
            | CodiceContestoPagamento           | CCD01                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #psp#                           |
            | identificativoCanale                  | #canaleRtPull_sec#              |
            | rpt                                   | $rpt1Attachment                 |
        And from body with datatable vertical pspInviaRPT_noOptional initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                 |
            | identificativoCarrello      | $1iuv              |
            | parametriPagamentoImmediato | idBruciatura=$1iuv |
        And from body with datatable horizontal pspChiediListaRT_noOptional initial XML pspChiediListaRT
            | identificativoDominio           | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code_old# | $1iuv                           | CCD01                   |
        And from body with datatable horizontal pspChiediRT_noOptional initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP2 replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 5 seconds for expiration
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                    |
            | ID          | NotNone                                                                  |
            | ID_SESSIONE | NotNone                                                                  |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,pspInviaRPT                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value             |
            | ID_SESSIONE | NotNone           |
            | STATO       | RPT_ACCETTATA_PSP |
            | INSERTED_BY | nodoInviaRPT      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        When job pspChiediListaAndChiediRt triggered after 5 seconds
        And wait 5 seconds for expiration
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                                                       |
            | ID          | NotNone                                                                                                     |
            | ID_SESSIONE | NotNone                                                                                                     |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,pspInviaRPT,pspChiediRT,pspChiediRT                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value             |
            | ID_SESSIONE | NotNone           |
            | STATO       | RT_ACCETTATA_NODO |
            | INSERTED_BY | nodoInviaRPT      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | CCD01                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | CCD01                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RETRY_PA_INVIA_RT
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        Given generic update through the query param_update_generic_where_condition of the table STATI_RPT_SNAPSHOT the parameter STATO = 'RPT_ACCETTATA_PSP', with where condition ID_DOMINIO='$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        And from body with datatable horizontal pspChiediListaRT_noOptional initial XML pspChiediListaRT
            | identificativoDominio           | identificativoUnivocoVersamento | codiceContestoPagamento |
            | #creditor_institution_code_old# | $1iuv                           | CCD01                   |
        And from body with datatable horizontal pspChiediRT_noOptional initial XML pspChiediRT
            | rt            |
            | $rtAttachment |
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP2 replies to nodo-dei-pagamenti with the pspChiediRT
        And wait 2 seconds for expiration
        When job pspChiediListaAndChiediRt triggered after 5 seconds
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                                                                        |
            | ID          | NotNone                                                                                                                      |
            | ID_SESSIONE | NotNone                                                                                                                      |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP,RT_RICEVUTA_NODO,RT_ACCETTATA_NODO,RT_RICEVUTA_NODO |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,pspInviaRPT,pspChiediRT,pspChiediRT,pspChiediRT                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value             |
            | ID_SESSIONE | NotNone           |
            | STATO       | RPT_ACCETTATA_PSP |
            | INSERTED_BY | nodoInviaRPT      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | CCD01                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | CCD01                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RETRY_PA_INVIA_RT
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |


    @ALL @FLOW  @INSERT @INSERT_10
    Scenario: nodoNotificaAnnullamento - fare un cambio stato sulla tabella RPT_STATI_SNAPSHOT -> stato a prima della notifica annullamento -> rilancio la notifica annullamento e lo stato sulla STATI_RPT _SNAPSHOT rimane quello dell'update; Verificare che non vi siano duplicati sulla tabella RT , RT_GI
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | BBT                         |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | CCD01                       |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker#                 |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | CCD01                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp_AGID#                  |
            | identificativoIntermediarioPSP        | #broker_AGID#               |
            | identificativoCanale                  | #canale_AGID_BBT#           |
            | rpt                                   | $rpt1Attachment             |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                      |
            | ID          | NotNone                                                    |
            | ID_SESSIONE | NotNone                                                    |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                 |
            | ID_SESSIONE | NotNone               |
            | STATO       | RPT_PARCHEGGIATA_NODO |
            | INSERTED_BY | nodoInviaRPT          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        When WISP sends rest GET notificaAnnullamento?idPagamento=$sessionToken&motivoAnnullamento=CONPSP to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                       |
            | ID          | NotNone                                                                     |
            | ID_SESSIONE | NotNone                                                                     |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoNotificaAnnullamento             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value            |
            | ID_SESSIONE | NotNone          |
            | STATO       | RT_GENERATA_NODO |
            | INSERTED_BY | nodoInviaRPT     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value        |
            | ESITO  | NON_ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        Given generic update through the query param_update_generic_where_condition of the table STATI_RPT_SNAPSHOT the parameter STATO = 'RPT_PARCHEGGIATA_NODO', with where condition ID_DOMINIO='$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        When WISP sends rest GET notificaAnnullamento?idPagamento=$sessionToken&motivoAnnullamento=CONPSP to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                                       |
            | ID          | NotNone                                                                     |
            | ID_SESSIONE | NotNone                                                                     |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,nodoNotificaAnnullamento             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                 |
            | ID_SESSIONE | NotNone               |
            | STATO       | RPT_PARCHEGGIATA_NODO |
            | INSERTED_BY | nodoInviaRPT          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | $1iuv        |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value        |
            | ESITO  | NON_ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | CCD01                                         |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | CCD01                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | CCD01                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |



    @ALL @FLOW  @INSERT @INSERT_11
    Scenario: close ko con update a DB dopo aver già avuto una RT
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | identificativoUnivocoRiscossione  | $1iuv                           |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And replace ccp1 content with $1ccp content
        And replace iuv content with $1iuv content
        Given from body with datatable vertical nodoAttivaRPT initial XML nodoAttivaRPT
            | identificativoIntermediarioPSPPagamento | #broker_AGID#                   |
            | identificativoCanalePagamento           | #canale_AGID_BBT#               |
            | identificativoPSP                       | #psp_AGID#                      |
            | identificativoIntermediarioPSP          | #broker_AGID#                   |
            | identificativoCanale                    | #canale_AGID#                   |
            | password                                | #password#                      |
            | codiceContestoPagamento                 | #ccp#                           |
            | CCPost                                  | #creditor_institution_code_old# |
            | CodStazPA                               | #cod_segr#                      |
            | AuxDigit                                | 0                               |
            | CodIUV                                  | $iuv                            |
            | importoSingoloVersamento                | 10.00                           |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When EC sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
        And replace ccp2 content with $ccp content
        Given RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | $iuv                            |
            | codiceContestoPagamento           | $ccp2                           |
            | importoSingoloVersamento          | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | $ccp2                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp_AGID#                      |
            | identificativoIntermediarioPSP        | #broker_AGID#                   |
            | identificativoCanale                  | #canale_AGID_BBT#               |
            | rpt                                   | $rptAttachment                  |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        Given generic update through the query param_update_generic_where_condition of the table RT_GI the parameter CCP = '$ccp2', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table RT the parameter CCP = '$ccp2', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        Given from body with datatable vertical closePaymentBody initial json v1/closepayment
            | token                       | $sessionToken                        |
            | outcome                     | KO                                   |
            | identificativoPsp           | #psp#                                |
            | identificativoIntermediario | #id_broker_psp#                      |
            | identificativoCanale        | #canale_IMMEDIATO_MULTIBENEFICIARIO# |
            | tipoVersamento              | BPAY                                 |
            | pspTransactionId            | #transaction_id#                     |
            | totalAmount                 | 12                                   |
            | fee                         | 2                                    |
            | timestampOperation          | 2023-11-30T12:46:46.554+01:00        |
            | transactionId               | #transaction_id#                     |
            | outcomePaymentGateway       | 00                                   |
            | authorizationCode           | 123456                               |
        When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v1/closepayment response is 500
        And check esito is KO of v1/closepayment response
        And check descrizione is Errore generico. of v1/closepayment response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $ccp2                                         |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $ccp2                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $ccp2                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |



    @ALL @FLOW  @INSERT @INSERT_12
    Scenario: close v2 ko con update sullo stato
        Given generate 1 notice number and iuv with aux digit 3, segregation code NA and application code 12
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | identificativoUnivocoRiscossione  | 12$1iuv                         |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$1iuv                         |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | 12$1iuv                         |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$1iuv      |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | 12$1iuv                |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        And replace ccp1 content with $1ccp content
        And replace iuv content with $1iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                      | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code_old# | 312$iuv      | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#               |
            | identificativoStazioneRichiedente | #id_station_old#                              |
            | dataOraMessaggioRichiesta         | #timedate#                                    |
            | dataEsecuzionePagamento           | #date#                                        |
            | importoTotaleDaVersare            | 10.00                                         |
            | tipoVersamento                    | PO                                            |
            | identificativoUnivocoVersamento   | 12$iuv                                        |
            | codiceContestoPagamento           | $activatePaymentNoticeV2Response.paymentToken |
            | importoSingoloVersamento          | 10.00                                         |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
            | password                              | #password#                                    |
            | identificativoPSP                     | #psp_AGID#                                    |
            | identificativoIntermediarioPSP        | #broker_AGID#                                 |
            | identificativoCanale                  | #canale_AGID_BBT#                             |
            | rpt                                   | $rptAttachment                                |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        Given generic update through the query param_update_generic_where_condition of the table RT_GI the parameter CCP = '$activatePaymentNoticeV2Response.paymentToken', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table RT the parameter CCP = '$activatePaymentNoticeV2Response.paymentToken', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        Given from body with datatable vertical closePaymentV2Body_CP_noOptional initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | KO                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #id_broker_psp#                               |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | BPAY                                          |
            | transactionId         | #transaction_id#                              |
            | totalAmountExt        | 12                                            |
            | feeExt                | 2                                             |
            | primaryCiIncurredFee  | 1                                             |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122          |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122          |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                 |
            | rrn                   | 11223344                                      |
            | outPaymentGateway     | 00                                            |
            | totalAmount1          | 12                                            |
            | fee1                  | 2                                             |
            | timestampOperation1   | 2021-07-09T17:06:03                           |
            | authorizationCode     | 123456                                        |
            | paymentGateway        | 00                                            |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 500
        And check outcome is KO of v2/closepayment response
        And check description is Errore generico. of v2/closepayment response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |



    @ALL @FLOW  @INSERT @INSERT_13
    Scenario: spo con update sullo stato
        Given generate 1 notice number and iuv with aux digit 3, segregation code NA and application code 12
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | identificativoUnivocoRiscossione  | 12$1iuv                         |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$1iuv                         |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | 12$1iuv                         |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$1iuv      |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | 12$1iuv                |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $1ccp                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        And replace ccp1 content with $1ccp content
        And replace iuv content with $1iuv content
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #pspFittizio#                               |
            | identificativoIntermediarioPSP        | #brokerFittizio#                            |
            | identificativoCanale                  | #canaleFittizio#                            |
            | rpt                                   | $rptAttachment                              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given generic update through the query param_update_generic_where_condition of the table RT_GI the parameter CCP = '$activatePaymentNoticeResponse.paymentToken', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table RT the parameter CCP = '$activatePaymentNoticeResponse.paymentToken', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SYSTEM_ERROR of sendPaymentOutcome response
        And check description is Errore generico. of sendPaymentOutcome response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeResponse.paymentToken   |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeResponse.paymentToken   |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeResponse.paymentToken   |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |



    @ALL @FLOW  @INSERT @INSERT_14
    Scenario: spoV2 con update sullo stato
        Given generate 1 notice number and iuv with aux digit 3, segregation code NA and application code 12
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | identificativoUnivocoRiscossione  | 12$1iuv                         |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$1iuv                         |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | 12$1iuv                         |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$1iuv      |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | 12$1iuv                |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $1ccp                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        And replace ccp1 content with $1ccp content
        And replace iuv content with $1iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 312$iuv      | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#               |
            | identificativoStazioneRichiedente | #id_station_old#                              |
            | dataOraMessaggioRichiesta         | #timedate#                                    |
            | dataEsecuzionePagamento           | #date#                                        |
            | importoTotaleDaVersare            | $activatePaymentNoticeV2.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                        |
            | codiceContestoPagamento           | $activatePaymentNoticeV2Response.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNoticeV2.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                               |
            | identificativoStazioneIntermediarioPA | #id_station_old#                              |
            | identificativoDominio                 | #creditor_institution_code_old#               |
            | identificativoUnivocoVersamento       | 12$iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeV2Response.paymentToken |
            | password                              | #password#                                    |
            | identificativoPSP                     | #pspFittizio#                                 |
            | identificativoIntermediarioPSP        | #brokerFittizio#                              |
            | identificativoCanale                  | #canaleFittizio#                              |
            | rpt                                   | $rptAttachment                                |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given generic update through the query param_update_generic_where_condition of the table RT_GI the parameter CCP = '$activatePaymentNoticeV2Response.paymentToken', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table RT the parameter CCP = '$activatePaymentNoticeV2Response.paymentToken', with where condition IDENT_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_noOptional initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | paymentToken                                  | outcome |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SYSTEM_ERROR of sendPaymentOutcomeV2 response
        And check description is Errore generico. of sendPaymentOutcomeV2 response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $activatePaymentNoticeV2Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |



    @ALL @FLOW  @INSERT @INSERT_15
    Scenario: activate attivazione fallita con update sullo stato
        Given generate 1 notice number and iuv with aux digit 3, segregation code NA and application code 12
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | identificativoUnivocoRiscossione  | 12$1iuv                         |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$1iuv                         |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | 12$1iuv                         |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$1iuv      |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | 12$1iuv                |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                        |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio |
            | IUV           | 12$1iuv                             |
            | CCP           | $1ccp                               |
            | ORDER BY      | INSERTED_TIMESTAMP ASC              |
        And replace ccp content with $1ccp content
        And replace iuv content with 12$1iuv content
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 3$iuv        | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_delay_KO initial XML paaAttivaRPT
            | delay | faultCode              | faultString         | id                          | description                            | esito |
            | 5250  | PAA_SEMANTICA_EXTRAXSD | errore semantico PA | #creditor_institution_code# | Errore semantico emesso dalla PA esito | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount   |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | $iuv                            |
            | codiceContestoPagamento           | paymentToken                    |
            | importoSingoloVersamento          | $activatePaymentNotice.amount   |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | paymentToken                    |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | rptAttachment                   |
        Then saving activatePaymentNotice request in activatePaymentNotice
        And saving nodoInviaRPT request in nodoInviaRPT
        When calling in parallel with update token activatePaymentNotice and nodoInviaRPT_$rpt with POST and POST with 3000 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
        And check description is Pagamento in attesa risulta in corso al sistema pagoPA of activatePaymentNotice response
        And check esito is OK of nodoInviaRPT response
        # RT
        And verify 0 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values             |
            | CCP        | $token_by_rptActivations |
            | ORDER BY   | INSERTED_TIMESTAMP ASC   |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $token_by_rptActivations                      |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |


    @ALL @FLOW  @INSERT @INSERT_16
    Scenario: activateV2 attivazione fallita con update sullo stato
        Given generate 1 notice number and iuv with aux digit 3, segregation code NA and application code 12
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | 12$1iuv                         |
            | identificativoUnivocoRiscossione  | 12$1iuv                         |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | 12$1iuv                         |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | 12$1iuv                         |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column | value    |
            | ESITO  | ESEGUITO |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$1iuv      |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | 12$1iuv                |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                        |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio |
            | IUV           | 12$1iuv                             |
            | CCP           | $1ccp                               |
            | ORDER BY      | INSERTED_TIMESTAMP ASC              |
        And replace ccp content with $1ccp content
        And replace iuv content with 12$1iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP | idBrokerPSP         | idChannel  | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #intermediarioPSP2# | #canale32# | #password# | #creditor_institution_code# | 3$iuv        | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_delay_KO initial XML paaAttivaRPT
            | delay | faultCode              | faultString         | id                          | description                            | esito |
            | 5250  | PAA_SEMANTICA_EXTRAXSD | errore semantico PA | #creditor_institution_code# | Errore semantico emesso dalla PA esito | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | $activatePaymentNoticeV2.amount |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | $iuv                            |
            | codiceContestoPagamento           | paymentToken                    |
            | importoSingoloVersamento          | $activatePaymentNoticeV2.amount |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $iuv                            |
            | codiceContestoPagamento               | paymentToken                    |
            | password                              | #password#                      |
            | identificativoPSP                     | #pspFittizio#                   |
            | identificativoIntermediarioPSP        | #brokerFittizio#                |
            | identificativoCanale                  | #canaleFittizio#                |
            | rpt                                   | rptAttachment                   |
        Then saving activatePaymentNoticeV2 request in activatePaymentNoticeV2
        And saving nodoInviaRPT request in nodoInviaRPT
        When calling in parallel with update token activatePaymentNoticeV2 and nodoInviaRPT_$rpt with POST and POST with 3000 ms delay
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNoticeV2 response
        And check description is Pagamento in attesa risulta in corso al sistema pagoPA of activatePaymentNoticeV2 response
        And check esito is OK of nodoInviaRPT response
        # RT
        And verify 0 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values             |
            | CCP        | $token_by_rptActivations |
            | ORDER BY   | INSERTED_TIMESTAMP ASC   |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $token_by_rptActivations                      |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |



    @ALL @FLOW  @INSERT @INSERT_17 @after
    Scenario: INSERT - activate -> paaAttivaRPT  nodoInviaRPT (scadenza sessione)  mod3cancelV1 -> STATI_RPT_SNAPSHOT fare update con RPT_PARCHEGGIATA_NODO_MOD3 --> POSITION_PAYMENT_STATUS_SNAPSHOT fare update con PAYING_RPT --> POSITION_STATUS_SNAPSHOT fare update con PAYING --> mod3CancelV1
        Given update parameter default_token_duration_validity_millis on configuration keys with value 2000
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #pspFittizio#                               |
            | identificativoIntermediarioPSP        | #brokerFittizio#                            |
            | identificativoCanale                  | #canaleFittizio#                            |
            | rpt                                   | $rptAttachment                              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        And wait 2 seconds for expiration
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | CANCELLED                                   |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | mod3CancelV1                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                               |
            | ID             | NotNone                             |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | STATUS         | PAYING,INSERTED                     |
            | INSERTED_BY    | activatePaymentNotice,mod3CancelV1  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | INSERTED                            |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | mod3CancelV1                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                          |
            | ID                    | NotNone                                                                                                        |
            | ID_SESSIONE           | NotNone                                                                                                        |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                        |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                              |
            | IUV                   | 12$iuv                                                                                                         |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                    |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,mod3CancelV1,mod3CancelV1,paaInviaRT                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RT_ACCETTATA_PA                             |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | paaInviaRT                                  |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RT_GI
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | IDENT_DOMINIO      | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_TIMESTAMP | NotNone                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        # RT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                       |
            | ID_SESSIONE         | NotNone                                     |
            | IDENT_DOMINIO       | $activatePaymentNotice.fiscalCode           |
            | IUV                 | 12$iuv                                      |
            | CCP                 | $activatePaymentNoticeResponse.paymentToken |
            | COD_ESITO           | 1                                           |
            | ESITO               | NON_ESEGUITO                                |
            | DATA_RICEVUTA       | NotNone                                     |
            | DATA_RICHIESTA      | NotNone                                     |
            | ID_RICEVUTA         | NotNone                                     |
            | ID_RICHIESTA        | NotNone                                     |
            | SOMMA_VERSAMENTI    | 0                                           |
            | INSERTED_TIMESTAMP  | NotNone                                     |
            | UPDATED_TIMESTAMP   | NotNone                                     |
            | CANALE              | #canaleFittizio#                            |
            | NOTIFICA_PROCESSATA | N                                           |
            | GENERATA_DA         | NMP                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        Given generic update through the query param_update_generic_where_condition of the table STATI_RPT_SNAPSHOT the parameter STATO = 'RPT_PARCHEGGIATA_NODO_MOD3', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV = '$nodoInviaRPT.identificativoUnivocoVersamento' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS = 'PAYING_RPT', with where condition PA_FISCAL_CODE = '$nodoInviaRPT.identificativoDominio' AND NOTICE_ID = '$activatePaymentNotice.noticeNumber' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table POSITION_STATUS_SNAPSHOT the parameter STATUS = 'PAYING', with where condition PA_FISCAL_CODE = '$nodoInviaRPT.identificativoDominio' AND NOTICE_ID = '$activatePaymentNotice.noticeNumber' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        When job mod3CancelV1 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING_RPT                                  |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | mod3CancelV1                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
            | STATUS              | PAYING                              |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
            | FK_POSITION_SERVICE | NotNone                             |
            | INSERTED_BY         | activatePaymentNotice               |
            | UPDATED_BY          | mod3CancelV1                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                          |
            | ID                    | NotNone                                                                                                        |
            | ID_SESSIONE           | NotNone                                                                                                        |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                        |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                              |
            | IUV                   | 12$iuv                                                                                                         |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                                                                    |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,mod3CancelV1,mod3CancelV1,paaInviaRT                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 6 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RPT_PARCHEGGIATA_NODO_MOD3                  |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | paaInviaRT                                  |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        # RT
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |



    @ALL @FLOW  @INSERT @INSERT_18
    Scenario: MOD1 carrello multibeneficiario rt push
        Given generate 1 notice number and iuv with aux digit 3, segregation code 02 and application code NA
        And generate 1 cart with PA #creditor_institution_code_old# and notice number $1noticeNumber
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | BBT                         |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | $1carrello                  |
            | importoSingoloVersamento          | 10.00                       |
        And RPT2 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_secondary# |
            | identificativoStazioneRichiedente | #id_stazion#                          |
            | dataOraMessaggioRichiesta         | #timedate#                            |
            | dataEsecuzionePagamento           | #date#                                |
            | importoTotaleDaVersare            | 10.00                                 |
            | tipoVersamento                    | BBT                                   |
            | identificativoUnivocoVersamento   | $1iuv                                 |
            | codiceContestoPagamento           | $1carrello                            |
            | importoSingoloVersamento          | 10.00                                 |
        And RT1 generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 0.00                        |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | $1carrello                  |
            | codiceEsitoPagamento              | 1                           |
            | singoloImportoPagato              | 0.00                        |
        And RT2 generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_secondary# |
            | identificativoStazioneRichiedente | #id_station#                          |
            | dataOraMessaggioRicevuta          | #timedate#                            |
            | importoTotalePagato               | 0.00                                  |
            | identificativoUnivocoVersamento   | $1iuv                                 |
            | identificativoUnivocoRiscossione  | $1iuv                                 |
            | CodiceContestoPagamento           | $1carrello                            |
            | codiceEsitoPagamento              | 1                                     |
            | singoloImportoPagato              | 0.00                                  |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista_multibeneficiario initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code#           |
            | identificativoStazioneIntermediarioPA | #id_station#                          |
            | identificativoCarrello                | $1carrello                            |
            | password                              | #password#                            |
            | identificativoPSP                     | #psp_AGID#                            |
            | identificativoIntermediarioPSP        | #broker_AGID#                         |
            | identificativoCanale                  | #canale_AGID_BBT#                     |
            | identificativoDominio1                | #creditor_institution_code#           |
            | identificativoUnivocoVersamento1      | $1iuv                                 |
            | codiceContestoPagamento1              | $1carrello                            |
            | rpt1                                  | $rpt1Attachment                       |
            | identificativoDominio2                | #creditor_institution_code_secondary# |
            | identificativoUnivocoVersamento2      | $1iuv                                 |
            | codiceContestoPagamento2              | $1carrello                            |
            | rpt2                                  | $rpt2Attachment                       |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        Given from body with datatable vertical pspInviaCarrelloRPTCarte initial XML pspInviaCarrelloRPTCarte
            | esitoComplessivoOperazione | OK |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPTCarte
        And from body with datatable vertical inoltroEsitoCarta initial json inoltroEsito/carta
            | idPagamento                 | $sessionToken |
            | identificativoPsp           | #psp#         |
            | tipoVersamento              | CP            |
            | identificativoIntermediario | #psp#         |
            | identificativoCanale        | #canale#      |
            | importoTotalePagato         | 11.11         |
        When WISP sends REST POST inoltroEsito/carta_json to nodo-dei-pagamenti
        Then check esito is OK of inoltroEsito/carta response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#             |
            | identificativoCanale            | #canale#                    |
            | password                        | #password#                  |
            | identificativoPSP               | #psp#                       |
            | identificativoDominio           | #creditor_institution_code# |
            | identificativoUnivocoVersamento | $1iuv                       |
            | codiceContestoPagamento         | $1carrello                  |
            | forzaControlloSegno             | 1                           |
            | rt                              | $rt1Attachment              |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                       |
            | identificativoCanale            | #canale#                              |
            | password                        | #password#                            |
            | identificativoPSP               | #psp#                                 |
            | identificativoDominio           | #creditor_institution_code_secondary# |
            | identificativoUnivocoVersamento | $1iuv                                 |
            | codiceContestoPagamento         | $1carrello                            |
            | forzaControlloSegno             | 1                                     |
            | rt                              | $rt2Attachment                        |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # POSITION_SERVICE_GI
        And verify 1 record for the table POSITION_SERVICE_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                |
            | NOTICE_ID      | 302$1iuv                    |
            | PA_FISCAL_CODE | #creditor_institution_code# |
        # POSITION_SERVICE
        And verify 1 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                |
            | NOTICE_ID      | 302$1iuv                    |
            | PA_FISCAL_CODE | #creditor_institution_code# |
        Given generate 2 cart with PA #creditor_institution_code_old# and notice number $1noticeNumber
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | BBT                         |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | $2carrello                  |
            | importoSingoloVersamento          | 10.00                       |
        And RPT2 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_secondary# |
            | identificativoStazioneRichiedente | #id_stazion#                          |
            | dataOraMessaggioRichiesta         | #timedate#                            |
            | dataEsecuzionePagamento           | #date#                                |
            | importoTotaleDaVersare            | 10.00                                 |
            | tipoVersamento                    | BBT                                   |
            | identificativoUnivocoVersamento   | $1iuv                                 |
            | codiceContestoPagamento           | $2carrello                            |
            | importoSingoloVersamento          | 10.00                                 |
        And from body with datatable vertical nodoInviaCarrelloRPT_2elemLista initial XML nodoInviaCarrelloRPT
            | identificativoIntermediarioPA         | #creditor_institution_code#           |
            | identificativoStazioneIntermediarioPA | #id_station#                          |
            | identificativoCarrello                | $2carrello                            |
            | password                              | #password#                            |
            | identificativoPSP                     | #psp_AGID#                            |
            | identificativoIntermediarioPSP        | #broker_AGID#                         |
            | identificativoCanale                  | #canale_AGID_BBT#                     |
            | identificativoDominio1                | #creditor_institution_code#           |
            | identificativoUnivocoVersamento1      | $1iuv                                 |
            | codiceContestoPagamento1              | $2carrello                            |
            | rpt1                                  | $rpt1Attachment                       |
            | identificativoDominio2                | #creditor_institution_code_secondary# |
            | identificativoUnivocoVersamento2      | $1iuv                                 |
            | codiceContestoPagamento2              | $2carrello                            |
            | rpt2                                  | $rpt2Attachment                       |
        And from body with datatable vertical pspInviaCarrelloRPT_noOptional initial XML pspInviaCarrelloRPT
            | esitoComplessivoOperazione  | OK                                                        |
            | identificativoCarrello      | $nodoInviaCarrelloRPT.identificativoCarrello              |
            | parametriPagamentoImmediato | idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello |
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        # POSITION_SERVICE_GI
        And verify 1 record for the table POSITION_SERVICE_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                |
            | NOTICE_ID      | 302$1iuv                    |
            | PA_FISCAL_CODE | #creditor_institution_code# |
        # POSITION_SERVICE
        And verify 1 record for the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                |
            | NOTICE_ID      | 302$1iuv                    |
            | PA_FISCAL_CODE | #creditor_institution_code# |


    @ALL @FLOW  @INSERT @INSERT_20
    Scenario: updateRptStatiAndSnapshotAndDeleteteRetryPaInviaRT
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | PO                              |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | identificativoUnivocoRiscossione  | $1iuv                           |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#    |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable horizontal paaInviaRT_Timeout_KO initial XML paaInviaRT
            | esito | delay |
            | OK    | 10000 |
        And EC replies to nodo-dei-pagamenti with the paaInviaRT
        And from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP#    |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And wait 10 seconds for expiration
        # RETRY_PA_INVIA_RT
        And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code#           |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
        # RETRY_PA_INVIA_RT_GI
        And verify 1 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code#           |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
        When job paRetryPaInviaRtNegative triggered after 5 seconds
        And wait 5 seconds for expiration
        # RETRY_PA_INVIA_RT
        Then verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code#           |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
        # RETRY_PA_INVIA_RT_GI
        And verify 0 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code#           |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |



    @ALL @FLOW  @INSERT @INSERT_7
    Scenario: PPT_RPT_DUPLICATA da controllare nella tabella STATI_RPT_SNAPSHOT che non ci sia un duplicato per la tripletta
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | tipoVersamento                    | BBT                             |
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
            | rpt                                   | $rpt1Attachment                 |
        And from body with datatable vertical pspInviaRPT_noOptional initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                 |
            | identificativoCarrello      | $1iuv              |
            | parametriPagamentoImmediato | idBruciatura=$1iuv |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url
        # RPT
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                          |
            | IDENT_DOMINIO | #creditor_institution_code_old#       |
            | IUV           | $1iuv                                 |
            | CCP           | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                          |
            | IDENT_DOMINIO | #creditor_institution_code_old#       |
            | IUV           | $1iuv                                 |
            | CCP           | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column      | value                                                      |
            | ID          | NotNone                                                    |
            | ID_SESSIONE | $sessionToken                                              |
            | STATO       | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO |
            | INSERTED_BY | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code_old#       |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                                |
        And verify 3 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code_old#       |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC                                |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code_old#       |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # STATI_RPT_SNAPSHOT
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code_old#       |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old#       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | password                              | #password#                            |
            | identificativoDominio                 | #creditor_institution_code_old#       |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | $nodoInviaRPT.codiceContestoPagamento |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_PARCHEGGIATA_NODO of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | CCD01                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp_AGID#                      |
            | identificativoIntermediarioPSP        | #broker_AGID#                   |
            | identificativoCanale                  | #canale_AGID_BBT#               |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_RPT_DUPLICATA of nodoInviaRPT response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old#       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | password                              | #password#                            |
            | identificativoDominio                 | #creditor_institution_code_old#       |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | $nodoInviaRPT.codiceContestoPagamento |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_RIFIUTATA_NODO of nodoChiediStatoRPT response
        # RPT
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                          |
            | IDENT_DOMINIO | #creditor_institution_code_old#       |
            | IUV           | $1iuv                                 |
            | CCP           | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                          |
            | IDENT_DOMINIO | #creditor_institution_code_old#       |
            | IUV           | $1iuv                                 |
            | CCP           | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code_old#       |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # STATI_RPT_SNAPSHOT
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | ID_DOMINIO | #creditor_institution_code_old#       |
            | IUV        | $1iuv                                 |
            | CCP        | $nodoInviaRPT.codiceContestoPagamento |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |



    @ALL @FLOW  @INSERT @INSERT_22 @after
    Scenario: updateRptSnapshotAndDeleteteRetryPaInviaRT - verificare che venga fatta la delete sulla retry_pa_invia_rt e retry_pa_invia_rt_gi
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter INVIO_RT_ISTANTANEO = 'Y', with where condition OBJ_ID = '16635' under macro update_query on db nodo_cfg
        And wait 5 seconds after triggered refresh job ALL
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And insert through the query insert_query into the table RETRY_PA_INVIA_RT_GI the fields ID_DOMINIO,IUV,CCP,INSERTED_TIMESTAMP with '#creditor_institution_code_old#','12$iuv','$activatePaymentNoticeResponse.paymentToken','#timedate#' under macro update_query on db nodo_online
        And insert through the query insert_query into the table RETRY_PA_INVIA_RT the fields ID_SESSIONE,ID_STAZIONE,ID_INTERMEDIARIO_PA,ID_CANALE,ID_SESSIONE_ORIGINALE,ID_DOMINIO,IUV,CCP,STATO,INSERTED_TIMESTAMP,INSERTED_BY,UPDATED_TIMESTAMP,UPDATED_BY,RETRY,STATO_RPT with '#uuid1#','#id_station_old#','#id_broker_old#','#canaleFittizio#','#uuid2#','#creditor_institution_code_old#','12$iuv','$activatePaymentNoticeResponse.paymentToken','TO_RETRY','#timedate#','nodoInviaRPT','#timedate#','nodoInviaRPT',5,'RT_ERRORE_INVIO_A_PA' under macro update_query on db nodo_online
        And wait 3 seconds for expiration
        # RETRY_PA_INVIA_RT_GI
        And verify 1 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | ID_DOMINIO | #creditor_institution_code_old#             |
            | IUV        | 12$iuv                                      |
            | CCP        | $activatePaymentNoticeResponse.paymentToken |
        # RETRY_PA_INVIA_RT
        And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | ID_DOMINIO | #creditor_institution_code_old#             |
            | IUV        | 12$iuv                                      |
            | CCP        | $activatePaymentNoticeResponse.paymentToken |
        Given from body with datatable horizontal sendPaymentOutcomeBody_noOptional initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        And RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | 10.00                                       |
            | tipoVersamento                    | PO                                          |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | 10.00                                       |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #pspFittizio#                               |
            | identificativoIntermediarioPSP        | #brokerFittizio#                            |
            | identificativoCanale                  | #canaleFittizio#                            |
            | rpt                                   | $rptAttachment                              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And wait 3 seconds for expiration
        # RETRY_PA_INVIA_RT_GI
        And verify 0 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | ID_DOMINIO | #creditor_institution_code_old#             |
            | IUV        | 12$iuv                                      |
            | CCP        | $activatePaymentNoticeResponse.paymentToken |
        # RETRY_PA_INVIA_RT
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | ID_DOMINIO | #creditor_institution_code_old#             |
            | IUV        | 12$iuv                                      |
            | CCP        | $activatePaymentNoticeResponse.paymentToken |



    @ALL @FLOW  @INSERT @INSERT_6
    Scenario: nodoInviaRPT - modello 3 con 2 chiamate nodoInviaRPT che partano in parallelo con lo stesso token (CCP) in request
        Given from body with datatable horizontal activatePaymentNoticeBody_noOptional initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | 10.00                                       |
            | tipoVersamento                    | PO                                          |
            | identificativoUnivocoVersamento   | $iuv                                        |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | 10.00                                       |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | $iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #psp#                                       |
            | identificativoIntermediarioPSP        | #id_broker_psp#                             |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#                |
            | rpt                                   | $rpt1Attachment                             |
        And saving nodoInviaRPT request in nodoInviaRPT1
        And RPT2 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | 10.00                                       |
            | tipoVersamento                    | PO                                          |
            | identificativoUnivocoVersamento   | $iuv                                        |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | 10.00                                       |
        And from body with datatable vertical nodoInviaRPTBody_noOptional initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | $iuv                                        |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #psp#                                       |
            | identificativoIntermediarioPSP        | #id_broker_psp#                             |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#                |
            | rpt                                   | $rpt2Attachment                             |
        And saving nodoInviaRPT request in nodoInviaRPT2
        When calling primitive nodoInviaRPT_nodoInviaRPT1 POST and nodoInviaRPT_nodoInviaRPT2 POST in parallel
        Then check primitive response nodoInviaRPT2Response and primitive response nodoInviaRPT1Response
        # STATI_RPT_SNAPSHOT
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | IUV        | $iuv                                        |
            | CCP        | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                      |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                |
            | IUV        | $iuv                                        |
            | CCP        | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                      |
        # RPT
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IDENT_DOMINIO | #creditor_institution_code_old#             |
            | IUV           | $iuv                                        |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        # RPT_GI
        And verify 1 record for the table RPT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IDENT_DOMINIO | #creditor_institution_code_old#             |
            | IUV           | $iuv                                        |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |



    @ALL @FLOW  @INSERT @INSERT_8
    Scenario: nodoInviaRT diretta - a seguito dell'invio di una nodoInviaRT, se invio nuovamente la nodoInviaRT otterrò PPT_RT_DUPLICATA
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRichiesta         | #timedate#                      |
            | dataEsecuzionePagamento           | #date#                          |
            | importoTotaleDaVersare            | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | codiceContestoPagamento           | #ccp1#                          |
            | importoSingoloVersamento          | 10.00                           |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | identificativoUnivocoRiscossione  | $1iuv                           |
            | CodiceContestoPagamento           | $1ccp                           |
            | codiceEsitoPagamento              | 0                               |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical pspInviaRPT_noOptional initial XML pspInviaRPT
            | esitoComplessivoOperazione  | OK                 |
            | identificativoCarrello      | $1iuv              |
            | parametriPagamentoImmediato | idBruciatura=$1iuv |
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                 |
            | identificativoStazioneIntermediarioPA | #id_station_old#                |
            | identificativoDominio                 | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento       | $1iuv                           |
            | codiceContestoPagamento               | $1ccp                           |
            | password                              | #password#                      |
            | identificativoPSP                     | #psp#                           |
            | identificativoIntermediarioPSP        | #id_broker_psp#                 |
            | identificativoCanale                  | #canale#                        |
            | rpt                                   | $rpt1Attachment                 |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        # STATI_RPT_SNAPSHOT
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP        | $1ccp                                         |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP        | $1ccp                                         |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        # RT
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $1ccp                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $1ccp                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old#       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | password                              | #password#                            |
            | identificativoDominio                 | #creditor_institution_code_old#       |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | $nodoInviaRPT.codiceContestoPagamento |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_PSP of nodoChiediStatoRPT response
        And checks stato contains RT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RT_ACCETTATA_PA of nodoChiediStatoRPT response
        And check redirect is 0 of nodoChiediStatoRPT response
        And check url field not exists in nodoChiediStatoRPT response
        And wait 5 seconds for expiration
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old#       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | password                              | #password#                            |
            | identificativoDominio                 | #creditor_institution_code_old#       |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | $nodoInviaRPT.codiceContestoPagamento |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_PSP of nodoChiediStatoRPT response
        And checks stato contains RT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RT_ACCETTATA_PA of nodoChiediStatoRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#                 |
            | identificativoCanale            | #canale#                        |
            | password                        | #password#                      |
            | identificativoPSP               | #psp#                           |
            | identificativoDominio           | #creditor_institution_code_old# |
            | identificativoUnivocoVersamento | $1iuv                           |
            | codiceContestoPagamento         | $1ccp                           |
            | forzaControlloSegno             | 1                               |
            | rt                              | $rtAttachment                   |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRT response
        And check faultCode is PPT_RT_DUPLICATA of nodoInviaRT response
        Given from body with datatable vertical nodoChiediStatoRPT initial XML nodoChiediStatoRPT
            | identificativoIntermediarioPA         | #creditor_institution_code_old#       |
            | identificativoStazioneIntermediarioPA | #id_station_old#                      |
            | password                              | #password#                            |
            | identificativoDominio                 | #creditor_institution_code_old#       |
            | identificativoUnivocoVersamento       | $1iuv                                 |
            | codiceContestoPagamento               | $nodoInviaRPT.codiceContestoPagamento |
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_PSP of nodoChiediStatoRPT response
        And checks stato contains RT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RT_ACCETTATA_PA of nodoChiediStatoRPT response
        And checks stato contains RT_RIFIUTATA_NODO of nodoChiediStatoRPT response
        And check redirect is 0 of nodoChiediStatoRPT response
        And check url field not exists in nodoChiediStatoRPT response
        # RT
        And verify 1 record for the table RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $1ccp                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                  |
            | IDENT_DOMINIO | $nodoInviaRPT.identificativoDominio           |
            | IUV           | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP           | $1ccp                                         |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                        |
        # STATI_RPT_SNAPSHOT
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP        | $1ccp                                         |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |
        # STATI_RPT_SNAPSHOT_GI
        And verify 1 record for the table STATI_RPT_SNAPSHOT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                  |
            | IUV        | $nodoInviaRPT.identificativoUnivocoVersamento |
            | CCP        | $1ccp                                         |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                        |




    # @ALL @FLOW  @INSERT @INSERT_26
    # Scenario: caso RPT annullata WISP con RT generato da job paInviaRT
    #     Given generate 1 notice number and iuv with aux digit 3, segregation code 46 and application code NA
    #     And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
    #         | identificativoDominio             | #creditor_institution_code# |
    #         | identificativoStazioneRichiedente | irraggiungibile             |
    #         | dataOraMessaggioRichiesta         | #timedate#                  |
    #         | dataEsecuzionePagamento           | #date#                      |
    #         | importoTotaleDaVersare            | 10.00                       |
    #         | tipoVersamento                    | PO                          |
    #         | identificativoUnivocoVersamento   | $1iuv                       |
    #         | codiceContestoPagamento           | #ccp1#                      |
    #         | importoSingoloVersamento          | 10.00                       |
    #     And RT generation RT_generation with datatable vertical
    #         | identificativoDominio             | #creditor_institution_code# |
    #         | identificativoStazioneRichiedente | irraggiungibile             |
    #         | dataOraMessaggioRicevuta          | #timedate#                  |
    #         | importoTotalePagato               | 10.00                       |
    #         | identificativoUnivocoVersamento   | $1iuv                       |
    #         | identificativoUnivocoRiscossione  | $1iuv                       |
    #         | CodiceContestoPagamento           | $1ccp                       |
    #         | codiceEsitoPagamento              | 0                           |
    #         | singoloImportoPagato              | 10.00                       |
    #     And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
    #         | identificativoIntermediarioPA         | irraggiungibile              |
    #         | identificativoStazioneIntermediarioPA | irraggiungibile              |
    #         | identificativoDominio                 | #creditor_institution_code#  |
    #         | identificativoUnivocoVersamento       | $1iuv                        |
    #         | codiceContestoPagamento               | $1ccp                        |
    #         | password                              | #password#                   |
    #         | identificativoPSP                     | #psp#                        |
    #         | identificativoIntermediarioPSP        | #id_broker_psp#              |
    #         | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP# |
    #         | rpt                                   | $rpt1Attachment              |
    #     When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    #     Then check esito is OK of nodoInviaRPT response
    #     Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
    #         | identificativoIntermediarioPSP  | #id_broker_psp#              |
    #         | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP# |
    #         | password                        | #password#                   |
    #         | identificativoPSP               | #psp#                        |
    #         | identificativoDominio           | #creditor_institution_code#  |
    #         | identificativoUnivocoVersamento | $1iuv                        |
    #         | codiceContestoPagamento         | $1ccp                        |
    #         | forzaControlloSegno             | 1                            |
    #         | rt                              | $rtAttachment                |
    #     When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
    #     Then check esito is OK of nodoInviaRT response
    #     And wait 5 seconds for expiration

    #     # RETRY_PA_INVIA_RT_GI
    #     And verify 1 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
    #         | where_keys | where_values                |
    #         | ID_DOMINIO | #creditor_institution_code# |
    #         | IUV        | $1iuv                       |
    #         | CCP        | $1ccp                       |

    #     # RETRY_PA_INVIA_RT
    #     And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
    #         | where_keys | where_values                |
    #         | ID_DOMINIO | #creditor_institution_code# |
    #         | IUV        | $1iuv                       |
    #         | CCP        | $1ccp                       |

    #     And replace ccp1 content with $1ccp content
    #     And replace iuv content with $1iuv content

    #     Given RPT2 generation RPT_generation_tipoVersamento with datatable vertical
    #         | identificativoDominio             | #creditor_institution_code# |
    #         | identificativoStazioneRichiedente | irraggiungibile             |
    #         | dataOraMessaggioRichiesta         | #timedate#                  |
    #         | dataEsecuzionePagamento           | #date#                      |
    #         | importoTotaleDaVersare            | 10.00                       |
    #         | tipoVersamento                    | BBT                         |
    #         | identificativoUnivocoVersamento   | $iuv                        |
    #         | codiceContestoPagamento           | #ccp2#                      |
    #         | importoSingoloVersamento          | 10.00                       |
    #     And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
    #         | identificativoIntermediarioPA         | irraggiungibile             |
    #         | identificativoStazioneIntermediarioPA | irraggiungibile             |
    #         | identificativoDominio                 | #creditor_institution_code# |
    #         | identificativoUnivocoVersamento       | $iuv                        |
    #         | codiceContestoPagamento               | $2ccp                       |
    #         | password                              | #password#                  |
    #         | identificativoPSP                     | #psp_AGID#                  |
    #         | identificativoIntermediarioPSP        | #broker_AGID#               |
    #         | identificativoCanale                  | #canale_AGID_BBT#           |
    #         | rpt                                   | $rpt2Attachment             |
    #     And generic update through the query param_update_generic_where_condition of the table RETRY_PA_INVIA_RT the parameter RETRY = '5', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
    #     And generic update through the query param_update_generic_where_condition of the table RETRY_PA_INVIA_RT the parameter CCP = '$2ccp', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
    #     And generic update through the query param_update_generic_where_condition of the table RETRY_PA_INVIA_RT_GI the parameter CCP = '$2ccp', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$ccp1' under macro update_query on db nodo_online
    #     And wait 5 seconds for expiration
    #     When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    #     Then check esito is OK of nodoInviaRPT response
    #     And retrieve session token from $nodoInviaRPTResponse.url

    #     When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
    #     Then verify the HTTP status code of informazioniPagamento response is 200

    #     Given generic update through the query param_update_generic_where_condition of the table STATI_RPT_SNAPSHOT the parameter STATO = 'RPT_ANNULLATA_WISP', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$2ccp' under macro update_query on db nodo_online
    #     And wait 5 seconds for expiration

    #     # RETRY_PA_INVIA_RT_GI
    #     And verify 1 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
    #         | where_keys | where_values                |
    #         | ID_DOMINIO | #creditor_institution_code# |
    #         | IUV        | $1iuv                       |
    #         | CCP        | $2ccp                       |

    #     # RETRY_PA_INVIA_RT
    #     And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
    #         | where_keys | where_values                |
    #         | ID_DOMINIO | #creditor_institution_code# |
    #         | IUV        | $1iuv                       |
    #         | CCP        | $2ccp                       |

    #     When job paInviaRt triggered after 5 seconds
    #     Then wait 7 seconds for expiration

    #     # RETRY_PA_INVIA_RT_GI
    #     And verify 1 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
    #         | where_keys | where_values                |
    #         | ID_DOMINIO | #creditor_institution_code# |
    #         | IUV        | $1iuv                       |
    #         | CCP        | $2ccp                       |

    #     # RETRY_PA_INVIA_RT
    #     And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
    #         | where_keys | where_values                |
    #         | ID_DOMINIO | #creditor_institution_code# |
    #         | IUV        | $1iuv                       |
    #         | CCP        | $2ccp                       |

    #     # STATI_RPT_SNAPSHOT
    #     And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
    #         | column      | value                                       |
    #         | ID_SESSIONE | $sessionToken                               |
    #         | STATO       | RPT_PARCHEGGIATA_NODO |
    #         | INSERTED_BY | nodoInviaRPT                   |
    #     And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
    #         | where_keys | where_values                |
    #         | ID_DOMINIO | #creditor_institution_code# |
    #         | IUV        | $1iuv                       |
    #         | CCP        | $2ccp                       |



    @ALL @FLOW  @INSERT @INSERT_25
    Scenario: nodoInviaRT - fare un invia rt e scrivere due volte nella tabella di retry (la stessa rt)
        Given generate 1 notice number and iuv with aux digit 3, segregation code 46 and application code NA
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | irraggiungibile             |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | PO                          |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | #ccp1#                      |
            | importoSingoloVersamento          | 10.00                       |
        And RT1 generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | irraggiungibile             |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | $1ccp                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | irraggiungibile              |
            | identificativoStazioneIntermediarioPA | irraggiungibile              |
            | identificativoDominio                 | #creditor_institution_code#  |
            | identificativoUnivocoVersamento       | $1iuv                        |
            | codiceContestoPagamento               | $1ccp                        |
            | password                              | #password#                   |
            | identificativoPSP                     | #psp#                        |
            | identificativoIntermediarioPSP        | #id_broker_psp#              |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP# |
            | rpt                                   | $rpt1Attachment              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#              |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP# |
            | password                        | #password#                   |
            | identificativoPSP               | #psp#                        |
            | identificativoDominio           | #creditor_institution_code#  |
            | identificativoUnivocoVersamento | $1iuv                        |
            | codiceContestoPagamento         | $1ccp                        |
            | forzaControlloSegno             | 1                            |
            | rt                              | $rt1Attachment               |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And wait 5 seconds for expiration
        # RETRY_PA_INVIA_RT_GI
        And verify 1 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                |
            | ID_DOMINIO | #creditor_institution_code# |
            | IUV        | $1iuv                       |
            | CCP        | $1ccp                       |
        # RETRY_PA_INVIA_RT
        And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                |
            | ID_DOMINIO | #creditor_institution_code# |
            | IUV        | $1iuv                       |
            | CCP        | $1ccp                       |
        And RPT2 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | irraggiungibile             |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | PO                          |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | #ccp2#                      |
            | importoSingoloVersamento          | 10.00                       |
        And RT2 generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | irraggiungibile             |
            | dataOraMessaggioRicevuta          | #timedate#                  |
            | importoTotalePagato               | 10.00                       |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | identificativoUnivocoRiscossione  | $1iuv                       |
            | CodiceContestoPagamento           | $2ccp                       |
            | codiceEsitoPagamento              | 0                           |
            | singoloImportoPagato              | 10.00                       |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | irraggiungibile              |
            | identificativoStazioneIntermediarioPA | irraggiungibile              |
            | identificativoDominio                 | #creditor_institution_code#  |
            | identificativoUnivocoVersamento       | $1iuv                        |
            | codiceContestoPagamento               | $2ccp                        |
            | password                              | #password#                   |
            | identificativoPSP                     | #psp#                        |
            | identificativoIntermediarioPSP        | #id_broker_psp#              |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP# |
            | rpt                                   | $rpt2Attachment              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And generic update through the query param_update_generic_where_condition of the table RETRY_PA_INVIA_RT the parameter RETRY = '5', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$1ccp' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table RETRY_PA_INVIA_RT the parameter CCP = '$2ccp', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$1ccp' under macro update_query on db nodo_online
        And generic update through the query param_update_generic_where_condition of the table RETRY_PA_INVIA_RT_GI the parameter CCP = '$2ccp', with where condition ID_DOMINIO = '$nodoInviaRPT.identificativoDominio' AND IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$1ccp' under macro update_query on db nodo_online
        And wait 5 seconds for expiration
        Given from body with datatable vertical nodoInviaRTBody_noOptional initial XML nodoInviaRT
            | identificativoIntermediarioPSP  | #id_broker_psp#              |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP# |
            | password                        | #password#                   |
            | identificativoPSP               | #psp#                        |
            | identificativoDominio           | #creditor_institution_code#  |
            | identificativoUnivocoVersamento | $1iuv                        |
            | codiceContestoPagamento         | $2ccp                        |
            | forzaControlloSegno             | 1                            |
            | rt                              | $rt2Attachment               |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And wait 5 seconds for expiration
        # RETRY_PA_INVIA_RT_GI
        And verify 1 record for the table RETRY_PA_INVIA_RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                |
            | ID_DOMINIO | #creditor_institution_code# |
            | IUV        | $1iuv                       |
            | CCP        | $2ccp                       |
        # RETRY_PA_INVIA_RT
        And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                |
            | ID_DOMINIO | #creditor_institution_code# |
            | IUV        | $1iuv                       |
            | CCP        | $2ccp                       |