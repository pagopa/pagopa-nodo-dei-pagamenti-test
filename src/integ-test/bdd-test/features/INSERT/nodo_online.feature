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



    @ALL @INSERT @INSERT_2
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