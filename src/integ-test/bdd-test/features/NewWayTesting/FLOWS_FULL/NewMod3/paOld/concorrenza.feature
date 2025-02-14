Feature: NM3 flows PA Old con concorrenza

    Background:
        Given systems up

    # AccessiConcorrenziali 3a_ACT_SPO
    # ACT -> SPO+  (ACT: OK - SPO: KO PPT_SEMANTICA  Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_1
    Scenario: NM3 flow KO, FLOW: activate -> mod3CancelV1 -> activate -> paaAttivaRPT & spo+ in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-1A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 1000  | OK    | 8.00                     |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 750 ms delay
        And save activatePaymentNotice response in activatePaymentNotice2
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                    |
            | PSP_ID                | #psp#                                                                                     |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                                                                   |
            | TOKEN_VALID_TO        | NotNone                                                                                   |
            | DUE_DATE              | 2021-12-31 00:00:00                                                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice.amount                      |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice                                                                     |
            | UPDATED_BY            | activatePaymentNotice                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                         |
            | ID                    | NotNone                                                                       |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                        |
            | DUE_DATE              | NotNone                                                                       |
            | RETENTION_DATE        | None                                                                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                       |
            | UPDATED_TIMESTAMP     | NotNone                                                                       |
            | METADATA              | None                                                                          |
            | FK_POSITION_SERVICE   | NotNone                                                                       |
            | INSERTED_BY           | activatePaymentNotice                                                         |
            | UPDATED_BY            | activatePaymentNotice                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                                                         |
            | ID                       | NotNone                                                                       |
            | CREDITOR_REFERENCE_ID    | 12$iuv                                                                        |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode                                    |
            | IBAN                     | IT45R0760103200000000001016                                                   |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount |
            | REMITTANCE_INFORMATION   | NotNone                                                                       |
            | TRANSFER_CATEGORY        | None                                                                          |
            | TRANSFER_IDENTIFIER      | 1                                                                             |
            | VALID                    | Y                                                                             |
            | FK_POSITION_PAYMENT      | NotNone                                                                       |
            | INSERTED_TIMESTAMP       | NotNone                                                                       |
            | UPDATED_TIMESTAMP        | NotNone                                                                       |
            | FK_PAYMENT_PLAN          | NotNone                                                                       |
            | INSERTED_BY              | activatePaymentNotice                                                         |
            | UPDATED_BY               | activatePaymentNotice                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                     |
            | ID                         | NotNone                                                                                   |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode                                                         |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                                                                    |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode                                                |
            | STATION_ID                 | #id_station_old#                                                                          |
            | STATION_VERSION            | 1                                                                                         |
            | PSP_ID                     | #psp#                                                                                     |
            | BROKER_PSP_ID              | #psp#                                                                                     |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                                                              |
            | IDEMPOTENCY_KEY            | NotNone                                                                                   |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount             |
            | FEE                        | None                                                                                      |
            | OUTCOME                    | None                                                                                      |
            | PAYMENT_METHOD             | None                                                                                      |
            | PAYMENT_CHANNEL            | NotNone                                                                                   |
            | TRANSFER_DATE              | None                                                                                      |
            | PAYER_ID                   | None                                                                                      |
            | APPLICATION_DATE           | None                                                                                      |
            | INSERTED_TIMESTAMP         | NotNone                                                                                   |
            | UPDATED_TIMESTAMP          | NotNone                                                                                   |
            | FK_PAYMENT_PLAN            | NotNone                                                                                   |
            | RPT_ID                     | None                                                                                      |
            | PAYMENT_TYPE               | MOD3                                                                                      |
            | CARRELLO_ID                | None                                                                                      |
            | ORIGINAL_PAYMENT_TOKEN     | None                                                                                      |
            | FLAG_IO                    | N                                                                                         |
            | RICEVUTA_PM                | None                                                                                      |
            | FLAG_ACTIVATE_RESP_MISSING | None                                                                                      |
            | FLAG_PAYPAL                | None                                                                                      |
            | INSERTED_BY                | activatePaymentNotice                                                                     |
            | UPDATED_BY                 | activatePaymentNotice                                                                     |
            | TRANSACTION_ID             | None                                                                                      |
            | CLOSE_VERSION              | None                                                                                      |
            | FEE_PA                     | None                                                                                      |
            | BUNDLE_ID                  | None                                                                                      |
            | BUNDLE_PA_ID               | None                                                                                      |
            | PM_INFO                    | None                                                                                      |
            | MBD                        | N                                                                                         |
            | FEE_SPO                    | None                                                                                      |
            | PAYMENT_NOTE               | responseFull                                                                              |
            | FLAG_STANDIN               | N                                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                  |
            | ID                    | NotNone                                                                                                                                |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                                                             |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                                                                           |
            | STATUS                | PAYING,CANCELLED_NORPT,PAYING                                                                                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                                                                 |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1,activatePaymentNotice                                                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                              |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                    |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | STATUS                | CANCELLED_NORPT,PAYING                                                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | FK_POSITION_PAYMENT   | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice,activatePaymentNotice                                               |
            | UPDATED_BY            | mod3CancelV1,activatePaymentNotice                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # STATI_RPT
        And verify 0 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
        # paaInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0





    # AccessiConcorrenziali 3a_ACT_SPO
    # SPO+ -> ACT (ACT: KO  PPT_PAGAMENTO_DUPLICATO - SPO: KO PPT_TOKEN_SCADUTO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_2
    Scenario: NM3 flow KO, FLOW: activate -> mod3CancelV1 -> spo+ & activate -> paaAttivaRPT in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-1A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 1000  | OK    | 8.00                     |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 50 ms delay
        And save activatePaymentNotice response in activatePaymentNotice2
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PSP_ID                | #psp#                                        |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                      |
            | TOKEN_VALID_TO        | NotNone                                      |
            | DUE_DATE              | 2021-12-31 00:00:00                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount       |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | None                                   |
            | FK_POSITION_SERVICE   | NotNone                                |
            | INSERTED_BY           | activatePaymentNotice                  |
            | UPDATED_BY            | activatePaymentNotice                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                      |
            | ID                       | NotNone                                    |
            | CREDITOR_REFERENCE_ID    | 12$iuv                                     |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                    |
            | TRANSFER_CATEGORY        | None                                       |
            | TRANSFER_IDENTIFIER      | 1                                          |
            | VALID                    | Y                                          |
            | FK_POSITION_PAYMENT      | NotNone                                    |
            | INSERTED_TIMESTAMP       | NotNone                                    |
            | UPDATED_TIMESTAMP        | NotNone                                    |
            | FK_PAYMENT_PLAN          | NotNone                                    |
            | INSERTED_BY              | activatePaymentNotice                      |
            | UPDATED_BY               | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC                      |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                        |
            | ID                         | NotNone                                      |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode   |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                       |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode   |
            | STATION_ID                 | #id_station_old#                             |
            | STATION_VERSION            | 1                                            |
            | PSP_ID                     | #psp#                                        |
            | BROKER_PSP_ID              | #psp#                                        |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                 |
            | IDEMPOTENCY_KEY            | NotNone                                      |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount       |
            | FEE                        | 2.00                                         |
            | OUTCOME                    | OK                                           |
            | PAYMENT_METHOD             | creditCard                                   |
            | PAYMENT_CHANNEL            | app                                          |
            | TRANSFER_DATE              | 2021-12-11                                   |
            | PAYER_ID                   | NotNone                                      |
            | APPLICATION_DATE           | NotNone                                      |
            | INSERTED_TIMESTAMP         | NotNone                                      |
            | UPDATED_TIMESTAMP          | NotNone                                      |
            | FK_PAYMENT_PLAN            | NotNone                                      |
            | RPT_ID                     | None                                         |
            | PAYMENT_TYPE               | MOD3                                         |
            | CARRELLO_ID                | None                                         |
            | ORIGINAL_PAYMENT_TOKEN     | None                                         |
            | FLAG_IO                    | N                                            |
            | RICEVUTA_PM                | None                                         |
            | FLAG_ACTIVATE_RESP_MISSING | None                                         |
            | FLAG_PAYPAL                | None                                         |
            | INSERTED_BY                | activatePaymentNotice                        |
            | UPDATED_BY                 | sendPaymentOutcome                           |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                         |
            | FEE_PA                     | None                                         |
            | BUNDLE_ID                  | None                                         |
            | BUNDLE_PA_ID               | None                                         |
            | PM_INFO                    | None                                         |
            | MBD                        | N                                            |
            | FEE_SPO                    | None                                         |
            | PAYMENT_NOTE               | responseFull                                 |
            | FLAG_STANDIN               | N                                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                 |
            | ID                    | NotNone                                               |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode            |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber          |
            | STATUS                | PAYING,CANCELLED_NORPT,PAID_NORPT                     |
            | INSERTED_TIMESTAMP    | NotNone                                               |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken          |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | STATUS                | PAID_NORPT                                   |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | FK_POSITION_PAYMENT   | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | sendPaymentOutcome                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # STATI_RPT
        And verify 0 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 125$iuv      |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
        # paaInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0







    # AccessiConcorrenziali 3b_ACT_SPO
    # ACT -> SPO- (ACT: OK - SPO: PPT_SEMANTICA Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_3
    Scenario: NM3 flow KO, FLOW: activate -> mod3CancelV1 ->  activate -> paaAttivaRPT  & spo- in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-2A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 1 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And from body with datatable horizontal paaAttivaRPT_delay_noOptional initial XML paaAttivaRPT
            | delay | esito | importoSingoloVersamento |
            | 1000  | OK    | 8.00                     |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 750 ms delay
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And save activatePaymentNotice response in activatePaymentNotice2
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                    |
            | PSP_ID                | #psp#                                                                                     |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                                                                   |
            | TOKEN_VALID_TO        | NotNone                                                                                   |
            | DUE_DATE              | 2021-12-31 00:00:00                                                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice.amount                      |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice                                                                     |
            | UPDATED_BY            | activatePaymentNotice                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                         |
            | ID                    | NotNone                                                                       |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                        |
            | DUE_DATE              | NotNone                                                                       |
            | RETENTION_DATE        | None                                                                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                       |
            | UPDATED_TIMESTAMP     | NotNone                                                                       |
            | METADATA              | None                                                                          |
            | FK_POSITION_SERVICE   | NotNone                                                                       |
            | INSERTED_BY           | activatePaymentNotice                                                         |
            | UPDATED_BY            | activatePaymentNotice                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                                                         |
            | ID                       | NotNone                                                                       |
            | CREDITOR_REFERENCE_ID    | 12$iuv                                                                        |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode                                    |
            | IBAN                     | IT45R0760103200000000001016                                                   |
            | AMOUNT                   | $activatePaymentNotice_2Request.amount,$activatePaymentNotice_1Request.amount |
            | REMITTANCE_INFORMATION   | NotNone                                                                       |
            | TRANSFER_CATEGORY        | None                                                                          |
            | TRANSFER_IDENTIFIER      | 1                                                                             |
            | VALID                    | Y                                                                             |
            | FK_POSITION_PAYMENT      | NotNone                                                                       |
            | INSERTED_TIMESTAMP       | NotNone                                                                       |
            | UPDATED_TIMESTAMP        | NotNone                                                                       |
            | FK_PAYMENT_PLAN          | NotNone                                                                       |
            | INSERTED_BY              | activatePaymentNotice                                                         |
            | UPDATED_BY               | activatePaymentNotice                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC                      |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP DESC                      |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                     |
            | ID                         | NotNone                                                                                   |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode                                                |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                                                                    |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode                                                |
            | STATION_ID                 | #id_station_old#                                                                          |
            | STATION_VERSION            | 1                                                                                         |
            | PSP_ID                     | #psp#                                                                                     |
            | BROKER_PSP_ID              | #psp#                                                                                     |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                                                              |
            | IDEMPOTENCY_KEY            | NotNone                                                                                   |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount             |
            | FEE                        | None                                                                                      |
            | OUTCOME                    | None                                                                                      |
            | PAYMENT_METHOD             | None                                                                                      |
            | PAYMENT_CHANNEL            | NotNone                                                                                   |
            | TRANSFER_DATE              | None                                                                                      |
            | PAYER_ID                   | None                                                                                      |
            | APPLICATION_DATE           | None                                                                                      |
            | INSERTED_TIMESTAMP         | NotNone                                                                                   |
            | UPDATED_TIMESTAMP          | NotNone                                                                                   |
            | FK_PAYMENT_PLAN            | NotNone                                                                                   |
            | RPT_ID                     | None                                                                                      |
            | PAYMENT_TYPE               | MOD3                                                                                      |
            | CARRELLO_ID                | None                                                                                      |
            | ORIGINAL_PAYMENT_TOKEN     | None                                                                                      |
            | FLAG_IO                    | N                                                                                         |
            | RICEVUTA_PM                | None                                                                                      |
            | FLAG_ACTIVATE_RESP_MISSING | None                                                                                      |
            | FLAG_PAYPAL                | None                                                                                      |
            | INSERTED_BY                | activatePaymentNotice                                                                     |
            | UPDATED_BY                 | activatePaymentNotice                                                                     |
            | TRANSACTION_ID             | None                                                                                      |
            | CLOSE_VERSION              | None                                                                                      |
            | FEE_PA                     | None                                                                                      |
            | BUNDLE_ID                  | None                                                                                      |
            | BUNDLE_PA_ID               | None                                                                                      |
            | PM_INFO                    | None                                                                                      |
            | MBD                        | N                                                                                         |
            | FEE_SPO                    | None                                                                                      |
            | PAYMENT_NOTE               | responseFull                                                                              |
            | FLAG_STANDIN               | N                                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                  |
            | ID                    | NotNone                                                                                                                                |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                                                             |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                                                                           |
            | STATUS                | PAYING,CANCELLED_NORPT,PAYING                                                                                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                                                                 |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1,activatePaymentNotice                                                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                              |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                    |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | STATUS                | CANCELLED_NORPT,PAYING                                                                    |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | FK_POSITION_PAYMENT   | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice,activatePaymentNotice                                               |
            | UPDATED_BY            | mod3CancelV1,activatePaymentNotice                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # STATI_RPT
        And verify 0 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 125$iuv      |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
        # paaInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0




    # AccessiConcorrenziali 3b_ACT_SPO
    # SPO- -> ACT (ACT: OK - SPO: PPT_TOKEN_SCADUTO_KO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_4
    Scenario: NM3 flow KO, FLOW: activate -> mod3CancelV1 -> spo- & activate in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-2A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 0 ms delay
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And save activatePaymentNotice response in activatePaymentNotice2
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                    |
            | PSP_ID                | #psp#                                                                                     |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                                                                   |
            | TOKEN_VALID_TO        | NotNone                                                                                   |
            | DUE_DATE              | 2021-12-31 00:00:00                                                                       |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount             |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice                                                                     |
            | UPDATED_BY            | activatePaymentNotice                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | None                                   |
            | FK_POSITION_SERVICE   | NotNone                                |
            | INSERTED_BY           | activatePaymentNotice                  |
            | UPDATED_BY            | activatePaymentNotice                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                  |
            | ID                       | NotNone                                |
            | CREDITOR_REFERENCE_ID    | 12$iuv                                 |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode      |
            | IBAN                     | IT45R0760103200000000001016            |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount |
            | REMITTANCE_INFORMATION   | NotNone                                |
            | TRANSFER_CATEGORY        | None                                   |
            | TRANSFER_IDENTIFIER      | 1                                      |
            | VALID                    | Y,N                                    |
            | FK_POSITION_PAYMENT      | NotNone                                |
            | INSERTED_TIMESTAMP       | NotNone                                |
            | UPDATED_TIMESTAMP        | NotNone                                |
            | FK_PAYMENT_PLAN          | NotNone                                |
            | INSERTED_BY              | activatePaymentNotice                  |
            | UPDATED_BY               | activatePaymentNotice                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC                      |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                     |
            | ID                         | NotNone                                                                                   |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode                                                |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                                                                    |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode                                                |
            | STATION_ID                 | #id_station_old#                                                                          |
            | STATION_VERSION            | 1                                                                                         |
            | PSP_ID                     | #psp#                                                                                     |
            | BROKER_PSP_ID              | #psp#                                                                                     |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                                                              |
            | IDEMPOTENCY_KEY            | NotNone                                                                                   |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount                                                    |
            | FEE                        | 2.00,None                                                                                 |
            | OUTCOME                    | KO,None                                                                                   |
            | PAYMENT_METHOD             | creditCard,None                                                                           |
            | PAYMENT_CHANNEL            | app,NA                                                                                    |
            | TRANSFER_DATE              | 2021-12-11,None                                                                           |
            | PAYER_ID                   | NotNone,None                                                                              |
            | APPLICATION_DATE           | NotNone,None                                                                              |
            | INSERTED_TIMESTAMP         | NotNone                                                                                   |
            | UPDATED_TIMESTAMP          | NotNone                                                                                   |
            | FK_PAYMENT_PLAN            | NotNone                                                                                   |
            | RPT_ID                     | None                                                                                      |
            | PAYMENT_TYPE               | MOD3                                                                                      |
            | CARRELLO_ID                | None                                                                                      |
            | ORIGINAL_PAYMENT_TOKEN     | None                                                                                      |
            | FLAG_IO                    | N                                                                                         |
            | RICEVUTA_PM                | None                                                                                      |
            | FLAG_ACTIVATE_RESP_MISSING | None                                                                                      |
            | FLAG_PAYPAL                | None                                                                                      |
            | INSERTED_BY                | activatePaymentNotice,activatePaymentNotice                                               |
            | UPDATED_BY                 | sendPaymentOutcome,activatePaymentNotice                                                  |
            | TRANSACTION_ID             | None                                                                                      |
            | CLOSE_VERSION              | None                                                                                      |
            | FEE_PA                     | None                                                                                      |
            | BUNDLE_ID                  | None                                                                                      |
            | BUNDLE_PA_ID               | None                                                                                      |
            | PM_INFO                    | None                                                                                      |
            | MBD                        | N                                                                                         |
            | FEE_SPO                    | None                                                                                      |
            | PAYMENT_NOTE               | responseFull                                                                              |
            | FLAG_STANDIN               | N                                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                                                               |
            | ID                    | NotNone                                                                                                                                                                             |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                                                                                                          |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                                                                                                                        |
            | STATUS                | PAYING,CANCELLED_NORPT,FAILED_NORPT,PAYING                                                                                                                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                                                             |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                                                                                                              |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice1Response.paymentToken,$activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1,sendPaymentOutcome,activatePaymentNotice                                                                                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                              |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                                                    |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | STATUS                | FAILED_NORPT,PAYING                                                                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | FK_POSITION_PAYMENT   | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice,activatePaymentNotice                                               |
            | UPDATED_BY            | sendPaymentOutcome,activatePaymentNotice                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # STATI_RPT
        And verify 0 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 125$iuv      |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
        # paaInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0






    # AccessiConcorrenziali 3e_ACT_SPO
    # ACT -> SPO+ (ACT:KO - SPO: PPT_SEMANTICA Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_5
    Scenario: NM3 flow KO, FLOW: activate -> mod3CancelV1 -> activate & spo+ in pararallel mode-> KO PPT_SEMANTICA  (OLD_NM3-5A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 9.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        And from body with datatable horizontal paaAttivaRPT_KO initial XML paaAttivaRPT
            | faultCode             | faultString          | id                              | description                       | esito |
            | PAA_SINTASSI_EXTRAXSD | errore sintattico PA | #creditor_institution_code_old# | Errore sintattico emesso dalla PA | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 80 ms delay
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And save activatePaymentNotice response in activatePaymentNotice2
        Then check outcome is KO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PSP_ID                | #psp#                                        |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                      |
            | TOKEN_VALID_TO        | NotNone                                      |
            | DUE_DATE              | 2021-12-31 00:00:00                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount       |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC LIMIT 1               |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | None                                   |
            | FK_POSITION_SERVICE   | NotNone                                |
            | INSERTED_BY           | activatePaymentNotice                  |
            | UPDATED_BY            | activatePaymentNotice                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                      |
            | ID                       | NotNone                                    |
            | CREDITOR_REFERENCE_ID    | 12$iuv                                     |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                    |
            | TRANSFER_CATEGORY        | None                                       |
            | TRANSFER_IDENTIFIER      | 1                                          |
            | VALID                    | Y                                          |
            | FK_POSITION_PAYMENT      | NotNone                                    |
            | INSERTED_TIMESTAMP       | NotNone                                    |
            | UPDATED_TIMESTAMP        | NotNone                                    |
            | FK_PAYMENT_PLAN          | NotNone                                    |
            | INSERTED_BY              | activatePaymentNotice                      |
            | UPDATED_BY               | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC                      |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                        |
            | ID                         | NotNone                                      |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode   |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                       |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode   |
            | STATION_ID                 | #id_station_old#                             |
            | STATION_VERSION            | 1                                            |
            | PSP_ID                     | #psp#                                        |
            | BROKER_PSP_ID              | #psp#                                        |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                 |
            | IDEMPOTENCY_KEY            | NotNone                                      |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount       |
            | FEE                        | None                                         |
            | OUTCOME                    | None                                         |
            | PAYMENT_METHOD             | None                                         |
            | PAYMENT_CHANNEL            | NA                                           |
            | TRANSFER_DATE              | None                                         |
            | PAYER_ID                   | None                                         |
            | APPLICATION_DATE           | None                                         |
            | INSERTED_TIMESTAMP         | NotNone                                      |
            | UPDATED_TIMESTAMP          | NotNone                                      |
            | FK_PAYMENT_PLAN            | NotNone                                      |
            | RPT_ID                     | None                                         |
            | PAYMENT_TYPE               | MOD3                                         |
            | CARRELLO_ID                | None                                         |
            | ORIGINAL_PAYMENT_TOKEN     | None                                         |
            | FLAG_IO                    | N                                            |
            | RICEVUTA_PM                | None                                         |
            | FLAG_ACTIVATE_RESP_MISSING | None                                         |
            | FLAG_PAYPAL                | None                                         |
            | INSERTED_BY                | activatePaymentNotice                        |
            | UPDATED_BY                 | activatePaymentNotice                        |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                         |
            | FEE_PA                     | None                                         |
            | BUNDLE_ID                  | None                                         |
            | BUNDLE_PA_ID               | None                                         |
            | PM_INFO                    | None                                         |
            | MBD                        | N                                            |
            | FEE_SPO                    | None                                         |
            | PAYMENT_NOTE               | responseFull                                 |
            | FLAG_STANDIN               | N                                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS                | PAYING,CANCELLED_NORPT                       |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | STATUS                | CANCELLED_NORPT                              |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | FK_POSITION_PAYMENT   | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | mod3CancelV1                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # STATI_RPT
        And verify 0 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 125$iuv      |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
        # paaInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0





    # AccessiConcorrenziali 3e_ACT_SPO
    # SPO+ - ACT (ACT:OK - SPO: PPT_TOKEN_SCADUTO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_6
    Scenario: NM3 flow KO, FLOW: activate -> mod3CancelV1 -> activate & spo+ in pararallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-5A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  | 2000           |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV1 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV1 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | $activatePaymentNotice_1Request.noticeNumber | 9.00   |
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        And from body with datatable horizontal paaAttivaRPT_KO initial XML paaAttivaRPT
            | faultCode             | faultString          | id                              | description                       | esito |
            | PAA_SINTASSI_EXTRAXSD | errore sintattico PA | #creditor_institution_code_old# | Errore sintattico emesso dalla PA | KO    |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 0 ms delay
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And save activatePaymentNotice response in activatePaymentNotice2
        Then check outcome is KO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PSP_ID                | #psp#                                        |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                      |
            | TOKEN_VALID_TO        | NotNone                                      |
            | DUE_DATE              | 2021-12-31 00:00:00                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount       |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC LIMIT 1               |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | None                                   |
            | FK_POSITION_SERVICE   | NotNone                                |
            | INSERTED_BY           | activatePaymentNotice                  |
            | UPDATED_BY            | activatePaymentNotice                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                      |
            | ID                       | NotNone                                    |
            | CREDITOR_REFERENCE_ID    | 12$iuv                                     |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                    |
            | TRANSFER_CATEGORY        | None                                       |
            | TRANSFER_IDENTIFIER      | 1                                          |
            | VALID                    | Y                                          |
            | FK_POSITION_PAYMENT      | NotNone                                    |
            | INSERTED_TIMESTAMP       | NotNone                                    |
            | UPDATED_TIMESTAMP        | NotNone                                    |
            | FK_PAYMENT_PLAN          | NotNone                                    |
            | INSERTED_BY              | activatePaymentNotice                      |
            | UPDATED_BY               | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC                      |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                        |
            | ID                         | NotNone                                      |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode   |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                       |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode   |
            | STATION_ID                 | #id_station_old#                             |
            | STATION_VERSION            | 1                                            |
            | PSP_ID                     | #psp#                                        |
            | BROKER_PSP_ID              | #psp#                                        |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                 |
            | IDEMPOTENCY_KEY            | NotNone                                      |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount       |
            | FEE                        | 2.00                                         |
            | OUTCOME                    | OK                                           |
            | PAYMENT_METHOD             | creditCard                                   |
            | PAYMENT_CHANNEL            | app                                          |
            | TRANSFER_DATE              | 2021-12-11                                   |
            | PAYER_ID                   | NotNone                                      |
            | APPLICATION_DATE           | NotNone                                      |
            | INSERTED_TIMESTAMP         | NotNone                                      |
            | UPDATED_TIMESTAMP          | NotNone                                      |
            | FK_PAYMENT_PLAN            | NotNone                                      |
            | RPT_ID                     | None                                         |
            | PAYMENT_TYPE               | MOD3                                         |
            | CARRELLO_ID                | None                                         |
            | ORIGINAL_PAYMENT_TOKEN     | None                                         |
            | FLAG_IO                    | N                                            |
            | RICEVUTA_PM                | None                                         |
            | FLAG_ACTIVATE_RESP_MISSING | None                                         |
            | FLAG_PAYPAL                | None                                         |
            | INSERTED_BY                | activatePaymentNotice                        |
            | UPDATED_BY                 | sendPaymentOutcome                           |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                         |
            | FEE_PA                     | None                                         |
            | BUNDLE_ID                  | None                                         |
            | BUNDLE_PA_ID               | None                                         |
            | PM_INFO                    | None                                         |
            | MBD                        | N                                            |
            | FEE_SPO                    | None                                         |
            | PAYMENT_NOTE               | responseFull                                 |
            | FLAG_STANDIN               | N                                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                 |
            | ID                    | NotNone                                               |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode            |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber          |
            | STATUS                | PAYING,CANCELLED_NORPT,PAID_NORPT                     |
            | INSERTED_TIMESTAMP    | NotNone                                               |
            | CREDITOR_REFERENCE_ID | 12$iuv                                                |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken          |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV1,sendPaymentOutcome |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | STATUS                | PAID_NORPT                                   |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | FK_POSITION_PAYMENT   | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | sendPaymentOutcome                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # STATI_RPT
        And verify 0 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 125$iuv      |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                           |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
        # paaInviaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0




    # accessi_concorrenziali_1a_RPT_SPO
    # nodoInviaRPT -> SPO- (ACT:OK - SPO+: OK)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_7
    Scenario: NM3 flow OK, FLOW: activate -> nodoInviaRPT & spo- in pararallel mode-> OK  (OLD_NM8-A)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  |
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
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #psp#                                       |
            | identificativoIntermediarioPSP        | #psp#                                       |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#                |
            | rpt                                   | $rptAttachment                              |
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | KO      |
        When calling primitive evolution nodoInviaRPT and sendPaymentOutcome with POST and POST in parallel with 0 ms delay
        Then check esito is OK of nodoInviaRPT response
        And check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PSP_ID                | #psp#                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                         |
            | ID                    | NotNone                       |
            | CREDITOR_REFERENCE_ID | 12$iuv                        |
            | DUE_DATE              | NotNone                       |
            | RETENTION_DATE        | None                          |
            | AMOUNT                | $activatePaymentNotice.amount |
            | FLAG_FINAL_PAYMENT    | Y                             |
            | INSERTED_TIMESTAMP    | NotNone                       |
            | UPDATED_TIMESTAMP     | NotNone                       |
            | METADATA              | None                          |
            | FK_POSITION_SERVICE   | NotNone                       |
            | INSERTED_BY           | activatePaymentNotice         |
            | UPDATED_BY            | activatePaymentNotice         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                             |
            | ID                       | NotNone                           |
            | CREDITOR_REFERENCE_ID    | 12$iuv                            |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016       |
            | AMOUNT                   | $activatePaymentNotice.amount     |
            | REMITTANCE_INFORMATION   | NotNone                           |
            | TRANSFER_CATEGORY        | None                              |
            | TRANSFER_IDENTIFIER      | 1                                 |
            | VALID                    | Y                                 |
            | FK_POSITION_PAYMENT      | NotNone                           |
            | INSERTED_TIMESTAMP       | NotNone                           |
            | UPDATED_TIMESTAMP        | NotNone                           |
            | FK_PAYMENT_PLAN          | NotNone                           |
            | INSERTED_BY              | activatePaymentNotice             |
            | UPDATED_BY               | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC             |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #psp#                                       |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | NotNone                                     |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2.00                                        |
            | OUTCOME                    | KO                                          |
            | PAYMENT_METHOD             | creditCard                                  |
            | PAYMENT_CHANNEL            | app                                         |
            | TRANSFER_DATE              | 2021-12-11                                  |
            | PAYER_ID                   | NotNone                                     |
            | APPLICATION_DATE           | NotNone                                     |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | sendPaymentOutcome                          |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | 2                                           |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING,FAILED_NORPT                         |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | FAILED_NORPT                                |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                    |
            | ID                    | NotNone                                                                  |
            | ID_SESSIONE           | NotNone                                                                  |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                  |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                        |
            | IUV                   | 12$iuv                                                                   |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                              |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,pspInviaRPT                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 4 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RPT_ACCETTATA_PSP                           |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | pspInviaRPT                                 |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
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
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
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
        # paaInviaRPT REQ
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
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0






    # accessi_concorrenziali_1c_RPT_SPO
    # SPO+ -> nodoInviaRPT  (nodoInviaRPT:OK - SPO+:KO PPT_SINTASSI_EXTRAXSD)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_8
    Scenario: NM3 flow KO, FLOW: activate -> spo+ con paymentMethod sconosciuto & nodoInviaRPT in pararallel mode-> KO PPT_SINTASSI_EXTRAXSD (OLD_NM9-A)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  |
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
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #psp#                                       |
            | identificativoIntermediarioPSP        | #psp#                                       |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#                |
            | rpt                                   | $rptAttachment                              |
        And from body with datatable horizontal sendPaymentOutcomeBody_paymentMethod_full copy initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome | paymentMethod |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      | creditCar     |
        When calling primitive evolution sendPaymentOutcome and nodoInviaRPT with POST and POST in parallel with 10 ms delay
        Then check esito is OK of nodoInviaRPT response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PSP_ID                | #psp#                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC LIMIT 1      |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                         |
            | ID                    | NotNone                       |
            | CREDITOR_REFERENCE_ID | 12$iuv                        |
            | DUE_DATE              | NotNone                       |
            | RETENTION_DATE        | None                          |
            | AMOUNT                | $activatePaymentNotice.amount |
            | FLAG_FINAL_PAYMENT    | Y                             |
            | INSERTED_TIMESTAMP    | NotNone                       |
            | UPDATED_TIMESTAMP     | NotNone                       |
            | METADATA              | None                          |
            | FK_POSITION_SERVICE   | NotNone                       |
            | INSERTED_BY           | activatePaymentNotice         |
            | UPDATED_BY            | activatePaymentNotice         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                             |
            | ID                       | NotNone                           |
            | CREDITOR_REFERENCE_ID    | 12$iuv                            |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016       |
            | AMOUNT                   | $activatePaymentNotice.amount     |
            | REMITTANCE_INFORMATION   | NotNone                           |
            | TRANSFER_CATEGORY        | None                              |
            | TRANSFER_IDENTIFIER      | 1                                 |
            | VALID                    | Y                                 |
            | FK_POSITION_PAYMENT      | NotNone                           |
            | INSERTED_TIMESTAMP       | NotNone                           |
            | UPDATED_TIMESTAMP        | NotNone                           |
            | FK_PAYMENT_PLAN          | NotNone                           |
            | INSERTED_BY              | activatePaymentNotice             |
            | UPDATED_BY               | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC             |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #psp#                                       |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | NotNone                                     |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | None                                        |
            | OUTCOME                    | None                                        |
            | PAYMENT_METHOD             | None                                        |
            | PAYMENT_CHANNEL            | NA                                          |
            | TRANSFER_DATE              | None                                        |
            | PAYER_ID                   | None                                        |
            | APPLICATION_DATE           | None                                        |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | activatePaymentNotice                       |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | None                                        |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAYING                                      |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
        # STATI_RPT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                    |
            | ID                    | NotNone                                                                  |
            | ID_SESSIONE           | NotNone                                                                  |
            | ID_SESSIONE_ORIGINALE | NotNone                                                                  |
            | ID_DOMINIO            | $activatePaymentNotice.fiscalCode                                        |
            | IUV                   | 12$iuv                                                                   |
            | CCP                   | $activatePaymentNoticeResponse.paymentToken                              |
            | STATO                 | RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP |
            | INSERTED_BY           | nodoInviaRPT,nodoInviaRPT,nodoInviaRPT,pspInviaRPT                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values              |
            | IUV        | 12$iuv                    |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC |
        And verify 4 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        # STATI_RPT_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                       |
            | ID_SESSIONE        | NotNone                                     |
            | ID_DOMINIO         | $activatePaymentNotice.fiscalCode           |
            | IUV                | 12$iuv                                      |
            | CCP                | $activatePaymentNoticeResponse.paymentToken |
            | STATO              | RPT_ACCETTATA_PSP                           |
            | INSERTED_BY        | nodoInviaRPT                                |
            | UPDATED_BY         | pspInviaRPT                                 |
            | INSERTED_TIMESTAMP | NotNone                                     |
            | UPDATED_TIMESTAMP  | NotNone                                     |
            | PUSH               | None                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
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
        # paaInviaRPT REQ
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
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0







    # accessi_concorrenziali_1d_RPT_SPO
    # SPO+ -> nodoInviaRPT  (nodoInviaRPT:KO PPT_SINTASSI_XSD - SPO+:OK)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_9
    Scenario: NM3 flow KO, FLOW: activate -> spo+ & nodoInviaRPT con tipoVersamento = 'TE' in pararallel mode-> KO PPT_SINTASSI_EXTRAXSD (OLD_NM10A)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 10.00  |
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        Given RPT generation RPT_generation_tipoVersamento with datatable vertical
            | identificativoDominio             | #creditor_institution_code_old#             |
            | identificativoStazioneRichiedente | #id_station_old#                            |
            | dataOraMessaggioRichiesta         | #timedate#                                  |
            | dataEsecuzionePagamento           | #date#                                      |
            | importoTotaleDaVersare            | $activatePaymentNotice.amount               |
            | identificativoUnivocoVersamento   | 12$iuv                                      |
            | codiceContestoPagamento           | $activatePaymentNoticeResponse.paymentToken |
            | importoSingoloVersamento          | $activatePaymentNotice.amount               |
            | tipoVersamento                    | TE                                          |
        And from body with datatable vertical nodoInviaRPTBody_full initial XML nodoInviaRPT
            | identificativoIntermediarioPA         | #id_broker_old#                             |
            | identificativoStazioneIntermediarioPA | #id_station_old#                            |
            | identificativoDominio                 | #creditor_institution_code_old#             |
            | identificativoUnivocoVersamento       | 12$iuv                                      |
            | codiceContestoPagamento               | $activatePaymentNoticeResponse.paymentToken |
            | password                              | #password#                                  |
            | identificativoPSP                     | #psp#                                       |
            | identificativoIntermediarioPSP        | #psp#                                       |
            | identificativoCanale                  | #canale_ATTIVATO_PRESSO_PSP#                |
            | rpt                                   | $rptAttachment                              |
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
        When calling primitive evolution sendPaymentOutcome and nodoInviaRPT with POST and POST in parallel with 10 ms delay
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_SINTASSI_XSD of nodoInviaRPT response
        And check outcome is OK of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PSP_ID                | #psp#                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                     |
            | TOKEN_VALID_TO        | NotNone                                     |
            | DUE_DATE              | 2021-12-31 00:00:00                         |
            | AMOUNT                | $activatePaymentNotice.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | activatePaymentNotice                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC LIMIT 1      |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                         |
            | ID                    | NotNone                       |
            | CREDITOR_REFERENCE_ID | 12$iuv                        |
            | DUE_DATE              | NotNone                       |
            | RETENTION_DATE        | None                          |
            | AMOUNT                | $activatePaymentNotice.amount |
            | FLAG_FINAL_PAYMENT    | Y                             |
            | INSERTED_TIMESTAMP    | NotNone                       |
            | UPDATED_TIMESTAMP     | NotNone                       |
            | METADATA              | None                          |
            | FK_POSITION_SERVICE   | NotNone                       |
            | INSERTED_BY           | activatePaymentNotice         |
            | UPDATED_BY            | activatePaymentNotice         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                             |
            | ID                       | NotNone                           |
            | CREDITOR_REFERENCE_ID    | 12$iuv                            |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016       |
            | AMOUNT                   | $activatePaymentNotice.amount     |
            | REMITTANCE_INFORMATION   | NotNone                           |
            | TRANSFER_CATEGORY        | None                              |
            | TRANSFER_IDENTIFIER      | 1                                 |
            | VALID                    | Y                                 |
            | FK_POSITION_PAYMENT      | NotNone                           |
            | INSERTED_TIMESTAMP       | NotNone                           |
            | UPDATED_TIMESTAMP        | NotNone                           |
            | FK_PAYMENT_PLAN          | NotNone                           |
            | INSERTED_BY              | activatePaymentNotice             |
            | UPDATED_BY               | activatePaymentNotice             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC             |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                |
            | PAYMENT_TOKEN | $activatePaymentNoticeResponse.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                      |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                       |
            | ID                         | NotNone                                     |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
            | STATION_ID                 | #id_station_old#                            |
            | STATION_VERSION            | 1                                           |
            | PSP_ID                     | #psp#                                       |
            | BROKER_PSP_ID              | #psp#                                       |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                |
            | IDEMPOTENCY_KEY            | NotNone                                     |
            | AMOUNT                     | $activatePaymentNotice.amount               |
            | FEE                        | 2.00                                        |
            | OUTCOME                    | OK                                          |
            | PAYMENT_METHOD             | creditCard                                  |
            | PAYMENT_CHANNEL            | app                                         |
            | TRANSFER_DATE              | 2021-12-11                                  |
            | PAYER_ID                   | NotNone                                     |
            | APPLICATION_DATE           | NotNone                                     |
            | INSERTED_TIMESTAMP         | NotNone                                     |
            | UPDATED_TIMESTAMP          | NotNone                                     |
            | FK_PAYMENT_PLAN            | NotNone                                     |
            | RPT_ID                     | None                                        |
            | PAYMENT_TYPE               | MOD3                                        |
            | CARRELLO_ID                | None                                        |
            | ORIGINAL_PAYMENT_TOKEN     | None                                        |
            | FLAG_IO                    | N                                           |
            | RICEVUTA_PM                | None                                        |
            | FLAG_ACTIVATE_RESP_MISSING | None                                        |
            | FLAG_PAYPAL                | None                                        |
            | INSERTED_BY                | activatePaymentNotice                       |
            | UPDATED_BY                 | sendPaymentOutcome                          |
            | TRANSACTION_ID             | None                                        |
            | CLOSE_VERSION              | None                                        |
            | FEE_PA                     | None                                        |
            | BUNDLE_ID                  | None                                        |
            | BUNDLE_PA_ID               | None                                        |
            | PM_INFO                    | None                                        |
            | MBD                        | N                                           |
            | FEE_SPO                    | 2                                           |
            | PAYMENT_NOTE               | responseFull                                |
            | FLAG_STANDIN               | N                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | STATUS                | PAYING,PAID_NORPT                           |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome    |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC              |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                       |
            | ID                    | NotNone                                     |
            | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 12$iuv                                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
            | STATUS                | PAID_NORPT                                  |
            | INSERTED_TIMESTAMP    | NotNone                                     |
            | UPDATED_TIMESTAMP     | NotNone                                     |
            | FK_POSITION_PAYMENT   | NotNone                                     |
            | INSERTED_BY           | activatePaymentNotice                       |
            | UPDATED_BY            | sendPaymentOutcome                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                        |
            | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                        |
            | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
            | ORDER BY   | ID ASC                              |
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
        # paaInviaRPT REQ
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
        # # paaInviaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                |
            | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                |
            | SOTTO_TIPO_EVENTO  | RESP                                        |
            | ESITO              | RICEVUTA                                    |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
            | ORDER BY           | DATA_ORA_EVENTO ASC                         |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaInviaRTResp
        And from $paaInviaRTResp.esito xml check value OK in position 0






    # AccessiConcorrenziali DoppiaACT_PA_OLD
    # ACT-> ACT (ACT: KO - ACT- KO PPT_ATTIVAZIONE_IN_CORSO E' in corso un'altra attivazione per lo stesso avviso)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PAOLD @NM3PAOLDPARALLEL @NM3PAOLDPARALLEL_FULL_10
    Scenario: NM3 flow KO, FLOW: activate in pararallel mode activate -> paaAttivaRPT-> -> KO PPT_ATTIVAZIONE_IN_CORSO (OLD_NM3-12A)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                      | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code_old# | 312#iuv#     | 8.00   |
        And from body with datatable horizontal paaAttivaRPT_full initial XML paaAttivaRPT
            | esito | importoSingoloVersamento |
            | OK    | 8.00                     |
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                                 | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice_1Request.fiscalCode | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        When calling primitive evolution activatePaymentNotice_1Request and activatePaymentNotice_2Request with POST and POST in parallel with 500 ms delay
        And save activatePaymentNotice_1Request response in activatePaymentNotice1
        Then check outcome is OK of activatePaymentNotice_1Request response
        Then check outcome is KO of activatePaymentNotice_2Request response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PSP_ID                | #psp#                                        |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                      |
            | TOKEN_VALID_TO        | NotNone                                      |
            | DUE_DATE              | 2021-12-31 00:00:00                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount       |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC LIMIT 1               |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                       |
            | ID                 | NotNone                     |
            | DESCRIPTION        | pagamento multibeneficiario |
            | COMPANY_NAME       | PA paolo                    |
            | OFFICE_NAME        | None                        |
            | DEBTOR_ID          | None                        |
            | INSERTED_TIMESTAMP | NotNone                     |
            | UPDATED_TIMESTAMP  | NotNone                     |
            | INSERTED_BY        | activatePaymentNotice       |
            | UPDATED_BY         | activatePaymentNotice       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 12$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | None                                   |
            | FK_POSITION_SERVICE   | NotNone                                |
            | INSERTED_BY           | activatePaymentNotice                  |
            | UPDATED_BY            | activatePaymentNotice                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                                      |
            | ID                       | NotNone                                    |
            | CREDITOR_REFERENCE_ID    | 12$iuv                                     |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                    |
            | TRANSFER_CATEGORY        | None                                       |
            | TRANSFER_IDENTIFIER      | 1                                          |
            | VALID                    | Y                                          |
            | FK_POSITION_PAYMENT      | NotNone                                    |
            | INSERTED_TIMESTAMP       | NotNone                                    |
            | UPDATED_TIMESTAMP        | NotNone                                    |
            | FK_PAYMENT_PLAN          | NotNone                                    |
            | INSERTED_BY              | activatePaymentNotice                      |
            | UPDATED_BY               | activatePaymentNotice                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP DESC                      |
        # RPT_ACTIVATIONS
        Given verify 1 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                        |
            | ID                         | NotNone                                      |
            | PA_FISCAL_CODE             | $activatePaymentNotice_1Request.fiscalCode   |
            | CREDITOR_REFERENCE_ID      | 12$iuv                                       |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode   |
            | STATION_ID                 | #id_station_old#                             |
            | STATION_VERSION            | 1                                            |
            | PSP_ID                     | #psp#                                        |
            | BROKER_PSP_ID              | #psp#                                        |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                 |
            | IDEMPOTENCY_KEY            | NotNone                                      |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount       |
            | FEE                        | None                                         |
            | OUTCOME                    | None                                         |
            | PAYMENT_METHOD             | None                                         |
            | PAYMENT_CHANNEL            | NotNone                                      |
            | TRANSFER_DATE              | None                                         |
            | PAYER_ID                   | None                                         |
            | APPLICATION_DATE           | None                                         |
            | INSERTED_TIMESTAMP         | NotNone                                      |
            | UPDATED_TIMESTAMP          | NotNone                                      |
            | FK_PAYMENT_PLAN            | NotNone                                      |
            | RPT_ID                     | None                                         |
            | PAYMENT_TYPE               | MOD3                                         |
            | CARRELLO_ID                | None                                         |
            | ORIGINAL_PAYMENT_TOKEN     | None                                         |
            | FLAG_IO                    | N                                            |
            | RICEVUTA_PM                | None                                         |
            | FLAG_ACTIVATE_RESP_MISSING | None                                         |
            | FLAG_PAYPAL                | None                                         |
            | INSERTED_BY                | activatePaymentNotice                        |
            | UPDATED_BY                 | activatePaymentNotice                        |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                         |
            | FEE_PA                     | None                                         |
            | BUNDLE_ID                  | None                                         |
            | BUNDLE_PA_ID               | None                                         |
            | PM_INFO                    | None                                         |
            | MBD                        | N                                            |
            | FEE_SPO                    | None                                         |
            | PAYMENT_NOTE               | responseFull                                 |
            | FLAG_STANDIN               | N                                            |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber |
            | STATUS                | PAYING                                       |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID | 12$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | STATUS                | PAYING                                       |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | FK_POSITION_PAYMENT   | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | activatePaymentNotice                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC                    |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                 |
            | NOTICE_ID  | $activatePaymentNotice_1Request.noticeNumber |
            | ORDER BY   | ID ASC                                       |
        # STATI_RPT
        And verify 0 record for the table STATI_RPT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 12$iuv       |
        # RE #####
        # activatePaymentNotice REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # activatePaymentNotice RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 12$iuv in position 0
        # paaAttivaRPT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTReq
        And from $paaAttivaRPTReq.identificativoIntermediarioPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoDominio xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paaAttivaRPTReq.identificativoStazioneIntermediarioPA xml check value #id_station_old# in position 0
        And from $paaAttivaRPTReq.identificativoUnivocoVersamento xml check value 12$iuv in position 0
        And from $paaAttivaRPTReq.codiceContestoPagamento xml check value $activatePaymentNotice1Response.paymentToken in position 0
        And from $paaAttivaRPTReq.identificativoPSP xml check value #pspFittizio# in position 0
        And from $paaAttivaRPTReq.datiPagamentoPSP.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTReq.identificativoIntermediarioPSP xml check value #brokerFittizio# in position 0
        And from $paaAttivaRPTReq.identificativoCanalePSP xml check value #canaleFittizio# in position 0
        # paaAttivaRPT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paaAttivaRPT                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paaAttivaRPTResp
        And from $paaAttivaRPTResp.esito xml check value OK in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.importoSingoloVersamento xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paaAttivaRPTResp.datiPagamentoPA.ibanAccredito xml check value NotNone in position 0

