Feature: BUG PROD


    Background:
        Given systems up    
    
    # process tests for generazioneRicevute 1337
    @ALL @FLOW @FLOW_FULL @BUG @BUG_2 @after
    Scenario: NM3 flow OK, FLOW con PA Old e PSP vp1 activate e PSP vp1 spo: verify -> activate -> nodoInviaRPT  mod3CancelV1 -> activate -> nodoInviaRPT -> spo+ (NM3-84)
        Given from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     |
        When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312$iuv      | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice_1
        # RPT_ACTIVATIONS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | PAAATTIVARPTRESP      | Y                                           |
            | NODOINVIARPTREQ       | N                                           |
            | PAAATTIVARPTERROR     | N                                           |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
            | RETRY_PENDING         | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                |
            | PAYMENT_TOKEN  | $activatePaymentNoticeResponse.paymentToken |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode           |
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | $activatePaymentNotice.fiscalCode           |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | $activatePaymentNotice.fiscalCode           |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | $activatePaymentNotice.fiscalCode           |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #pspFittizio#                               |
            | identificativoIntermediarioPSP        | #brokerFittizio#                            |
            | identificativoCanale                  | #canaleFittizio#                            |
            | rpt                                   | $rptAttachment                              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        When job mod3CancelV1 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                        | noticeNumber                        | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice.fiscalCode | $activatePaymentNotice.noticeNumber | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice_2
        Given RPT generation RPT_generation with datatable vertical
            | identificativoDominio             | $activatePaymentNotice.fiscalCode           |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | $activatePaymentNotice.fiscalCode           |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | $activatePaymentNotice.fiscalCode           |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #pspFittizio#                               |
            | identificativoIntermediarioPSP        | #brokerFittizio#                            |
            | identificativoCanale                  | #canaleFittizio#                            |
            | rpt                                   | $rptAttachment                              |
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response
        # RPT_ACTIVATIONS
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode             |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                        |
            | PAYMENT_TOKEN              | $activatePaymentNotice_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode             |
            | STATION_ID                 | #id_station_old#                              |
            | STATION_VERSION            | 1                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                  |
            | IDEMPOTENCY_KEY            | NotNone                                       |
            | AMOUNT                     | $activatePaymentNotice.amount                 |
            | FEE                        | 2.00                                          |
            | OUTCOME                    | OK                                            |
            | PAYMENT_METHOD             | creditCard                                    |
            | PAYMENT_CHANNEL            | app                                           |
            | TRANSFER_DATE              | 2021-12-11                                    |
            | PAYER_ID                   | NotNone                                       |
            | APPLICATION_DATE           | 2021-12-12                                    |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | NotNone                                       |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | N                                             |
            | RICEVUTA_PM                | None                                          |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | FLAG_PAYPAL                | None                                          |
            | INSERTED_BY                | activatePaymentNotice                         |
            | UPDATED_BY                 | sendPaymentOutcome                            |
            | TRANSACTION_ID             | None                                          |
            | CLOSE_VERSION              | None                                          |
            | FEE_PA                     | None                                          |
            | BUNDLE_ID                  | None                                          |
            | BUNDLE_PA_ID               | None                                          |
            | PM_INFO                    | None                                          |
            | MBD                        | N                                             |
            | FEE_SPO                    | 2                                             |
            | PAYMENT_NOTE               | responseFull                                  |
            | FLAG_STANDIN               | N                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                  |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber           |
            | PAYMENT_TOKEN  | $activatePaymentNotice_2Response.paymentToken |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode             |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                                                                                                                                                                                                                                                           |
            | ID                    | NotNone                                                                                                                                                                                                                                                                                                                                                                         |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                                                                                                                                                                                                                                                                                                               |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                                                                                                                                                                                                                                                                                                             |
            | STATUS                | PAYING,PAYING_RPT,CANCELLED,PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED                                                                                                                                                                                                                                                                                               |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                                                                                                                                                                                                                                                         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                                                                                                                                                                                                                                                                                                          |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,nodoInviaRPT,mod3CancelV1,activatePaymentNotice,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome                                                                                                                                                                                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                       |
            | ID                    | NotNone                                                                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                      |
            | PAYMENT_TOKEN         | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | STATUS                | CANCELLED,NOTICE_STORED                                                                     |
            | INSERTED_TIMESTAMP    | NotNone                                                                                     |
            | UPDATED_TIMESTAMP     | NotNone                                                                                     |
            | FK_POSITION_PAYMENT   | NotNone                                                                                     |
            | INSERTED_BY           | activatePaymentNotice,activatePaymentNotice                                                 |
            | UPDATED_BY            | mod3CancelV1,sendPaymentOutcome                                                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC           |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                                                                                                                                                                                                                                                                                                         |
            | ID                    | NotNone                                                                                                                                                                                                                                                                                                                                                                                                                       |
            | ID_SESSIONE           | NotNone                                                                                                                                                                                                                                                                                                                                                                                                                       |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                                                                                                                                                                                                                                                                                                                                                                       |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                                                                                                                                                                                                                                                                                                                                                                             |
            | IUV                   | 12$iuv                                                                                                                                                                                                                                                                                                                                                                                                                        |
            | CCP                   | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO                                                                                                                                                                                                                                              |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,mod3CancelV1,nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,sendPaymentOutcome,sendPaymentOutcome                                                                                                                                                                                                                                                                                              |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                                                                                                                                                                                                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 9 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                                                       |
            | ID_SESSIONE        | NotNone                                                                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode                                                           |
            | IUV                | 12$iuv                                                                                      |
            | CCP                | $activatePaymentNotice_1Response.paymentToken,$activatePaymentNotice_2Response.paymentToken |
            | STATO              | RT_GENERATA_NODO,RT_GENERATA_NODO                                                           |
            | INSERTED_BY        | nodoInviaRPT,nodoInviaRPT                                                                   |
            | UPDATED_BY         | mod3CancelV1,sendPaymentOutcome                                                             |
            | INSERTED_TIMESTAMP | NotNone                                                                                     |
            | UPDATED_TIMESTAMP  | NotNone                                                                                     |
            | PUSH               | None                                                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 2 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                      | value                                       |
            | ID_SESSIONE                 | NotNone                                     |
            | IDENT_DOMINIO               | $activatePaymentNotice.fiscalCode           |
            | IUV                         | 12$iuv                                      |
            | CCP                         | $activatePaymentNoticeResponse.paymentToken |
            | BIC_ADDEBITO                | NotNone                                     |
            | DATA_MSG_RICH               | NotNone                                     |
            | FLAG_CANC                   | N                                           |
            | IBAN_ADDEBITO               | NotNone                                     |
            | ID_MSG_RICH                 | NotNone                                     |
            | STAZ_INTERMEDIARIOPA        | #id_station_old#                            |
            | INTERMEDIARIOPA             | #id_broker_old#                             |
            | CANALE                      | #canaleFittizio#                            |
            | PSP                         | #pspFittizio#                               |
            | INTERMEDIARIOPSP            | #brokerFittizio#                            |
            | TIPO_VERSAMENTO             | PO                                          |
            | NUM_VERSAMENTI              | 1                                           |
            | RT_SIGNATURE_CODE           | 0                                           |
            | SOMMA_VERSAMENTI            | 10                                          |
            | PARAMETRI_PROFILO_PAGAMENTO | None                                        |
            | FK_CARRELLO                 | None                                        |
            | INSERTED_TIMESTAMP          | NotNone                                     |
            | UPDATED_TIMESTAMP           | NotNone                                     |
            | RICEVUTA_PM                 | N                                           |
            | WISP_2                      | N                                           |
            | FLAG_SECONDA                | None                                        |
            | FLAG_IO                     | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | IUV           | 12$iuv                                      |
            | IDENT_DOMINIO | $activatePaymentNotice.fiscalCode           |
            | CCP           | $activatePaymentNoticeResponse.paymentToken |
        And verify 1 record for the table RPT retrived by the query on db nodo_online with where datatable horizontal
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
            | COD_ESITO           | 0                                           |
            | ESITO               | ESEGUITO                                    |
            | DATA_RICEVUTA       | NotNone                                     |
            | DATA_RICHIESTA      | NotNone                                     |
            | ID_RICEVUTA         | NotNone                                     |
            | ID_RICHIESTA        | NotNone                                     |
            | SOMMA_VERSAMENTI    | 10                                          |
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
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                       |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value OK in position 0
        # nodoInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO  | REQ                                         |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTReq
        And from $nodoInviaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoDominio xml check value $activatePaymentNotice.fiscalCode in position 0
        And from $nodoInviaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $nodoInviaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $nodoInviaRPTReq.codiceContestoPagamento xml check value $activatePaymentNoticeResponse.paymentToken in position 0
        And from $nodoInviaRPTReq.password xml check value #password# in position 0
        And from $nodoInviaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $nodoInviaRPTReq.identificativoCanale xml check value #canaleFittizio# in position 0
        And from $nodoInviaRPTReq.rpt xml check value $rptAttachment in position 0
        # nodoInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | nodoInviaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | INVIATA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key nodoInviaRPTResp
        And from $nodoInviaRPTResp.esito xml check value OK in position 0
        And from $nodoInviaRPTResp.redirect xml check value 0 in position 0