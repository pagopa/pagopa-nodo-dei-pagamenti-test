

Feature: PostePay Toggle Configuration Tests
Background:
 Given systems up
@ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @POSTEPAY @POSTEPAYNEW @POSTEPAY_TOGGLE_01
  Scenario: POSTEPAY_TOGGLE_01 PostePay Enabled: verificaBollettino e sendOutcome
    Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'true' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'POSTE3' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | lista_canali_poste |
    And waiting after triggered refresh job ALL
    And update for table CANALI_NODO with parameter VERSIONE_PRIMITIVE = '2' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values |
      | OBJ_ID     | 14748        |
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal verificaBollettino initial XML verificaBollettino
      | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
    And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
      | outcome            | OK                      |
      | amount             | 10.00                   |
      | options            | EQ                      |
      | allCCP             | false                   |
      | paymentDescription | Pagamento PostePay Test |
      | fiscalCodePA       | #creditor_institution_code# |
      | companyName        | companyName             |
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
      | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
      | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
    And from body with datatable vertical paGetPayment_full initial XML paGetPayment
      | outcome                     | OK                             |
      | creditorReferenceId         | 02$iuv                        |
      | paymentAmount               | 10.00                          |
      | dueDate                     | 2021-12-31                     |
      | description                 | pagamentoPostePay              |
      | entityUniqueIdentifierType  | G                              |
      | entityUniqueIdentifierValue | 77777777777                    |
      | fullName                    | Massimo Test                   |
      | transferAmount              | 10.00                          |
      | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
      | IBAN                        | IT45R0760103200000000001016    |
      | remittanceInformation       | testPostePay                   |
      | transferCategory            | PostePay                       |
      | transferType                | POSTAL                         |
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNoticeV2 response
    Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
      | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                  | outcome |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
      | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                  | outcome |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcomeV2 response
    Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'false' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And waiting after triggered refresh job ALL

  @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @NM3PANEWPAGOK @POSTEPAY @POSTEPAYNEW @POSTEPAY_TOGGLE_02
    Scenario: NM3 flow OK, FLOW: verificaBollettino  -> paVerify activate -> paGetPayment --> spo+ -> paSendRT BIZ+ (NM3-2)
      Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'true' on db nodo_cfg with where datatable horizontal
        | where_keys | where_values       |
        | CONFIG_KEY | postepay_in_poste  |
      And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'POSTE3' on db nodo_cfg with where datatable horizontal
        | where_keys | where_values       |
        | CONFIG_KEY | lista_canali_poste |
    And waiting after triggered refresh job ALL
      Given from body with datatable horizontal verificaBollettino initial XML verificaBollettino
        | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
        | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
      And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
        | outcome            | OK                          |
        | amount             | 10.00                       |
        | options            | EQ                          |
        | allCCP             | false                       |
        | paymentDescription | Pagamento di Test           |
        | fiscalCodePA       | #creditor_institution_code# |
        | companyName        | companyName                 |
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
      Then check outcome is OK of verificaBollettino response
      Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
        | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
        | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
      And from body with datatable vertical paGetPayment_full initial XML paGetPayment
        | outcome                     | OK                                |
        | creditorReferenceId         | 02$iuv                            |
        | paymentAmount               | 10.00                             |
        | dueDate                     | 2021-12-31                        |
        | description                 | pagamentoTest                     |
        | entityUniqueIdentifierType  | G                                 |
        | entityUniqueIdentifierValue | 77777777777                       |
        | fullName                    | Massimo Benvegnù                  |
        | transferAmount              | 10.00                             |
        | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
        | IBAN                        | IT45R0760103200000000001016       |
        | remittanceInformation       | testPaGetPayment                  |
        | transferCategory            | paGetPaymentTest                  |
        | transferType                | POSTAL                            |
      And EC replies to nodo-dei-pagamenti with the paGetPayment
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
        | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                | outcome |
        | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
      When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcome response
      And wait 1 seconds for expiration
      # POSITION_ACTIVATE
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                       |
        | ID                    | NotNone                                     |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
        | PSP_ID                | #pspPoste#                                  |
        | IDEMPOTENCY_KEY       | NotNone                                     |
        | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
        | TOKEN_VALID_FROM      | NotNone                                     |
        | TOKEN_VALID_TO        | NotNone                                     |
        | DUE_DATE              | 2021-12-31 00:00:00                         |
        | AMOUNT                | $activatePaymentNotice.amount               |
        | INSERTED_TIMESTAMP    | NotNone                                     |
        | UPDATED_TIMESTAMP     | NotNone                                     |
        | INSERTED_BY           | activatePaymentNotice                       |
        | UPDATED_BY            | activatePaymentNotice                       |
        | PAYMENT_METHOD        | None                                        |
        | TOUCHPOINT            | None                                        |
        | SUGGESTED_IDBUNDLE    | None                                        |
        | SUGGESTED_IDCIBUNDLE  | None                                        |
        | SUGGESTED_USER_FEE    | None                                        |
        | SUGGESTED_PA_FEE      | None                                        |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      # POSITION_SERVICE
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                             |
        | ID                 | NotNone                           |
        | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
        | DESCRIPTION        | pagamentoTest                     |
        | COMPANY_NAME       | company                           |
        | OFFICE_NAME        | office                            |
        | DEBTOR_ID          | NotNone                           |
        | INSERTED_TIMESTAMP | NotNone                           |
        | UPDATED_TIMESTAMP  | NotNone                           |
        | INSERTED_BY        | activatePaymentNotice             |
        | UPDATED_BY         | activatePaymentNotice             |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      # POSITION_PAYMENT_PLAN
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                             |
        | ID                    | NotNone                           |
        | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId |
        | DUE_DATE              | 2021-12-31 00:00:00               |
        | RETENTION_DATE        | None                              |
        | AMOUNT                | $activatePaymentNotice.amount     |
        | FLAG_FINAL_PAYMENT    | Y                                 |
        | INSERTED_TIMESTAMP    | NotNone                           |
        | UPDATED_TIMESTAMP     | NotNone                           |
        | METADATA              | NotNone                           |
        | FK_POSITION_SERVICE   | NotNone                           |
        | INSERTED_BY           | activatePaymentNotice             |
        | UPDATED_BY            | activatePaymentNotice             |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      # POSITION_PAYMENT
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                     | value                                       |
        | ID                         | NotNone                                     |
        | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
        | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId           |
        | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
        | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
        | STATION_ID                 | #id_station#                                |
        | STATION_VERSION            | 2                                           |
        | PSP_ID                     | #pspPoste#                                  |
        | BROKER_PSP_ID              | #brokerPspPoste#                            |
        | CHANNEL_ID                 | #channelPoste#                              |
        | IDEMPOTENCY_KEY            | NotNone                                     |
        | AMOUNT                     | $activatePaymentNotice.amount               |
        | FEE                        | 2                                           |
        | OUTCOME                    | OK                                          |
        | PAYMENT_METHOD             | creditCard                                  |
        | PAYMENT_CHANNEL            | app                                         |
        | TRANSFER_DATE              | 2021-12-11                                  |
        | PAYER_ID                   | NotNone                                     |
        | APPLICATION_DATE           | 2021-12-12                                  |
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
      # POSITION_TRANSFER
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                   | value                               |
        | ID                       | NotNone                             |
        | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
        | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId   |
        | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
        | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
        | IBAN                     | IT45R0760103200000000001016         |
        | AMOUNT                   | $activatePaymentNotice.amount       |
        | REMITTANCE_INFORMATION   | testPaGetPayment                    |
        | TRANSFER_CATEGORY        | paGetPaymentTest                    |
        | TRANSFER_IDENTIFIER      | 1                                   |
        | VALID                    | Y                                   |
        | FK_POSITION_PAYMENT      | NotNone                             |
        | INSERTED_TIMESTAMP       | NotNone                             |
        | UPDATED_TIMESTAMP        | NotNone                             |
        | FK_PAYMENT_PLAN          | NotNone                             |
        | INSERTED_BY              | activatePaymentNotice               |
        | UPDATED_BY               | activatePaymentNotice               |
        | METADATA                 | None                                |
        | REQ_TIPO_BOLLO           | None                                |
        | REQ_HASH_DOCUMENTO       | None                                |
        | REQ_PROVINCIA_RESIDENZA  | None                                |
        | COMPANY_NAME_SECONDARY   | None                                |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      # POSITION_PAYMENT_STATUS
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                                                                   |
        | ID                    | NotNone                                                                                 |
        | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                       |
        | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                     |
        | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                       |
        | INSERTED_TIMESTAMP    | NotNone                                                                                 |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                       |
        | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                             |
        | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC              |
      And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      # POSITION_PAYMENT_STATUS_SNAPSHOT
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column                | value                                       |
        | ID                    | NotNone                                     |
        | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
        | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
        | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
        | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
        | STATUS                | NOTIFIED                                    |
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
      # POSITION_STATUS
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column             | value                                             |
        | ID                 | NotNone                                           |
        | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode                 |
        | NOTICE_ID          | $activatePaymentNotice.noticeNumber               |
        | STATUS             | PAYING,PAID,NOTIFIED                              |
        | INSERTED_TIMESTAMP | NotNone                                           |
        | INSERTED_BY        | activatePaymentNotice,sendPaymentOutcome,paSendRT |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP ASC              |
      And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
        | where_keys | where_values                        |
        | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
        | ORDER BY   | INSERTED_TIMESTAMP ASC              |
      # POSITION_STATUS_SNAPSHOT
      And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
        | column              | value                               |
        | ID                  | NotNone                             |
        | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
        | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
        | STATUS              | NOTIFIED                            |
        | INSERTED_TIMESTAMP  | NotNone                             |
        | UPDATED_TIMESTAMP   | NotNone                             |
        | FK_POSITION_SERVICE | NotNone                             |
        | ACTIVATION_PENDING  | N                                   |
        | INSERTED_BY         | activatePaymentNotice               |
        | UPDATED_BY          | sendPaymentOutcome                  |
      And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
        | where_keys     | where_values                        |
        | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
        | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
        | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
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
      And from $activatePaymentNoticeReq.idPSP xml check value #pspPoste# in position 0
      And from $activatePaymentNoticeReq.idBrokerPSP xml check value #brokerPspPoste# in position 0
      And from $activatePaymentNoticeReq.idChannel xml check value #channelPoste# in position 0
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
      And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
      # paGetPayment REQ
      And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                |
        | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                |
        | SOTTO_TIPO_EVENTO  | REQ                                         |
        | ESITO              | INVIATA                                     |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
        | ORDER BY           | DATA_ORA_EVENTO ASC                         |
      And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
      And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
      And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
      And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
      And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
      And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
      And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
      And from $paGetPaymentReq.transferType xml check value POSTAL in position 0
      # paGetPayment RESP
      And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys         | where_values                                |
        | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
        | TIPO_EVENTO        | paGetPayment                                |
        | SOTTO_TIPO_EVENTO  | RESP                                        |
        | ESITO              | RICEVUTA                                    |
        | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
        | ORDER BY           | DATA_ORA_EVENTO ASC                         |
      And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
      And from $paGetPaymentResp.outcome xml check value OK in position 0
      And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
      And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
      And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
      And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
      And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
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
      And from $sendPaymentOutcomeReq.idPSP xml check value #pspPoste# in position 0
      And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #brokerPspPoste# in position 0
      And from $sendPaymentOutcomeReq.idChannel xml check value #channelPoste# in position 0
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
      # paSendRT REQ
      And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                |
        | PAYMENT_TOKEN            | $activatePaymentNoticeResponse.paymentToken |
        | TIPO_EVENTO              | paSendRT                                    |
        | SOTTO_TIPO_EVENTO        | REQ                                         |
        | ESITO                    | INVIATA                                     |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                            |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                      |
      And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
      And from $paSendRTReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
      And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
      And from $paSendRTReq.idStation xml check value #id_station# in position 0
      And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
      And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
      And from $paSendRTReq.receipt.outcome xml check value OK in position 0
      And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
      And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNotice.amount in position 0
      And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
      And from $paSendRTReq.receipt.companyName xml check value company in position 0
      ### TRANSFER 1
      And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
      And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
      And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
      And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
      And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
      And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
      And from $paSendRTReq.receipt.idChannel xml check value #channelPoste# in position 0
      # paSendRT RESP
      And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
        | where_keys               | where_values                                |
        | PAYMENT_TOKEN            | $activatePaymentNoticeResponse.paymentToken |
        | TIPO_EVENTO              | paSendRT                                    |
        | SOTTO_TIPO_EVENTO        | RESP                                        |
        | ESITO                    | RICEVUTA                                    |
        | IDENTIFICATIVO_EROGATORE | #id_station#                                |
        | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                            |
        | ORDER BY                 | INSERTED_TIMESTAMP ASC                      |
      And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
      And from $paSendRTResp.outcome xml check value OK in position 0

 @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @POSTEPAY @POSTEPAYNEW @POSTEPAY_TOGGLE_03
  Scenario: NM3 flow OK, FLOW: verify -> paVerify activate -> paGetPayment --> spo+ -> paSendRT BIZ+ (NM3-1)
    Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'true' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | postepay_in_poste  |
    And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'POSTE1' on db nodo_cfg with where datatable horizontal
      | where_keys | where_values       |
      | CONFIG_KEY | lista_canali_poste |
    And waiting after triggered refresh job ALL
    And from body with datatable horizontal verifyPaymentNoticeBody_noOptional initial XML verifyPaymentNotice
      | idPSP      | idBrokerPSP            | idChannel      | password   | fiscalCode                  | noticeNumber |
      | #pspPoste# | #brokerPspPoste#       | #channelPoste# | #password# | #creditor_institution_code# | 302#iuv#     |
    And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
      | outcome            | OK                          |
      | amount             | 10.00                       |
      | options            | EQ                          |
      | allCCP             | false                       |
      | paymentDescription | Pagamento di Test           |
      | fiscalCodePA       | #creditor_institution_code# |
      | companyName        | companyName                 |
    And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
    Given from body with datatable horizontal activatePaymentNoticeBody_full initial XML activatePaymentNotice
      | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
    And from body with datatable vertical paGetPayment_full initial XML paGetPayment
      | outcome                     | OK                                |
      | creditorReferenceId         | 02$iuv                            |
      | paymentAmount               | 10.00                             |
      | dueDate                     | 2021-12-31                        |
      | description                 | pagamentoTest Postey              |
      | entityUniqueIdentifierType  | G                                 |
      | entityUniqueIdentifierValue | 77777777777                       |
      | fullName                    | Massimo Benvegnù                  |
      | transferAmount              | 10.00                             |
      | fiscalCodePA                | $activatePaymentNotice.fiscalCode |
      | IBAN                        | IT45R0760103200000000001016       |
      | remittanceInformation       | testPaGetPayment                  |
      | transferCategory            | paGetPaymentTest                  |
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
      | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                | outcome |
      | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeResponse.paymentToken | OK      |
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And wait 1 seconds for expiration
    # POSITION_ACTIVATE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                       |
      | ID                    | NotNone                                     |
      | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
      | PSP_ID                | #pspPoste#                                  |
      | IDEMPOTENCY_KEY       | NotNone                                     |
      | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
      | TOKEN_VALID_FROM      | NotNone                                     |
      | TOKEN_VALID_TO        | NotNone                                     |
      | DUE_DATE              | 2021-12-31 00:00:00                         |
      | AMOUNT                | $activatePaymentNotice.amount               |
      | INSERTED_TIMESTAMP    | NotNone                                     |
      | UPDATED_TIMESTAMP     | NotNone                                     |
      | INSERTED_BY           | activatePaymentNotice                       |
      | UPDATED_BY            | activatePaymentNotice                       |
      | PAYMENT_METHOD        | None                                        |
      | TOUCHPOINT            | None                                        |
      | SUGGESTED_IDBUNDLE    | None                                        |
      | SUGGESTED_IDCIBUNDLE  | None                                        |
      | SUGGESTED_USER_FEE    | None                                        |
      | SUGGESTED_PA_FEE      | None                                        |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
    # POSITION_SERVICE
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                             |
      | ID                 | NotNone                           |
      | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode |
      | DESCRIPTION        | pagamentoTest Postey              |
      | COMPANY_NAME       | company                           |
      | OFFICE_NAME        | office                            |
      | DEBTOR_ID          | NotNone                           |
      | INSERTED_TIMESTAMP | NotNone                           |
      | UPDATED_TIMESTAMP  | NotNone                           |
      | INSERTED_BY        | activatePaymentNotice             |
      | UPDATED_BY         | activatePaymentNotice             |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
    # POSITION_PAYMENT_PLAN
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                             |
      | ID                    | NotNone                           |
      | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode |
      | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId |
      | DUE_DATE              | 2021-12-31 00:00:00               |
      | RETENTION_DATE        | None                              |
      | AMOUNT                | $activatePaymentNotice.amount     |
      | FLAG_FINAL_PAYMENT    | Y                                 |
      | INSERTED_TIMESTAMP    | NotNone                           |
      | UPDATED_TIMESTAMP     | NotNone                           |
      | METADATA              | NotNone                           |
      | FK_POSITION_SERVICE   | NotNone                           |
      | INSERTED_BY           | activatePaymentNotice             |
      | UPDATED_BY            | activatePaymentNotice             |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
    # POSITION_PAYMENT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                     | value                                       |
      | ID                         | NotNone                                     |
      | PA_FISCAL_CODE             | $activatePaymentNotice.fiscalCode           |
      | CREDITOR_REFERENCE_ID      | $paGetPayment.creditorReferenceId           |
      | PAYMENT_TOKEN              | $activatePaymentNoticeResponse.paymentToken |
      | BROKER_PA_ID               | $activatePaymentNotice.fiscalCode           |
      | STATION_ID                 | #id_station#                                |
      | STATION_VERSION            | 2                                           |
      | PSP_ID                     | #pspPoste#                                  |
      | BROKER_PSP_ID              | #brokerPspPoste#                            |
      | CHANNEL_ID                 | #channelPoste#                              |
      | IDEMPOTENCY_KEY            | NotNone                                     |
      | AMOUNT                     | $activatePaymentNotice.amount               |
      | FEE                        | 2                                           |
      | OUTCOME                    | OK                                          |
      | PAYMENT_METHOD             | creditCard                                  |
      | PAYMENT_CHANNEL            | app                                         |
      | TRANSFER_DATE              | 2021-12-11                                  |
      | PAYER_ID                   | NotNone                                     |
      | APPLICATION_DATE           | 2021-12-12                                  |
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
    # POSITION_TRANSFER
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                   | value                               |
      | ID                       | NotNone                             |
      | NOTICE_ID                | $activatePaymentNotice.noticeNumber |
      | CREDITOR_REFERENCE_ID    | $paGetPayment.creditorReferenceId   |
      | PA_FISCAL_CODE           | $activatePaymentNotice.fiscalCode   |
      | PA_FISCAL_CODE_SECONDARY | $activatePaymentNotice.fiscalCode   |
      | IBAN                     | IT45R0760103200000000001016         |
      | AMOUNT                   | $activatePaymentNotice.amount       |
      | REMITTANCE_INFORMATION   | testPaGetPayment                    |
      | TRANSFER_CATEGORY        | paGetPaymentTest                    |
      | TRANSFER_IDENTIFIER      | 1                                   |
      | VALID                    | Y                                   |
      | FK_POSITION_PAYMENT      | NotNone                             |
      | INSERTED_TIMESTAMP       | NotNone                             |
      | UPDATED_TIMESTAMP        | NotNone                             |
      | FK_PAYMENT_PLAN          | NotNone                             |
      | INSERTED_BY              | activatePaymentNotice               |
      | UPDATED_BY               | activatePaymentNotice               |
      | METADATA                 | None                                |
      | REQ_TIPO_BOLLO           | None                                |
      | REQ_HASH_DOCUMENTO       | None                                |
      | REQ_PROVINCIA_RESIDENZA  | None                                |
      | COMPANY_NAME_SECONDARY   | None                                |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
    # POSITION_PAYMENT_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                                                                   |
      | ID                    | NotNone                                                                                 |
      | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode                                                       |
      | NOTICE_ID             | $activatePaymentNotice.noticeNumber                                                     |
      | STATUS                | PAYING,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED                                       |
      | INSERTED_TIMESTAMP    | NotNone                                                                                 |
      | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                       |
      | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken                                             |
      | INSERTED_BY           | activatePaymentNotice,sendPaymentOutcome,sendPaymentOutcome,sendPaymentOutcome,paSendRT |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      | ORDER BY       | INSERTED_TIMESTAMP ASC              |
    And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
    # POSITION_PAYMENT_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                | value                                       |
      | ID                    | NotNone                                     |
      | PA_FISCAL_CODE        | $activatePaymentNotice.fiscalCode           |
      | NOTICE_ID             | $activatePaymentNotice.noticeNumber         |
      | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId           |
      | PAYMENT_TOKEN         | $activatePaymentNoticeResponse.paymentToken |
      | STATUS                | NOTIFIED                                    |
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
    # POSITION_STATUS
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column             | value                                             |
      | ID                 | NotNone                                           |
      | PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode                 |
      | NOTICE_ID          | $activatePaymentNotice.noticeNumber               |
      | STATUS             | PAYING,PAID,NOTIFIED                              |
      | INSERTED_TIMESTAMP | NotNone                                           |
      | INSERTED_BY        | activatePaymentNotice,sendPaymentOutcome,paSendRT |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      | ORDER BY       | INSERTED_TIMESTAMP ASC              |
    And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                        |
      | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
      | ORDER BY   | INSERTED_TIMESTAMP ASC              |
    # POSITION_STATUS_SNAPSHOT
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column              | value                               |
      | ID                  | NotNone                             |
      | PA_FISCAL_CODE      | $activatePaymentNotice.fiscalCode   |
      | NOTICE_ID           | $activatePaymentNotice.noticeNumber |
      | STATUS              | NOTIFIED                            |
      | INSERTED_TIMESTAMP  | NotNone                             |
      | UPDATED_TIMESTAMP   | NotNone                             |
      | FK_POSITION_SERVICE | NotNone                             |
      | ACTIVATION_PENDING  | N                                   |
      | INSERTED_BY         | activatePaymentNotice               |
      | UPDATED_BY          | sendPaymentOutcome                  |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys     | where_values                        |
      | NOTICE_ID      | $activatePaymentNotice.noticeNumber |
      | PA_FISCAL_CODE | $activatePaymentNotice.fiscalCode   |
      | ORDER BY       | INSERTED_TIMESTAMP,ID ASC           |
    And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
      | where_keys | where_values                        |
      | NOTICE_ID  | $activatePaymentNotice.noticeNumber |
      | ORDER BY   | ID ASC                              |
    # POSITION_SUBJECT JOIN POSITION_SERVICE #Massimo Benvegnù
    And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
      | column                            | value                     |
      | su.ID                             | NotNone                   |
      | su.SUBJECT_TYPE                   | DEBTOR                    |
      | su.ENTITY_UNIQUE_IDENTIFIER_TYPE  | G                         |
      | su.ENTITY_UNIQUE_IDENTIFIER_VALUE | 77777777777               |
      | su.FULL_NAME                      | NotNone                   |
      | su.STREET_NAME                    | paGetPaymentStreet        |
      | su.CIVIC_NUMBER                   | paGetPayment99            |
      | su.POSTAL_CODE                    | 20155                     |
      | su.CITY                           | paGetPaymentCity          |
      | su.STATE_PROVINCE_REGION          | paGetPaymentState         |
      | su.COUNTRY                        | IT                        |
      | su.EMAIL                          | paGetPayment@provatest.it |
      | su.INSERTED_TIMESTAMP             | NotNone                   |
      | su.UPDATED_TIMESTAMP              | NotNone                   |
      | su.INSERTED_BY                    | activatePaymentNotice     |
      | su.UPDATED_BY                     | activatePaymentNotice     |
    And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SUBJECT su JOIN POSITION_SERVICE se ON su.ID = se.DEBTOR_ID retrived by the query on db nodo_online with where datatable horizontal
      | where_keys            | where_values                        |
      | se.NOTICE_ID          | $activatePaymentNotice.noticeNumber |
      | se.PA_FISCAL_CODE     | $activatePaymentNotice.fiscalCode   |
      | su.SUBJECT_TYPE       | DEBTOR                              |
      | su.INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                    |
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
    And from $activatePaymentNoticeReq.idPSP xml check value #pspPoste# in position 0
    And from $activatePaymentNoticeReq.idBrokerPSP xml check value #brokerPspPoste# in position 0
    And from $activatePaymentNoticeReq.idChannel xml check value #channelPoste# in position 0
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
    And from $activatePaymentNoticeResp.creditorReferenceId xml check value 02$iuv in position 0
    # paGetPayment REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                |
      | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
      | TIPO_EVENTO        | paGetPayment                                |
      | SOTTO_TIPO_EVENTO  | REQ                                         |
      | ESITO              | INVIATA                                     |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
      | ORDER BY           | DATA_ORA_EVENTO ASC                         |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
    And from $paGetPaymentReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
    And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNotice.fiscalCode in position 0
    And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
    And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNotice.fiscalCode in position 0
    And from $paGetPaymentReq.qrCode.noticeNumber xml check value 302$iuv in position 0
    And from $paGetPaymentReq.amount xml check value $activatePaymentNotice.amount in position 0
    And from $paGetPaymentReq.transferType xml check value None in position 0
    # paGetPayment RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys         | where_values                                |
      | PAYMENT_TOKEN      | $activatePaymentNoticeResponse.paymentToken |
      | TIPO_EVENTO        | paGetPayment                                |
      | SOTTO_TIPO_EVENTO  | RESP                                        |
      | ESITO              | RICEVUTA                                    |
      | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                            |
      | ORDER BY           | DATA_ORA_EVENTO ASC                         |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
    And from $paGetPaymentResp.outcome xml check value OK in position 0
    And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
    And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNotice.amount in position 0
    And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
    And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
    And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
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
    And from $sendPaymentOutcomeReq.idPSP xml check value #pspPoste# in position 0
    And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #brokerPspPoste# in position 0
    And from $sendPaymentOutcomeReq.idChannel xml check value #channelPoste# in position 0
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
    # paSendRT REQ
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys               | where_values                                |
      | PAYMENT_TOKEN            | $activatePaymentNoticeResponse.paymentToken |
      | TIPO_EVENTO              | paSendRT                                    |
      | SOTTO_TIPO_EVENTO        | REQ                                         |
      | ESITO                    | INVIATA                                     |
      | IDENTIFICATIVO_EROGATORE | #id_station#                                |
      | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                            |
      | ORDER BY                 | INSERTED_TIMESTAMP ASC                      |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
    And from $paSendRTReq.idPA xml check value $activatePaymentNotice.fiscalCode in position 0
    And from $paSendRTReq.idBrokerPA xml check value #creditor_institution_code# in position 0
    And from $paSendRTReq.idStation xml check value #id_station# in position 0
    And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNotice.noticeNumber in position 0
    And from $paSendRTReq.receipt.fiscalCode xml check value #creditor_institution_code# in position 0
    And from $paSendRTReq.receipt.outcome xml check value OK in position 0
    And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
    And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNotice.amount in position 0
    And from $paSendRTReq.receipt.description xml check value pagamentoTest Postey in position 0
    And from $paSendRTReq.receipt.companyName xml check value company in position 0
    ### TRANSFER 1
    And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
    And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNotice.amount in position 0
    And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNotice.fiscalCode in position 0
    And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
    And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
    And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
    And from $paSendRTReq.receipt.idChannel xml check value #channelPoste# in position 0
    # paSendRT RESP
    And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
      | where_keys               | where_values                                |
      | PAYMENT_TOKEN            | $activatePaymentNoticeResponse.paymentToken |
      | TIPO_EVENTO              | paSendRT                                    |
      | SOTTO_TIPO_EVENTO        | RESP                                        |
      | ESITO                    | RICEVUTA                                    |
      | IDENTIFICATIVO_EROGATORE | #id_station#                                |
      | INSERTED_TIMESTAMP       | TRUNC(SYSDATE-1)                            |
      | ORDER BY                 | INSERTED_TIMESTAMP ASC                      |
    And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
    And from $paSendRTResp.outcome xml check value OK in position 0

    @ALL @FLOW @FLOW_FULL @NM3 @NM3PANEW @POSTEPAY @POSTEPAYNEW @POSTEPAY_TOGGLE_04
Scenario: POSTEPAY_TOGGLE_04 PostePay Toggle FALSE + lista_canali_poste VUOTA: pagamento Poste storico - comportamento legacy attivo
  Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'false' on db nodo_cfg with where datatable horizontal
    | where_keys | where_values      |
    | CONFIG_KEY | postepay_in_poste |
  And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '' on db nodo_cfg with where datatable horizontal
    | where_keys | where_values       |
    | CONFIG_KEY | lista_canali_poste |
  And waiting after triggered refresh job ALL
  And update for table CANALI_NODO with parameter VERSIONE_PRIMITIVE = '2' on db nodo_cfg with where datatable horizontal
    | where_keys | where_values |
    | OBJ_ID     | 14748        |
  And waiting after triggered refresh job ALL
  And from body with datatable horizontal verificaBollettino initial XML verificaBollettino
    | idPSP      | idBrokerPSP      | idChannel      | password   | ccPost    | noticeNumber |
    | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #ccPoste# | 302#iuv#     |
  And from body with datatable vertical paVerifyPaymentNoticeBody_full initial XML paVerifyPaymentNotice
    | outcome            | OK                          |
    | amount             | 10.00                       |
    | options            | EQ                          |
    | allCCP             | false                       |
    | paymentDescription | Pagamento PostePay Toggle04  |
    | fiscalCodePA       | #creditor_institution_code# |
    | companyName        | companyName                 |
  And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
  When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
  Then check outcome is OK of verificaBollettino response
  Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
    | idPSP      | idBrokerPSP      | idChannel      | password   | fiscalCode                  | noticeNumber | amount |
    | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
  And from body with datatable vertical paGetPayment_full initial XML paGetPayment
    | outcome                     | OK                                  |
    | creditorReferenceId         | 02$iuv                              |
    | paymentAmount               | 10.00                               |
    | dueDate                     | 2021-12-31                          |
    | description                 | pagamentoPosteToggle04              |
    | entityUniqueIdentifierType  | G                                   |
    | entityUniqueIdentifierValue | 77777777777                         |
    | fullName                    | Massimo Test                        |
    | transferAmount              | 10.00                               |
    | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
    | IBAN                        | IT45R0760103200000000001016         |
    | remittanceInformation       | testPosteToggle04                   |
    | transferCategory            | PostePay                            |
    | transferType                | POSTAL                              |
  And EC replies to nodo-dei-pagamenti with the paGetPayment
  When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
  Then check outcome is OK of activatePaymentNoticeV2 response
  # paGetPayment REQ - Verifica transferType POSTAL per comportamento legacy
  And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
    | where_keys         | where_values                                  |
    | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
    | TIPO_EVENTO        | paGetPayment                                  |
    | SOTTO_TIPO_EVENTO  | REQ                                           |
    | ESITO              | INVIATA                                       |
    | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
    | ORDER BY           | DATA_ORA_EVENTO ASC                           |
  And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
  And from $paGetPaymentReq.transferType xml check value POSTAL in position 0
  Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
    | idPSP      | idBrokerPSP      | idChannel      | password   | paymentToken                                  | outcome |
    | #pspPoste# | #brokerPspPoste# | #channelPoste# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
  When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
  Then check outcome is OK of sendPaymentOutcomeV2 response
  # RESTORE
  Given update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = 'false' on db nodo_cfg with where datatable horizontal
    | where_keys | where_values      |
    | CONFIG_KEY | postepay_in_poste |
  And update for table CONFIGURATION_KEYS with parameter CONFIG_VALUE = '' on db nodo_cfg with where datatable horizontal
    | where_keys | where_values       |
    | CONFIG_KEY | lista_canali_poste |
  And waiting after triggered refresh job ALL
 