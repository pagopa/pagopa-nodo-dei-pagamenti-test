Feature: TEST INSERT
    Background:
        Given systems up

    # test scritti a valle della necessità di inserire un partizionamento durante la migrazione da Oracle a Postgres

    @ALL @INSERT @INSERT_1
    Scenario: chiediStato_RPT_PARCHEGGIATA_NODO_Carrello
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
            | ORDER BY   | ID ASC       |
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
            | ORDER BY   | ID ASC       |
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



    @ALL @INSERT @INSERT_3
    Scenario: chiediStato_RPT_ESITO_SCONOSCIUTO_PSP_Carrello_sbloccoParcheggio
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
            | where_keys | where_values           |
            | IUV        | avanzaErrResponse      |
            | CCP        | $2ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |


    @ALL @INSERT @INSERT_4
    Scenario: chiediStato_RPT_RIFIUTATA_PSP
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
            | where_keys | where_values           |
            | IUV        | RPTdaRifPsp            |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |


    @ALL @INSERT @INSERT_5
    Scenario: chiediStato_RPT_ERRORE_INVIO_PSP_mod1
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
            | where_keys | where_values           |
            | IUV        | irraggiungibile        |
            | CCP        | $1ccp                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |

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


    @ALL @INSERT @INSERT_9
    Scenario: nodoInviaRPT - RT_ACCETTATA_PA
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
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |

        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |

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
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |

        # RT_GI
        And verify 1 record for the table RT_GI retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |

        # RETRY_PA_INVIA_RT
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values           |
            | IUV        | $1iuv                  |
            | ORDER BY   | INSERTED_TIMESTAMP ASC |


    @ALL @INSERT @INSERT_10
    Scenario: NotificaAnnullamento_RPT_CONPSP
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



    @ALL @INSERT @INSERT_11
    Scenario: close v2 ko con update sullo stato
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code 02
        And RPT1 generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | PO                          |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | #ccp1#                      |
            | importoSingoloVersamento          | 10.00                       |
        And RT generation RT_generation with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old# |
            | identificativoStazioneRichiedente | #id_station_old#                |
            | dataOraMessaggioRicevuta          | #timedate#                      |
            | importoTotalePagato               | 10.00                           |
            | identificativoUnivocoVersamento   | $1iuv                           |
            | identificativoUnivocoRiscossione  | $1iuv                           |
            | CodiceContestoPagamento           | $1ccp                           |
            | singoloImportoPagato              | 10.00                           |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker#                  |
            | identificativoStazioneIntermediarioPA | #id_station#                 |
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
            | identificativoIntermediarioPSP  | #id_broker#                  |
            | identificativoCanale            | #canale_ATTIVATO_PRESSO_PSP# |
            | password                        | #password#                   |
            | identificativoPSP               | #psp#                        |
            | identificativoDominio           | #creditor_institution_code#  |
            | identificativoUnivocoVersamento | $1iuv                        |
            | codiceContestoPagamento         | $1ccp                        |
            | forzaControlloSegno             | 1                            |
            | rt                              | $rtAttachment                |
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response
        And replace ccp1 content with $1ccp content
        Given from body with datatable vertical nodoAttivaRPT initial XML nodoAttivaRPT
            | identificativoPSP                       | #psp_AGID#        |
            | identificativoIntermediarioPSP          | #broker_AGID#     |
            | identificativoCanale                    | #canale_AGID#     |
            | password                                | #password#        |
            | codiceContestoPagamento                 | #ccp#             |
            | identificativoIntermediarioPSPPagamento | #broker_AGID#     |
            | identificativoCanalePagamento           | #canale_AGID_BBT# |
            | qrc:CF                                  | #ccPoste#         |
            | qrc:CodStazPA                           | #cod_segr#        |
            | qrc:AuxDigit                            | 0                 |
            | qrc:CodIUV                              | $1iuv             |
            | importoSingoloVersamento                | 10.00             |
        And from body with datatable horizontal paaAttivaRPT_noOptional initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 10.00                    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When EC sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
        And replace ccp2 content with $ccp content
        Given RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code# |
            | identificativoStazioneRichiedente | #id_station#                |
            | dataOraMessaggioRichiesta         | #timedate#                  |
            | dataEsecuzionePagamento           | #date#                      |
            | importoTotaleDaVersare            | 10.00                       |
            | tipoVersamento                    | PO                          |
            | identificativoUnivocoVersamento   | $1iuv                       |
            | codiceContestoPagamento           | $ccp2                       |
            | importoSingoloVersamento          | 10.00                       |
        And from body with datatable vertical nodoInviaRPT initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker#                 |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | identificativoDominio                 | #creditor_institution_code# |
            | identificativoUnivocoVersamento       | $1iuv                       |
            | codiceContestoPagamento               | $ccp2                       |
            | password                              | #password#                  |
            | identificativoPSP                     | #psp_AGID#                  |
            | identificativoIntermediarioPSP        | #broker_AGID#               |
            | identificativoCanale                  | #canale_AGID_BBT#           |
            | rpt                                   | $rptAttachment              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And retrieve session token from $nodoInviaRPTResponse.url

        Given generic update through the query param_update_generic_where_condition of the table RT the parameter CCP = '$ccp2', with where condition IUV='$nodoInviaRPT.identificativoUnivocoVersamento' AND CCP ='$1iuv' under macro update_query on db nodo_online
        And wait 5 seconds for expiration

        Given from body with datatable vertical closePaymentBody initial json v1closepayment
            | token1                      | $sessionToken                        |
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
        Then verify the HTTP status code of v1/closepayment response is 200
        And check outcome is OK of v1/closepayment response
