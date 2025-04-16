Feature: NM3 flows PA New con concorrenza

    Background:
        Given systems up



    # AccessiConcorrenziali 3c_ACT_SPO
    # ACT -> SPO+ (ACT: OK SPO+: KO PPT_SEMANTICA Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_1
    Scenario: NM3 flow KO, FLOW: activate -> paGetPayment -> mod3CancelV1 -> activate & spo+ in parallel mode-> KO PPT_SEMANTICA  (OLD_NM3-3A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And from body with datatable vertical paGetPayment_delay_full initial XML paGetPayment
            | delay                       | 1000                        |
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 8.00                        |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 8.00                        |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 750 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And save activatePaymentNotice response in activatePaymentNotice2
        And check description is Activation pending on position of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                    |
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
            | column             | value                 |
            | ID                 | NotNone               |
            | DESCRIPTION        | pagamentoTest         |
            | COMPANY_NAME       | company               |
            | OFFICE_NAME        | office                |
            | DEBTOR_ID          | NotNone               |
            | INSERTED_TIMESTAMP | NotNone               |
            | UPDATED_TIMESTAMP  | NotNone               |
            | INSERTED_BY        | activatePaymentNotice |
            | UPDATED_BY         | activatePaymentNotice |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                         |
            | ID                    | NotNone                                                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                        |
            | DUE_DATE              | NotNone                                                                       |
            | RETENTION_DATE        | None                                                                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                       |
            | UPDATED_TIMESTAMP     | NotNone                                                                       |
            | METADATA              | NotNone                                                                       |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                                                                        |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode                                    |
            | IBAN                     | IT45R0760103200000000001016                                                   |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount |
            | REMITTANCE_INFORMATION   | NotNone                                                                       |
            | TRANSFER_CATEGORY        | paGetPaymentTest                                                              |
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
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                     |
            | ID                         | NotNone                                                                                   |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode                                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                                                                    |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode                                                |
            | STATION_ID                 | #id_station#                                                                              |
            | STATION_VERSION            | 2                                                                                         |
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
            | STATUS                | PAYING,CANCELLED,PAYING                                                                                                                |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                                                                 |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV2,activatePaymentNotice                                                                               |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                    |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | STATUS                | CANCELLED,PAYING                                                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | FK_POSITION_PAYMENT   | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice,activatePaymentNotice                                               |
            | UPDATED_BY            | mod3CancelV2,activatePaymentNotice                                                        |
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
            | IUV        | 02$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 02$iuv       |
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        # activatePaymentNotice REQ 2
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice2Response.paymentToken |
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
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_2Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_2Request.amount in position 0
        # activatePaymentNotice RESP 2
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_2Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice2Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_2Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ  2
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice2Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_2Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_2Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice2Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice_2Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice_2Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
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












    # AccessiConcorrenziali 3c_ACT_SPO
    # SPO+ -> ACT (ACT: KO PPT_PAGAMENTO_DUPLICATO - SPO+: KO PPT_TOKEN_SCADUTO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_2
    Scenario: NM3 flow OK, FLOW: activate -> paGetPayment -> mod3CancelV1 -> spo+ & activate in parallel mode-> KO PPT_TOKEN_SCADUTO  (OLD_NM3-3A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | OK      |
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 10 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | CREDITOR_REFERENCE_ID | 02$iuv                                       |
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
            | column             | value                 |
            | ID                 | NotNone               |
            | DESCRIPTION        | pagamentoTest         |
            | COMPANY_NAME       | company               |
            | OFFICE_NAME        | office                |
            | DEBTOR_ID          | NotNone               |
            | INSERTED_TIMESTAMP | NotNone               |
            | UPDATED_TIMESTAMP  | NotNone               |
            | INSERTED_BY        | activatePaymentNotice |
            | UPDATED_BY         | activatePaymentNotice |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 02$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | NotNone                                |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                                     |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                    |
            | TRANSFER_CATEGORY        | paGetPaymentTest                           |
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
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # RPT_ACTIVATIONS
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                        |
            | ID                         | NotNone                                      |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode            |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                       |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode   |
            | STATION_ID                 | #id_station#                                 |
            | STATION_VERSION            | 2                                            |
            | PSP_ID                     | #psp#                                        |
            | BROKER_PSP_ID              | #psp#                                        |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                 |
            | IDEMPOTENCY_KEY            | NotNone                                      |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount       |
            | FEE                        | 2                                            |
            | OUTCOME                    | OK                                           |
            | PAYMENT_METHOD             | creditCard                                   |
            | PAYMENT_CHANNEL            | app                                          |
            | TRANSFER_DATE              | 2021-12-11                                   |
            | PAYER_ID                   | NotNone                                      |
            | APPLICATION_DATE           | 2021-12-12                                   |
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
            | column                | value                                                                                                |
            | ID                    | NotNone                                                                                              |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                           |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                                         |
            | STATUS                | PAYING,CANCELLED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                              |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                               |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken                                                         |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV2,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                        |
            | ID                    | NotNone                                      |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode   |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber |
            | CREDITOR_REFERENCE_ID | 02$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | STATUS                | NOTIFIED                                     |
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
            | IUV        | 02$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 02$iuv       |
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
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
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys               | where_values                                 |
            | PAYMENT_TOKEN            | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO              | paSendRT                                     |
            | SOTTO_TIPO_EVENTO        | REQ                                          |
            | ESITO                    | INVIATA                                      |
            | IDENTIFICATIVO_EROGATORE | #id_station#                                 |
            | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                             |
            | ORDER BY                 | INSERTED_TIMESTAMP ASC                       |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        ### TRANSFER 1
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys               | where_values                                 |
            | PAYMENT_TOKEN            | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO              | paSendRT                                     |
            | SOTTO_TIPO_EVENTO        | RESP                                         |
            | ESITO                    | RICEVUTA                                     |
            | IDENTIFICATIVO_EROGATORE | #id_station#                                 |
            | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                             |
            | ORDER BY                 | INSERTED_TIMESTAMP ASC                       |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0






    # IL TEST NON E' REPLICABILE A CAUSA DI UNA RANDOMICITA' NELLA SEQUENZA DI ARRIVO DELLE API
    # AccessiConcorrenziali 3d_ACT_SPO
    # ACT -> SPO- (ACT: OK - SPO+ -> KO PPT_SEMANTICA Activation pending on position )
    #@ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_3
    Scenario: NM3 flow KO, FLOW: activate -> paGetPayment -> mod3CancelV1 -> activate & spo- in parallel mode-> KO PPT_SEMANTICA  (OLD_NM3-4A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 5 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 20 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And save activatePaymentNotice response in activatePaymentNotice2







    # AccessiConcorrenziali 3d_ACT_SPO
    # SPO- -> ACT (ACT: OK - SPO-: KO PPT_TOKEN_SCADUTO_KO Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_4
    Scenario: NM3 flow KO, FLOW: activate -> paGetPayment -> mod3CancelV1 -> spo- & activate in parallel mode-> KO PPT_TOKEN_SCADUTO_KO  (OLD_NM3-4A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 8.00   |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 8.00                        |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 8.00                        |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 20 ms delay
        Then check outcome is OK of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And save activatePaymentNotice response in activatePaymentNotice2
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                    |
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
            | column             | value                 |
            | ID                 | NotNone               |
            | DESCRIPTION        | pagamentoTest         |
            | COMPANY_NAME       | company               |
            | OFFICE_NAME        | office                |
            | DEBTOR_ID          | NotNone               |
            | INSERTED_TIMESTAMP | NotNone               |
            | UPDATED_TIMESTAMP  | NotNone               |
            | INSERTED_BY        | activatePaymentNotice |
            | UPDATED_BY         | activatePaymentNotice |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                         |
            | ID                    | NotNone                                                                       |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                        |
            | DUE_DATE              | NotNone                                                                       |
            | RETENTION_DATE        | None                                                                          |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                                                             |
            | INSERTED_TIMESTAMP    | NotNone                                                                       |
            | UPDATED_TIMESTAMP     | NotNone                                                                       |
            | METADATA              | NotNone                                                                       |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                                                                        |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode                                    |
            | IBAN                     | IT45R0760103200000000001016                                                   |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount,$activatePaymentNotice_2Request.amount |
            | REMITTANCE_INFORMATION   | NotNone                                                                       |
            | TRANSFER_CATEGORY        | paGetPaymentTest                                                              |
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
        # RPT_ACTIVATIONS token 1
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # RPT_ACTIVATIONS token 2
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice2Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                     |
            | ID                         | NotNone                                                                                   |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode                                                         |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                                                                    |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode                                                |
            | STATION_ID                 | #id_station#                                                                              |
            | STATION_VERSION            | 2                                                                                         |
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
        Given verify 2 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | PAYING,CANCELLED,PAYING                                                                                                                |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                                                                 |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV2,activatePaymentNotice                                                                               |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                    |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice2Response.paymentToken |
            | STATUS                | CANCELLED,PAYING                                                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | UPDATED_TIMESTAMP     | NotNone                                                                                   |
            | FK_POSITION_PAYMENT   | NotNone                                                                                   |
            | INSERTED_BY           | activatePaymentNotice,activatePaymentNotice                                               |
            | UPDATED_BY            | mod3CancelV2,activatePaymentNotice                                                        |
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
            | IUV        | 02$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 02$iuv       |
        # RE #####
        # activatePaymentNotice  1 REQ
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
        # activatePaymentNotice 1 RESP
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # activatePaymentNotice  2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                 |
            | PAYMENT_TOKEN                            | $activatePaymentNotice2Response.paymentToken |
            | TIPO_EVENTO                              | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO                        | REQ                                          |
            | ESITO                                    | RICEVUTA                                     |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#                                 |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                             |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_2Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_2Request.amount in position 0
        # activatePaymentNotice 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                 |
            | PAYMENT_TOKEN                            | $activatePaymentNotice2Response.paymentToken |
            | TIPO_EVENTO                              | activatePaymentNotice                        |
            | SOTTO_TIPO_EVENTO                        | RESP                                         |
            | ESITO                                    | INVIATA                                      |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#                                 |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                             |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeResp.totalAmount xml check value $activatePaymentNotice_2Request.amount in position 0
        And from $activatePaymentNoticeResp.fiscalCodePA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.paymentToken xml check value $activatePaymentNotice2Response.paymentToken in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.transferAmount xml check value $activatePaymentNotice_2Request.amount in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeResp.transferList.transfer.IBAN xml check value NotNone in position 0
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
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






    # AccessiConcorrenziali 3f_ACT_SPO
    # ACT -> SPO+ (ACT: KO - SPO- KO PPT_SEMANTICA Activation pending on position)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_5
    Scenario: NM3 flow KO, FLOW: activate -> paGetPayment -> mod3CancelV1 -> activate & spo- in parallel mode-> KO PPT_SEMANTICA  (OLD_NM3-6A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 10.00  |
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        And from body with datatable vertical paGetPayment_delay_full initial XML paGetPayment
            | delay                       | 1000                        |
            | outcome                     | KO                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When calling primitive evolution activatePaymentNotice and sendPaymentOutcome with POST and POST in parallel with 750 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And check description is Activation pending on position of sendPaymentOutcome response
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And execution query payment_status_orderbydesc to get value on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN under macro NewMod3 with db name nodo_online
        And through the query payment_status_orderbydesc retrieve param paymentToken at position 0 and save it under the key paymentToken
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                |
            | ID                    | NotNone                                                              |
            | CREDITOR_REFERENCE_ID | 02$iuv,None                                                          |
            | PSP_ID                | #psp#                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$paymentToken           |
            | TOKEN_VALID_FROM      | NotNone,None                                                         |
            | TOKEN_VALID_TO        | NotNone,None                                                         |
            | DUE_DATE              | 2021-12-31 00:00:00                                                  |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice.amount |
            | INSERTED_TIMESTAMP    | NotNone                                                              |
            | UPDATED_TIMESTAMP     | NotNone                                                              |
            | INSERTED_BY           | activatePaymentNotice                                                |
            | UPDATED_BY            | activatePaymentNotice                                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                 |
            | ID                 | NotNone               |
            | DESCRIPTION        | pagamentoTest         |
            | COMPANY_NAME       | company               |
            | OFFICE_NAME        | office                |
            | DEBTOR_ID          | NotNone               |
            | INSERTED_TIMESTAMP | NotNone               |
            | UPDATED_TIMESTAMP  | NotNone               |
            | INSERTED_BY        | activatePaymentNotice |
            | UPDATED_BY         | activatePaymentNotice |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 02$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | NotNone                                |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                                     |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                    |
            | TRANSFER_CATEGORY        | paGetPaymentTest                           |
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
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # RPT_ACTIVATIONS token 1
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # RPT_ACTIVATIONS token 2
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values           |
            | PAYMENT_TOKEN | $paymentToken          |
            | ORDER BY      | INSERTED_TIMESTAMP ASC |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                        |
            | ID                         | NotNone                                      |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode            |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                       |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode   |
            | STATION_ID                 | #id_station#                                 |
            | STATION_VERSION            | 2                                            |
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
        Given verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                     |
            | ID                    | NotNone                                                                                   |
            | PA_FISCAL_CODE        | $activatePaymentNotice_1Request.fiscalCode                                                |
            | NOTICE_ID             | $activatePaymentNotice_1Request.noticeNumber                                              |
            | STATUS                | PAYING,CANCELLED                                                                          |
            | INSERTED_TIMESTAMP    | NotNone                                                                                   |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                                                    |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$activatePaymentNotice1Response.paymentToken |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV2                                                        |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | STATUS                | CANCELLED                                    |
            | INSERTED_TIMESTAMP    | NotNone                                      |
            | UPDATED_TIMESTAMP     | NotNone                                      |
            | FK_POSITION_PAYMENT   | NotNone                                      |
            | INSERTED_BY           | activatePaymentNotice                        |
            | UPDATED_BY            | mod3CancelV2                                 |
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
            | IUV        | 02$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 02$iuv       |
        # RE #####
        # activatePaymentNotice  1 REQ
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
        # activatePaymentNotice 1 RESP
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # activatePaymentNotice  2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values          |
            | PAYMENT_TOKEN                            | $paymentToken         |
            | TIPO_EVENTO                              | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO                        | REQ                   |
            | ESITO                                    | RICEVUTA              |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#          |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)      |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC   |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_2Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_2Request.amount in position 0
        # activatePaymentNotice 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values          |
            | PAYMENT_TOKEN                            | $paymentToken         |
            | TIPO_EVENTO                              | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO                        | RESP                  |
            | ESITO                                    | INVIATA               |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#          |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)      |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC   |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value KO in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        # paGetPayment 2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_2Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_2Request.amount in position 0
        # paGetPayment 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value KO in position 0
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





    # AccessiConcorrenziali 3f_ACT_SPO
    # SPO- -> ACT (ACT: KO - SPO: KO PPT_TOKEN_SCADUTO_KO)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_6
    Scenario: NM3 flow KO, FLOW: activate -> paGetPayment -> mod3CancelV1 ->  spo- & activate in parallel mode-> KO PPT_TOKEN_SCADUTO_KO  (OLD_NM3-6A)
        Given from body with datatable horizontal activatePaymentNoticeBody_with_expiration_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        And save activatePaymentNotice response in activatePaymentNotice1
        When job mod3CancelV2 triggered after 3 seconds
        And wait 3 seconds for expiration
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | $activatePaymentNotice_1Request.noticeNumber | 10.00  |
        And from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP | idChannel                    | password   | paymentToken                                 | outcome |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice1Response.paymentToken | KO      |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | KO                          |
            | creditorReferenceId         | 02$iuv                      |
            | paymentAmount               | 10.00                       |
            | dueDate                     | 2021-12-31                  |
            | description                 | pagamentoTest               |
            | entityUniqueIdentifierType  | G                           |
            | entityUniqueIdentifierValue | #creditor_institution_code# |
            | fullName                    | Massimo Benvegnù            |
            | transferAmount              | 10.00                       |
            | fiscalCodePA                | #creditor_institution_code# |
            | IBAN                        | IT45R0760103200000000001016 |
            | remittanceInformation       | testPaGetPayment            |
            | transferCategory            | paGetPaymentTest            |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When calling primitive evolution sendPaymentOutcome and activatePaymentNotice with POST and POST in parallel with 10 ms delay
        Then check outcome is KO of activatePaymentNotice response
        And check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO_KO of sendPaymentOutcome response
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        And execution query payment_status_orderbydesc to get value on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN under macro NewMod3 with db name nodo_online
        And through the query payment_status_orderbydesc retrieve param paymentToken at position 0 and save it under the key paymentToken
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                |
            | ID                    | NotNone                                                              |
            | CREDITOR_REFERENCE_ID | 02$iuv,None                                                          |
            | PSP_ID                | #psp#                                                                |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken,$paymentToken           |
            | TOKEN_VALID_FROM      | NotNone,None                                                         |
            | TOKEN_VALID_TO        | NotNone,None                                                         |
            | DUE_DATE              | 2021-12-31 00:00:00                                                  |
            | AMOUNT                | $activatePaymentNotice_1Request.amount,$activatePaymentNotice.amount |
            | INSERTED_TIMESTAMP    | NotNone                                                              |
            | UPDATED_TIMESTAMP     | NotNone                                                              |
            | INSERTED_BY           | activatePaymentNotice                                                |
            | UPDATED_BY            | activatePaymentNotice                                                |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                 |
            | ID                 | NotNone               |
            | DESCRIPTION        | pagamentoTest         |
            | COMPANY_NAME       | company               |
            | OFFICE_NAME        | office                |
            | DEBTOR_ID          | NotNone               |
            | INSERTED_TIMESTAMP | NotNone               |
            | UPDATED_TIMESTAMP  | NotNone               |
            | INSERTED_BY        | activatePaymentNotice |
            | UPDATED_BY         | activatePaymentNotice |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                 |
            | NOTICE_ID      | $activatePaymentNotice_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNotice_1Request.fiscalCode   |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                  |
            | ID                    | NotNone                                |
            | CREDITOR_REFERENCE_ID | 02$iuv                                 |
            | DUE_DATE              | NotNone                                |
            | RETENTION_DATE        | None                                   |
            | AMOUNT                | $activatePaymentNotice_1Request.amount |
            | FLAG_FINAL_PAYMENT    | Y                                      |
            | INSERTED_TIMESTAMP    | NotNone                                |
            | UPDATED_TIMESTAMP     | NotNone                                |
            | METADATA              | NotNone                                |
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
            | CREDITOR_REFERENCE_ID    | 02$iuv                                     |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice_1Request.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016                |
            | AMOUNT                   | $activatePaymentNotice_1Request.amount     |
            | REMITTANCE_INFORMATION   | NotNone                                    |
            | TRANSFER_CATEGORY        | paGetPaymentTest                           |
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
            | ORDER BY       | INSERTED_TIMESTAMP ASC                       |
        # RPT_ACTIVATIONS token 1
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values                                 |
            | PAYMENT_TOKEN | $activatePaymentNotice1Response.paymentToken |
            | ORDER BY      | INSERTED_TIMESTAMP ASC                       |
        # RPT_ACTIVATIONS token 2
        Given verify 0 record for the table RPT_ACTIVATIONS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys    | where_values           |
            | PAYMENT_TOKEN | $paymentToken          |
            | ORDER BY      | INSERTED_TIMESTAMP ASC |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                        |
            | ID                         | NotNone                                      |
            | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode            |
            | CREDITOR_REFERENCE_ID      | 02$iuv                                       |
            | PAYMENT_TOKEN              | $activatePaymentNotice1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNotice_1Request.fiscalCode   |
            | STATION_ID                 | #id_station#                                 |
            | STATION_VERSION            | 2                                            |
            | PSP_ID                     | #psp#                                        |
            | BROKER_PSP_ID              | #psp#                                        |
            | CHANNEL_ID                 | #canale_ATTIVATO_PRESSO_PSP#                 |
            | IDEMPOTENCY_KEY            | NotNone                                      |
            | AMOUNT                     | $activatePaymentNotice_1Request.amount       |
            | FEE                        | 2.0                                          |
            | OUTCOME                    | KO                                           |
            | PAYMENT_METHOD             | creditCard                                   |
            | PAYMENT_CHANNEL            | app                                          |
            | TRANSFER_DATE              | 2021-12-11                                   |
            | PAYER_ID                   | NotNone                                      |
            | APPLICATION_DATE           | 2021-12-12                                   |
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
        Given verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
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
            | STATUS                | PAYING,CANCELLED,FAILED                               |
            | INSERTED_TIMESTAMP    | NotNone                                               |
            | CREDITOR_REFERENCE_ID | 02$iuv                                                |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken          |
            | INSERTED_BY           | activatePaymentNotice,mod3CancelV2,sendPaymentOutcome |
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
            | CREDITOR_REFERENCE_ID | 02$iuv                                       |
            | PAYMENT_TOKEN         | $activatePaymentNotice1Response.paymentToken |
            | STATUS                | FAILED                                       |
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
            | IUV        | 02$iuv       |
            | ORDER BY   | ID ASC       |
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values |
            | IUV        | 02$iuv       |
        # RE #####
        # activatePaymentNotice  1 REQ
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
        # activatePaymentNotice 1 RESP
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
        And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
        # activatePaymentNotice  2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values          |
            | PAYMENT_TOKEN                            | $paymentToken         |
            | TIPO_EVENTO                              | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO                        | REQ                   |
            | ESITO                                    | RICEVUTA              |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#          |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)      |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC   |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeReq
        And from $activatePaymentNoticeReq.idPSP xml check value #psp# in position 0
        And from $activatePaymentNoticeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $activatePaymentNoticeReq.idChannel xml check value #canale_ATTIVATO_PRESSO_PSP# in position 0
        And from $activatePaymentNoticeReq.password xml check value #password# in position 0
        And from $activatePaymentNoticeReq.qrCode.fiscalCode xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeReq.qrCode.noticeNumber xml check value $activatePaymentNotice_2Request.noticeNumber in position 0
        And from $activatePaymentNoticeReq.amount xml check value $activatePaymentNotice_2Request.amount in position 0
        # activatePaymentNotice 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values          |
            | PAYMENT_TOKEN                            | $paymentToken         |
            | TIPO_EVENTO                              | activatePaymentNotice |
            | SOTTO_TIPO_EVENTO                        | RESP                  |
            | ESITO                                    | INVIATA               |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#          |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)      |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC   |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeResp
        And from $activatePaymentNoticeResp.outcome xml check value KO in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                          |
            | ESITO              | INVIATA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_1Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_1Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                 |
            | PAYMENT_TOKEN      | $activatePaymentNotice1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                         |
            | ESITO              | RICEVUTA                                     |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                             |
            | ORDER BY           | DATA_ORA_EVENTO ASC                          |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice_1Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice_1Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        # paGetPayment 2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | PAYMENT_TOKEN      | $paymentToken       |
            | TIPO_EVENTO        | paGetPayment        |
            | SOTTO_TIPO_EVENTO  | REQ                 |
            | ESITO              | INVIATA             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice_2Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNotice_2Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNotice_2Request.amount in position 0
        # paGetPayment 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values        |
            | PAYMENT_TOKEN      | $paymentToken       |
            | TIPO_EVENTO        | paGetPayment        |
            | SOTTO_TIPO_EVENTO  | RESP                |
            | ESITO              | RICEVUTA            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)    |
            | ORDER BY           | DATA_ORA_EVENTO ASC |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value KO in position 0
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







    # AccessiConcorrenziali DoppiaACT_PA_NEW
    # ACT-> ACT (ACT: KO - ACT- KO PPT_ATTIVAZIONE_IN_CORSO E' in corso un'altra attivazione per lo stesso avviso)
    @ALL @FLOW @FLOW_FULL @NM3 @NM3PNEW @NM3PANEWPARALLEL @NM3PANEWPARALLEL_FULL_7
    Scenario: NM3 flow KO, FLOW: activate -> paGetPayment  -> activate in parallel mode-> KO PPT_ATTIVAZIONE_IN_CORSO (OLD_NM3-11A)
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                  | noticeNumber | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                              |
            | creditorReferenceId         | 02$iuv                          |
            | paymentAmount               | 10.00                           |
            | dueDate                     | 2021-12-31                      |
            | description                 | pagamentoTest                   |
            | entityUniqueIdentifierType  | G                               |
            | entityUniqueIdentifierValue | #creditor_institution_code_old# |
            | fullName                    | Massimo Benvegnù                |
            | transferAmount              | 10.00                           |
            | fiscalCodePA                | #creditor_institution_code_old# |
            | IBAN                        | IT45R0760103200000000001016     |
            | remittanceInformation       | testPaGetPayment                |
            | transferCategory            | paGetPaymentTest                |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        And saving activatePaymentNotice request in activatePaymentNotice_1Request
        Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
            | idPSP | idBrokerPSP | idChannel                    | password   | fiscalCode                                 | noticeNumber                                 | amount |
            | #psp# | #psp#       | #canale_ATTIVATO_PRESSO_PSP# | #password# | $activatePaymentNotice_1Request.fiscalCode | $activatePaymentNotice_1Request.noticeNumber | 10.00  |
        And saving activatePaymentNotice request in activatePaymentNotice_2Request
        When calling primitive evolution activatePaymentNotice_1Request and activatePaymentNotice_2Request with POST and POST in parallel with 80 ms delay
        Then check outcome is OK of activatePaymentNotice_1Request response
        Then check outcome is KO of activatePaymentNotice_2Request response

