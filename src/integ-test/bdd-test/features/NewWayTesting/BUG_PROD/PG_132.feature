Feature: BUG PROD


    Background:
        Given systems up


    @ALL @FLOW @FLOW_FULL @BUG @PG-132 @PG-132_1 @after
    Scenario: NMU flow sessione scaduta, FLOW con PA New vp1 e PSP na: checkPosition con 1 nav activateV2 -> paGetPayment (scadenza sessione), mod3cancelV2 in parallelo con closeV2+ con resp KO perché token scaduto (BUG-1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 2000           | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 4 seconds for expiration
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
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
        When calling primitive evolution v2/closepayment and mod3CancelV2 with POST and JOB in parallel with 8 ms delay
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
            | STATUS              | PAYING                                |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
            | FK_POSITION_SERVICE | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYMENT_ACCEPTED                              |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | mod3CancelV2                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # RE CRONOLOGIA EVENTI REQ E RESP
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column            | value                                                                                                                                                                               |
            | tipo_evento       | activatePaymentNoticeV2,paGetPayment,paGetPayment,activatePaymentNoticeV2,activatePaymentNoticeV2,activatePaymentNoticeV2,closePayment-v2,mod3CancelV2,mod3CancelV2,closePayment-v2 |
            | sotto_tipo_evento | REQ,REQ,RESP,INTERN,INTERN,RESP,REQ,INTERN,INTERN,RESP                                                                                                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |


    @ALL @FLOW @FLOW_FULL @BUG @PG-132 @PG-132_2 @after
    Scenario: NMU flow sessione scaduta, FLOW con PA New vp1 e PSP na: checkPosition con 1 nav activateV2 -> paGetPayment (scadenza sessione), mod3cancelV2 in parallelo con closeV2+ con resp KO perché token scaduto (BUG-2)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 2000           | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 4 seconds for expiration
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
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
        When calling primitive evolution mod3CancelV2 and v2/closepayment with JOB and POST in parallel with 40 ms delay
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
            | STATUS              | INSERTED                              |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
            | FK_POSITION_SERVICE | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED                                     |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | mod3CancelV2                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # RE CRONOLOGIA EVENTI REQ E RESP
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column            | value                                                                                                                                                                               |
            | tipo_evento       | activatePaymentNoticeV2,paGetPayment,paGetPayment,activatePaymentNoticeV2,activatePaymentNoticeV2,activatePaymentNoticeV2,mod3CancelV2,mod3CancelV2,closePayment-v2,closePayment-v2 |
            | sotto_tipo_evento | REQ,REQ,RESP,INTERN,INTERN,RESP,INTERN,INTERN,REQ,RESP                                                                                                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |


    @ALL @FLOW @FLOW_FULL @BUG @PG-132 @PG-132_3 @after
    Scenario: NMU flow sessione scaduta, FLOW con PA New vp1 e PSP na: checkPosition con 1 nav activateV2 -> paGetPayment (scadenza sessione), mod3cancelV2 in parallelo con closeV2+ con resp KO perché token scaduto (BUG-3)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 2000           | 10.00  |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-31                          |
            | description                 | pagamentoTest                       |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 77777777777                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | testPaGetPayment                    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And wait 4 seconds for expiration
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #psp#                                         |
            | idChannel             | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | paymentMethod         | CP                                            |
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
        When calling primitive evolution v2/closepayment and mod3CancelV2 with POST and JOB in parallel with 50 ms delay
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode   |
            | NOTICE_ID           | $activatePaymentNoticeV2.noticeNumber |
            | STATUS              | PAYING                                |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
            | FK_POSITION_SERVICE | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | ID ASC                                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | NOTICE_ID             | $activatePaymentNoticeV2.noticeNumber         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                        |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYMENT_ACCEPTED                              |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | closePayment-v2                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | ID ASC                                |
        # RE CRONOLOGIA EVENTI REQ E RESP
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column            | value                                                                                                                                                                                                                                       |
            | tipo_evento       | activatePaymentNoticeV2,paGetPayment,paGetPayment,activatePaymentNoticeV2,activatePaymentNoticeV2,activatePaymentNoticeV2,closePayment-v2,closePayment-v2,closePayment-v2,closePayment-v2,pspNotifyPayment,pspNotifyPayment,closePayment-v2 |
            | sotto_tipo_evento | REQ,REQ,RESP,INTERN,INTERN,RESP,REQ,INTERN,RESP,INTERN,REQ,RESP,INTERN                                                                                                                                                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |