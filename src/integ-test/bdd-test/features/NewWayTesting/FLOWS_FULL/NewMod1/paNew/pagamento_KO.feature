Feature: NMU flows con pagamento KO

    Background:
        Given systems up

    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_1
    Scenario: NMU flow paNEW KO con Multitoken e close con 1 token unknown, FLOW: con checkPosition con 4 nav, 4xactivateV2 -> paGetPayment, closeV2+ con 4 token noti e un token sconosciuto riceve resp KO , nodo annulla i 4 token, 4xBIZ- (NMU-1)
        Given from body with datatable vertical checkPositionBody_4element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | fiscalCode3   | #creditor_institution_code# |
            | fiscalCode4   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
            | noticeNumber3 | 302#iuv2#                   |
            | noticeNumber4 | 302#iuv3#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv2     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_3Request
        And saving paGetPayment request in paGetPayment_3Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_3
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv3     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_4Request
        And saving paGetPayment request in paGetPayment_4Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_4
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_1unknown initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | token3                | $activatePaymentNoticeV2_3Response.paymentToken |
            | token4                | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #psp#                                           |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 42                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 42                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        And check description is Unknown token of v2/closepayment response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_3Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_4Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_3Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_4Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_1Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_1Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_2Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_2Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_3Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_3Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_3Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | NotNone                                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_4Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_4Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_4Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | NotNone                                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        #ACTIVATE 3
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_3Response.paymentToken |
        #ACTIVATE 4
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_4Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                                                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2_3Response.paymentToken,$activatePaymentNoticeV2_4Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2_1Request.idPSP,$activatePaymentNoticeV2_2Request.idPSP,$activatePaymentNoticeV2_3Request.idPSP,$activatePaymentNoticeV2_4Request.idPSP                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                                                                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber','$activatePaymentNoticeV2_3Request.noticeNumber','$activatePaymentNoticeV2_4Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                                                                                                                                |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                                                                                                                   |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # activatePaymentNoticeV2 RESP COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                                                                                                                   |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # paGetPayment REQ COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                                                                                                                              |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # paGetPayment RESP COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                                                                                                                              |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                                                                                                                           |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_3Response.paymentToken in position 2
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_4Response.paymentToken in position 3
        And from $closePaymentv2Req.totalAmount json check value 42.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 42.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                                                                                                                           |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0
        And from $closePaymentv2Resp.description json check value Unknown token in position 0





    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_2
    Scenario: NMU flow paNEW KO con Multitoken e close outcome KO, FLOW: con checkPosition con 4 nav, 4x activateV2 -> paGetPayment, closeV2- -> nodo annulla i 4 token, 4x BIZ- (NMU-2)
        Given from body with datatable vertical checkPositionBody_4element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | fiscalCode3   | #creditor_institution_code# |
            | fiscalCode4   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
            | noticeNumber3 | 302#iuv2#                   |
            | noticeNumber4 | 302#iuv3#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv2     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_3Request
        And saving paGetPayment request in paGetPayment_3Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_3
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv3     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_4Request
        And saving paGetPayment request in paGetPayment_4Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_4
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | token3                | $activatePaymentNoticeV2_3Response.paymentToken |
            | token4                | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #psp#                                           |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 42                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 42                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_3Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_4Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_3Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_4Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_1Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_1Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_2Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_2Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_3Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_3Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_3Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_4Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_4Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_4Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        #ACTIVATE 3
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_3Response.paymentToken |
        #ACTIVATE 4
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_4Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                                                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2_3Response.paymentToken,$activatePaymentNoticeV2_4Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2_1Request.idPSP,$activatePaymentNoticeV2_2Request.idPSP,$activatePaymentNoticeV2_3Request.idPSP,$activatePaymentNoticeV2_4Request.idPSP                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                                                                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber','$activatePaymentNoticeV2_3Request.noticeNumber','$activatePaymentNoticeV2_4Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                                                                                                                                |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                                                                                                                   |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # activatePaymentNoticeV2 RESP COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                                                                                                                   |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # paGetPayment REQ COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                                                                                                                              |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # paGetPayment RESP COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                                                                                                                              |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                                                                                                                           |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value KO in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_3Response.paymentToken in position 2
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_4Response.paymentToken in position 3
        And from $closePaymentv2Req.totalAmount json check value 42.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 42.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                                                                                                                           |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0




    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_3
    Scenario: NMU flow paNEW KO con Multitoken con un token scaduto, FLOW: con checkPosition con 4 nav, 4x activateV2 -> paGetPayment, mod3cancelV2 -> scade solo uno dei 4 token, closeV2+ con 4 token riceve resp KO e annulla gli altri 3 token rimasti ,4x BIZ- (NMU-3)
        Given from body with datatable vertical checkPositionBody_4element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | fiscalCode3   | #creditor_institution_code# |
            | fiscalCode4   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
            | noticeNumber3 | 302#iuv2#                   |
            | noticeNumber4 | 302#iuv3#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv2     | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_3Request
        And saving paGetPayment request in paGetPayment_3Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_3
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv3     | 2000           | 10.00  |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_4Request
        And saving paGetPayment request in paGetPayment_4Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_4
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_1unknown initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | token3                | $activatePaymentNoticeV2_3Response.paymentToken |
            | token4                | $activatePaymentNoticeV2_4Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #psp#                                           |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 42                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 42                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_3Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_4Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_3Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_4Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_3Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_4Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_1Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_1Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_2Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_2Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 3
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_3Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_3Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_3Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_3Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_3Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 4
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_4Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_4Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_4Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_4Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_4Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        #ACTIVATE 3
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_3Response.paymentToken |
        #ACTIVATE 4
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_4Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                                                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2_3Response.paymentToken,$activatePaymentNoticeV2_4Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2_1Request.idPSP,$activatePaymentNoticeV2_2Request.idPSP,$activatePaymentNoticeV2_3Request.idPSP,$activatePaymentNoticeV2_4Request.idPSP                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                                                                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber','$activatePaymentNoticeV2_3Request.noticeNumber','$activatePaymentNoticeV2_4Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                                                                                                                                |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                                                                                                                   |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # activatePaymentNoticeV2 RESP COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                                                                                                                   |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # paGetPayment REQ COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                                                                                                                              |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # paGetPayment RESP COUNT 4 RECORDS
        And verify 4 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                                                                                                                              |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                                                                                                                           |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                                                                                                                       |
            | ESITO              | RICEVUTA                                                                                                                                                                                                  |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_3Response.paymentToken in position 2
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_4Response.paymentToken in position 3
        And from $closePaymentv2Req.totalAmount json check value 42.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 42.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                                                                                                                              |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken','$activatePaymentNoticeV2_3Response.paymentToken','$activatePaymentNoticeV2_4Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                                                                                                                           |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                                                                                                                      |
            | ESITO              | INVIATA                                                                                                                                                                                                   |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                                                                                                                          |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                                                                                                                       |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0
        And from $closePaymentv2Resp.description json check value Unacceptable outcome when token has expired in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_4
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 1 nav, activateV2 -> paGetPayment, closeV2+ -> spoV2+ riceve resp OK, activateV2 -> KO PAGAMENTO_DUPLICATO  (OLD_NM1-2)
        Given from body with datatable horizontal checkPositionBody initial JSON checkPosition
            | fiscalCode                  | noticeNumber |
            | #creditor_institution_code# | 302#iuv#     |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  | 6000           |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #id_broker_psp#                               |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                            | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_IMMEDIATO_MULTIBENEFICIARIO# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber                          | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | $activatePaymentNoticeV2.noticeNumber | 10.00  |
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
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_PAGAMENTO_DUPLICATO of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And wait 1 seconds for expiration
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                            |
            | ID                    | NotNone                                                                                          |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode                                                     |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId                                                       |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken                                                  |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_SENT,NOTIFIED |
            | INSERTED_TIMESTAMP    | NotNone                                                                                          |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | NOTIFIED                                        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,PAID,NOTIFIED                         |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 3 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | NOTIFIED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#            |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | 2.0                                             |
            | OUTCOME                    | OK                                              |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | sendPaymentOutcomeV2                            |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken |
            | PSP_ID        | #id_broker_psp#                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                                                                               |
            | TRANSACTION_ID | $transaction_id                                                                                                     |
            | KEY            | Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn |
            | VALUE          | $activatePaymentNoticeV2Response.paymentToken,CP,00,2021-07-09T17:06:03,12,00,2,123456,11223344                     |
            | INSERTED_BY    | closePayment-v2                                                                                                     |
            | UPDATED_BY     | closePayment-v2                                                                                                     |
        And verify 9 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # # RE #####
        # activatePaymentNoticeV2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2_1Request.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        # activatePaymentNoticeV2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 02$iuv in position 0
        # activatePaymentNoticeV2 2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                      | where_values                                   |
            | NOTICE_ID                       | $activatePaymentNoticeV2_2Request.noticeNumber |
            | COALESCE(PAYMENT_TOKEN, 'NULL') | NULL                                           |
            | TIPO_EVENTO                     | activatePaymentNoticeV2                        |
            | SOTTO_TIPO_EVENTO               | REQ                                            |
            | ESITO                           | RICEVUTA                                       |
            | INSERTED_TIMESTAMP              | TRUNC(SYSDATE-1)                               |
            | ORDER BY                        | DATA_ORA_EVENTO ASC                            |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2_2Request.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2_2Request.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2_2Request.amount in position 0
        # activatePaymentNoticeV2 2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                      | where_values                                   |
            | NOTICE_ID                       | $activatePaymentNoticeV2_2Request.noticeNumber |
            | COALESCE(PAYMENT_TOKEN, 'NULL') | NULL                                           |
            | TIPO_EVENTO                     | activatePaymentNoticeV2                        |
            | SOTTO_TIPO_EVENTO               | RESP                                           |
            | ESITO                           | INVIATA                                        |
            | INSERTED_TIMESTAMP              | TRUNC(SYSDATE-1)                               |
            | ORDER BY                        | DATA_ORA_EVENTO ASC                            |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value KO in position 0
        # paGetPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentReq
        And from $paGetPaymentReq.idPA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idBrokerPA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.idStation xml check value #id_station# in position 0
        And from $paGetPaymentReq.qrCode.fiscalCode xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentReq.qrCode.noticeNumber xml check value $activatePaymentNoticeV2_1Request.noticeNumber in position 0
        And from $paGetPaymentReq.amount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentResp
        And from $paGetPaymentResp.outcome xml check value OK in position 0
        And from $paGetPaymentResp.data.creditorReferenceId xml check value 02$iuv in position 0
        And from $paGetPaymentResp.data.paymentAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $paGetPaymentResp.data.dueDate xml check value 2021-12-31 in position 0
        And from $paGetPaymentResp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentResp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $paGetPaymentResp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paGetPaymentResp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentResp.data.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paGetPaymentResp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # pspNotifyPayment REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                                |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentReq
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value tipoVersamento in position 0
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value CP in position 0
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value outcomePaymentGateway in position 1
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 1
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value timestampOperation in position 2
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2021-07-09T17:06:03 in position 2
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value totalAmount in position 3
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 12 in position 3
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value paymentGateway in position 4
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 00 in position 4
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value fee in position 5
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 2 in position 5
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value authorizationCode in position 6
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 123456 in position 6
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.key xml check value rrn in position 7
        And from $pspNotifyPaymentReq.additionalPaymentInformations.metadata.mapEntry.value xml check value 11223344 in position 7
        # pspNotifyPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | pspNotifyPayment                                |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key pspNotifyPaymentResp
        And from $pspNotifyPaymentResp.outcome json check value OK in position 0
        # paSendRT REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paSendRT                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTReq
        And from $paSendRTReq.idPA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paSendRTReq.idBrokerPA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paSendRTReq.idStation xml check value #id_station# in position 0
        And from $paSendRTReq.receipt.noticeNumber xml check value $activatePaymentNoticeV2_1Request.noticeNumber in position 0
        And from $paSendRTReq.receipt.fiscalCode xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paSendRTReq.receipt.outcome xml check value OK in position 0
        And from $paSendRTReq.receipt.creditorReferenceId xml check value 02$iuv in position 0
        And from $paSendRTReq.receipt.paymentAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $paSendRTReq.receipt.description xml check value pagamentoTest in position 0
        And from $paSendRTReq.receipt.companyName xml check value company in position 0
        And from $paSendRTReq.receipt.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2_1Request.amount in position 0
        And from $paSendRTReq.receipt.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2_1Request.fiscalCode in position 0
        And from $paSendRTReq.receipt.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paSendRTReq.receipt.transferList.transfer.remittanceInformation xml check value testPaGetPayment in position 0
        And from $paSendRTReq.receipt.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $paSendRTReq.receipt.idChannel xml check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $paSendRTReq.receipt.fee xml check value 2.00 in position 0
        # paSendRT RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paSendRT                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paSendRTResp
        And from $paSendRTResp.outcome xml check value OK in position 0



    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_5
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 -> 2x paGetPayment, closeV2+ con 2 token OUTCOME KO -> activateV2 token1 -> activateV2 token2 (OLD-NMU-32)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPayment request in paGetPayment_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPayment request in paGetPayment_2Request
        And replace 2iuv content with $iuv content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_1.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_1.idBrokerPSP          |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_2.idBrokerPSP          |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | $activatePaymentNoticeV2_1.idPSP,$activatePaymentNoticeV2_2.idPSP                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1.noticeNumber','$activatePaymentNoticeV2_2.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value KO in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$1iuv     | 10.00  | 60000          |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$1iuv                             |
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
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                           |
            | ID                 | NotNone                                         |
            | PRIMITIVA          | activatePaymentNoticeV2                         |
            | PSP_ID             | $activatePaymentNoticeV2.idPSP                  |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode             |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber           |
            | IDEMPOTENCY_KEY    | $activatePaymentNoticeV2_1.idempotencyKey       |
            | TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | VALID_TO           | NotNone                                         |
            | HASH_REQUEST       | NotNone                                         |
            | RESPONSE           | NotNone                                         |
            | INSERTED_TIMESTAMP | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
        And verify 1 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                         |
            | ID                    | NotNone                                                                                                                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED,PAYING                                                                                                                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                         |
            | ID                    | NotNone                                                                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                           |
            | FK_POSITION_PAYMENT   | NotNone                                                                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED,PAYING                                                                              |
            | INSERTED_TIMESTAMP    | NotNone                                                                                       |
            | UPDATED_TIMESTAMP     | NotNone                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$2iuv     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$2iuv                             |
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
        # IDEMPOTENCY_CACHE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                                                                         |
            | ID                 | NotNone                                                                                       |
            | PRIMITIVA          | activatePaymentNoticeV2                                                                       |
            | PSP_ID             | $activatePaymentNoticeV2.idPSP                                                                |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode                                                           |
            | NOTICE_ID          | $activatePaymentNoticeV2.noticeNumber                                                         |
            | IDEMPOTENCY_KEY    | $activatePaymentNoticeV2_2.idempotencyKey,$activatePaymentNoticeV2.idempotencyKey             |
            | TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2Response.paymentToken |
            | VALID_TO           | NotNone                                                                                       |
            | HASH_REQUEST       | NotNone                                                                                       |
            | RESPONSE           | NotNone                                                                                       |
            | INSERTED_TIMESTAMP | NotNone                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC             |
        And verify 2 record for the table IDEMPOTENCY_CACHE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                                                                         |
            | ID                    | NotNone                                                                                                                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                                                                           |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                                                                             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED,PAYING                                                                                                                       |
            | INSERTED_TIMESTAMP    | NotNone                                                                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                                                         |
            | ID                    | NotNone                                                                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                                                           |
            | FK_POSITION_PAYMENT   | NotNone                                                                                       |
            | CREDITOR_REFERENCE_ID | $paGetPayment.creditorReferenceId                                                             |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken,$activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED,PAYING                                                                              |
            | INSERTED_TIMESTAMP    | NotNone                                                                                       |
            | UPDATED_TIMESTAMP     | NotNone                                                                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 2 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_6
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 2 nav, activateV2 -> paGetPayment, activateV2 -> paGetPayment -> closeV2+ with token1 -> OK,  closeV2+ with token1 and token 2 and outcome KO -> KO Outcome already acquired  (OLD_NM1-33)
        Given from body with datatable vertical checkPositionBody_2element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  | 2000           |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv1                             |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response
        # POSITION_ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1Request.idempotencyKey |
        # POSITION_ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv1                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_2Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2Request.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                 |
            | ID                    | NotNone                                               |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode          |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken       |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED |
            | INSERTED_TIMESTAMP    | NotNone                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYMENT_ACCEPTED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | PAYING                                       |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | PAYING                                       |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_1Request.amount        |
            | FEE                        | 2.0                                             |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_2Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_2Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_2Request.amount        |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #psp#,$activatePaymentNoticeV2_2Request.idPSP                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                        |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                              |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                    |
            | PAYMENT_TOKEN                            | $activatePaymentNoticeV2_1Response.paymentToken |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#                                    |
            | TIPO_EVENTO                              | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                        | REQ                                             |
            | ESITO                                    | RICEVUTA                                        |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                    |
            | PAYMENT_TOKEN                            | $activatePaymentNoticeV2_1Response.paymentToken |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#                                    |
            | TIPO_EVENTO                              | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                        | RESP                                            |
            | ESITO                                    | INVIATA                                         |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # closePayment-v2 2 REQ                                       |
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                                                 | where_values                                    |
            | PAYMENT_TOKEN                                              | $activatePaymentNoticeV2_1Response.paymentToken |
            | COALESCE(IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA, 'NULL') | NULL                                            |
            | TIPO_EVENTO                                                | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                                          | REQ                                             |
            | ESITO                                                      | RICEVUTA                                        |
            | INSERTED_TIMESTAMP                                         | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                                   | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value KO in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                                                 | where_values                                    |
            | PAYMENT_TOKEN                                              | $activatePaymentNoticeV2_1Response.paymentToken |
            | COALESCE(IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA, 'NULL') | NULL                                            |
            | TIPO_EVENTO                                                | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                                          | RESP                                            |
            | ESITO                                                      | INVIATA                                         |
            | INSERTED_TIMESTAMP                                         | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                                   | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0





    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_7
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 2 nav, activateV2-> paGetPayment, activateV2 -> paGetPayment -> closeV2+ with token1 -> OK,  closeV2+ with token1 and token 2 -> KO Outcome already acquired  (OLD_NM1-34)
        Given from body with datatable vertical checkPositionBody_2element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  | 2000           |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv1                             |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 2 seconds for expiration
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Outcome already acquired of v2/closepayment response
        # POSITION_ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1Request.idempotencyKey |
        # POSITION_ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv1                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_2Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2Request.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                 |
            | ID                    | NotNone                                               |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode          |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken       |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED |
            | INSERTED_TIMESTAMP    | NotNone                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYMENT_ACCEPTED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING                                          |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS             | PAYING                                       |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | PAYING                                       |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | PAYING                                       |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_1Request.amount        |
            | FEE                        | 2.0                                             |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_2Request.idPSP         |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_2Request.idBrokerPSP   |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_2Request.amount        |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #psp#,$activatePaymentNoticeV2_2Request.idPSP                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                        |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                              |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                    |
            | PAYMENT_TOKEN                            | $activatePaymentNoticeV2_1Response.paymentToken |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#                                    |
            | TIPO_EVENTO                              | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                        | REQ                                             |
            | ESITO                                    | RICEVUTA                                        |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                    |
            | PAYMENT_TOKEN                            | $activatePaymentNoticeV2_1Response.paymentToken |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #id_station#                                    |
            | TIPO_EVENTO                              | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                        | RESP                                            |
            | ESITO                                    | INVIATA                                         |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # closePayment-v2 2 REQ                                        |
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                                                 | where_values                                    |
            | PAYMENT_TOKEN                                              | $activatePaymentNoticeV2_1Response.paymentToken |
            | COALESCE(IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA, 'NULL') | NULL                                            |
            | TIPO_EVENTO                                                | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                                          | REQ                                             |
            | ESITO                                                      | RICEVUTA                                        |
            | INSERTED_TIMESTAMP                                         | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                                   | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                                                 | where_values                                    |
            | PAYMENT_TOKEN                                              | $activatePaymentNoticeV2_1Response.paymentToken |
            | COALESCE(IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA, 'NULL') | NULL                                            |
            | TIPO_EVENTO                                                | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                                          | RESP                                            |
            | ESITO                                                      | INVIATA                                         |
            | INSERTED_TIMESTAMP                                         | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                                   | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_8
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 2 nav, activateV2 -> paGetPayment, activateV2 -> paGetPayment -> closeV2+ with token1 and outcome KO-> OK,  closeV2+ with token1 and token 2 and outcome KO-> KO Unacceptable outcome when token has expired  (OLD_NM1-35)
        Given from body with datatable vertical checkPositionBody_2element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  | 2000           |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv1                             |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        # POSITION_ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1Request.idempotencyKey |
        # POSITION_ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv1                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_2Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2Request.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_BY        | activatePaymentNoticeV2,closePayment-v2      |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_BY        | activatePaymentNoticeV2,closePayment-v2      |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                               |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_1Request.amount        |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                               |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_2Request.amount        |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #pspEcommerce#                                                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                        |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                              |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_9
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 2 nav, activateV2 -> paGetPayment, activateV2 token2 -> paGetPayment -> closeV2+ with token1 and outcome KO -> OK,  closeV2+ with token1 and token 2 -> KO Unacceptable outcome when token has expired  (OLD_NM1-36)
        Given from body with datatable vertical checkPositionBody_2element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | noticeNumber1 | 302#iuv#                    |
            | noticeNumber2 | 302#iuv1#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  | 2000           |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPayment request in paGetPayment_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  | 2000           |
        And from body with datatable vertical paGetPayment_full initial XML paGetPayment
            | outcome                     | OK                                  |
            | creditorReferenceId         | 02$iuv1                             |
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPayment request in paGetPayment_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 2 seconds for expiration
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        # POSITION_ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv                                          |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1Request.idempotencyKey |
        # POSITION_ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$iuv1                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_2Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2Request.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_BY        | activatePaymentNoticeV2,closePayment-v2      |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_BY        | activatePaymentNoticeV2,closePayment-v2      |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                               |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_1Request.amount        |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                  |
            | BROKER_PSP_ID              | #brokerEcommerce#                               |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2_2Request.amount        |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #pspEcommerce#                                                                                  |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                        |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                              |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                                                          |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |



    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_10
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 -> 2x paGetPayment (1x KO in PPT_SEMANTICA), closeV2+ con 2 token OUTCOME KO (OLD-NMU-41)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_Errore_emesso_da_pa initial XML paGetPayment
            | outcome | KO |
        And EC replies to nodo-dei-pagamenti with the paGetPayment
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPayment request in paGetPayment_2Request
        And replace 2iuv content with $iuv content
        And execution query to get value result_query on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN with db name nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And through the query result_query retrieve param paymentToken at position 0 and save it under the key paymentToken
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                             |
            | ID                    | NotNone                           |
            | CREDITOR_REFERENCE_ID | None                              |
            | PSP_ID                | #pspEcommerce#                    |
            | PAYMENT_TOKEN         | $paymentToken                     |
            | TOKEN_VALID_FROM      | None                              |
            | TOKEN_VALID_TO        | None                              |
            | DUE_DATE              | NotNone                           |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount |
            | INSERTED_TIMESTAMP    | NotNone                           |
            | UPDATED_TIMESTAMP     | NotNone                           |
            | INSERTED_BY           | activatePaymentNoticeV2           |
            | UPDATED_BY            | activatePaymentNoticeV2           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $paymentToken                                   |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 12                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 12                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 404
        And check outcome is KO of v2/closepayment response
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And verify 0 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And verify 0 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | $activatePaymentNoticeV2_2.idPSP                |
            | BROKER_PSP_ID              | $activatePaymentNoticeV2_2.idBrokerPSP          |
            | CHANNEL_ID                 | #canaleEcommerce#                               |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                         |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | None                                            |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                            |
            | TRANSACTION_ID             | None                                            |
            | CLOSE_VERSION              | None                                            |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values  |
            | ID_SESSIONE | $paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                        |
            | PAYMENT_TOKEN      | ('$paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                             |
            | SOTTO_TIPO_EVENTO  | REQ                                                                 |
            | ESITO              | RICEVUTA                                                            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                    |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                 |
        # activatePaymentNoticeV2 RESP COUNT 1 RECORD
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                         |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                        |
            | PAYMENT_TOKEN      | ('$paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPayment                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                 |
            | ESITO              | INVIATA                                                             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                    |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                 |
        # paGetPayment RESP COUNT 1 RECORD
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                        |
            | PAYMENT_TOKEN      | ('$paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                     |
            | SOTTO_TIPO_EVENTO  | REQ                                                                 |
            | ESITO              | RICEVUTA                                                            |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                    |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                 |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value KO in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                        |
            | PAYMENT_TOKEN      | ('$paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                     |
            | SOTTO_TIPO_EVENTO  | RESP                                                                |
            | ESITO              | INVIATA                                                             |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                    |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                 |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0




    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_11
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 -> 2x paGetPaymentV2, closeV2+ con 2 token e pspNotifyPaymentV2 KO (OLD-NMU-202)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And replace 2iuv content with $iuv content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        Given from body with datatable horizontal pspNotifyPaymentV2_KO initial XML pspNotifyPaymentV2
            | outcome | faultCode        |
            | KO      | CANALE_SEMANTICA |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
        And from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId                   |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken                |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId                   |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken                |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #psp#,#psp#                                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1.noticeNumber','$activatePaymentNoticeV2_2.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                |
        # PM_METADATA
        And verify 10 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0



    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_12
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 -> 1x paGetPayment, 1x paGetPaymentV2 -> pspNotifyPaymentV2 malformata -> closeV2+ con 2 token OUTCOME KO (OLD-NMU-44)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302#iuv#     | 10.00  |
        And from body with datatable vertical paGetPayment_full_with_meta initial XML paGetPayment
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
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPayment request in paGetPayment_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | companyName                 | company                             |
            | creditorReferenceId         | 10$iuv                              |
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
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPayment_2Request
        And replace 2iuv content with $iuv content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 02$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        Given from body with datatable horizontal pspNotifyPaymentV2_malformata_KO initial XML pspNotifyPaymentV2
            | outcome |
            | OO      |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
        And from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                |
            | ID                    | NotNone                                              |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode                |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN |
            | INSERTED_TIMESTAMP    | NotNone                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                |
            | ID                    | NotNone                                              |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode                |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN |
            | INSERTED_TIMESTAMP    | NotNone                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYMENT_UNKNOWN                                 |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYMENT_UNKNOWN                                 |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING                                |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING                                |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | PAYING                                |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | PAYING                                |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_1Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #id_station#                                    |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_1.amount               |
            | FEE                        | NotNone                                         |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | $transaction_id                                 |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPayment_2Request.creditorReferenceId      |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_2.amount               |
            | FEE                        | NotNone                                         |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | NotNone                                         |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | $transaction_id                                 |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # PM_METADATA
        And verify 10 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 1 RECORD
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                           |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken', '$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                   |
            | ESITO              | INVIATA                                                                                                |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                       |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                    |
        # paGetPayment REQ COUNT 1 RECORD
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        # paGetPaymentV2 REQ COUNT 1 RECORD
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                  |
            | SOTTO_TIPO_EVENTO  | REQ                                             |
            | ESITO              | INVIATA                                         |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        # paGetPayment RESP COUNT 1 RECORD
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_1Response.paymentToken |
            | TIPO_EVENTO        | paGetPayment                                    |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        # paGetPaymentV2 RESP COUNT 1 RECORD
        And verify 1 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                    |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2_2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                  |
            | SOTTO_TIPO_EVENTO  | RESP                                            |
            | ESITO              | RICEVUTA                                        |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                |
            | ORDER BY           | DATA_ORA_EVENTO ASC                             |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_13
    Scenario: NMU flow paNEW KO, FLOW: con checkPosition con 2 nav, activateV2 token1-> paGetPayment, activateV2 token2 -> paGetPayment -> pspNotifyPaymentV in timeout -> closeV2+ -> OK  (OLD_NM1-43)
        Given from body with datatable vertical checkPositionBody_2element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | noticeNumber1 | 310#iuv#                    |
            | noticeNumber2 | 310#iuv1#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv1     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv1                             |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable vertical pspNotifyPaymentV2_Timeout_noOptional initial XML pspNotifyPaymentV2
            | delay | 10000 |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
        And from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 2 seconds for expiration
        # POSITION_ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv                                          |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1Request.idempotencyKey |
        # POSITION_ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv1                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_2Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2Request.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                |
            | ID                    | NotNone                                              |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN |
            | INSERTED_TIMESTAMP    | NotNone                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                |
            | ID                    | NotNone                                              |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN |
            | INSERTED_TIMESTAMP    | NotNone                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ##ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYMENT_UNKNOWN                                 |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYMENT_UNKNOWN                                 |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING                                       |
            | INSERTED_BY        | activatePaymentNoticeV2                      |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING                                       |
            | INSERTED_BY        | activatePaymentNoticeV2                      |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | PAYING                                       |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | PAYING                                       |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_1Request.amount        |
            | FEE                        | 2.0                                             |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_2Request.amount        |
            | FEE                        | 2.0                                             |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #psp#                                                                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                        |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                              |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                                                                                                             |
            | TRANSACTION_ID | $transaction_id                                                                                                                                   |
            | KEY            | Token,Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn                         |
            | VALUE          | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,CP,00,2021-07-09T17:06:03,22,00,2,123456,11223344 |
            | INSERTED_BY    | closePayment-v2                                                                                                                                   |
            | UPDATED_BY     | closePayment-v2                                                                                                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # NMU_CANCEL_UTILITY
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value           |
            | PAYMENT_TOKENS     | NotNone         |
            | NUM_TOKEN          | 2               |
            | VALID_TO           | NotNone         |
            | INSERTED_TIMESTAMP | NotNone         |
            | INSERTED_BY        | closePayment-v2 |
            | BUSY               | NotNone         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table NMU_CANCEL_UTILITY retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                                                                          |
            | PAYMENT_TOKEN                            | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #stazione_versione_primitive_2#                                                                       |
            | TIPO_EVENTO                              | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO                        | REQ                                                                                                   |
            | ESITO                                    | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                    |
            | PAYMENT_TOKEN                            | $activatePaymentNoticeV2_1Response.paymentToken |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #stazione_versione_primitive_2#                 |
            | TIPO_EVENTO                              | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                        | RESP                                            |
            | ESITO                                    | INVIATA                                         |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0











    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_14
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 -> 2x paGetPaymentV2, closeV2+ con 2 token e pspNotifyPaymentV2 irraggiungibile (OLD-NMU-203)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And replace 2iuv content with $iuv content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        Given from body with datatable horizontal pspNotifyPaymentV2_irrag_KO initial XML pspNotifyPaymentV2
            | outcome         | faultCode        |
            | irraggiungibile | CANALE_SEMANTICA |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
        And from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                             |
            | ID                    | NotNone                                                           |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode                             |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken                   |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                             |
            | ID                    | NotNone                                                           |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode                             |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId                      |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken                   |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #psp#,#psp#                                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1.noticeNumber','$activatePaymentNoticeV2_2.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                |
        # PM_METADATA
        And verify 10 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_15 @after
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 -> 2x paGetPaymentV2, closeV2+ con 2 token e pspNotifyPaymentV2 malformata -> mod3CancelV2 (OLD-NMU-204)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And replace 2iuv content with $iuv content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        Given from body with datatable horizontal pspNotifyPaymentV2_malformata_KO initial XML pspNotifyPaymentV2
            | outcome |
            | OO      |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
        And from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId                   |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken                |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode                          |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId                   |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken                |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | 2.00                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #psp#,#psp#                                                                                     |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1.noticeNumber','$activatePaymentNoticeV2_2.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                |
        # PM_METADATA
        And verify 10 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0




    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_16
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 -> 2x paGetPaymentV2 -> pspNotifyPaymentV2 timeout -> closeV2+ -> mod3CancelV2 (OLD-NMU-46)
        Given update parameter default_durata_estensione_token_IO on configuration keys with value 3600000
        And waiting after triggered refresh job ALL
        And from body with datatable vertical checkPositionBody_2element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | noticeNumber1 | 310#iuv#                    |
            | noticeNumber2 | 310#iuv1#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | companyName                 | company                             |
            | creditorReferenceId         | 10$iuv                              |
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
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv1     | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | companyName                 | company                             |
            | creditorReferenceId         | 10$iuv1                             |
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
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And replace 2iuv content with $iuv1 content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        Given from body with datatable vertical pspNotifyPaymentV2_Timeout_noOptional initial XML pspNotifyPaymentV2
            | delay | 10000 |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
        And from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        # NMU_CANCEL_UTILITY
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value           |
            | TRANSACTION_ID     | $transaction_id |
            | PAYMENT_TOKENS     | NotNone         |
            | NUM_TOKEN          | 2               |
            | VALID_TO           | NotNone         |
            | INSERTED_TIMESTAMP | NotNone         |
            | INSERTED_BY        | closePayment-v2 |
            | BUSY               | N               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table NMU_CANCEL_UTILITY retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        When job mod3CancelV2 triggered after 0 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 5 seconds for expiration
        # NMU_CANCEL_UTILITY
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value           |
            | TRANSACTION_ID     | $transaction_id |
            | PAYMENT_TOKENS     | NotNone         |
            | NUM_TOKEN          | 2               |
            | VALID_TO           | NotNone         |
            | INSERTED_TIMESTAMP | NotNone         |
            | INSERTED_BY        | closePayment-v2 |
            | BUSY               | N               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table NMU_CANCEL_UTILITY retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        And verify 1 record for the table NMU_CANCEL_UTILITY retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                |
            | ID                    | NotNone                                              |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode                |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN |
            | INSERTED_TIMESTAMP    | NotNone                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC               |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                |
            | ID                    | NotNone                                              |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode                |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken      |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN |
            | INSERTED_TIMESTAMP    | NotNone                                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 4 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP,ID ASC               |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYMENT_UNKNOWN                                 |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYMENT_UNKNOWN                                 |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING                                |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING                                |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 1 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | PAYING                                |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | PAYING                                |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                                                                           |
            | ID                         | NotNone                                                                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode                                                             |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId,$paGetPaymentV2_2Request.creditorReferenceId       |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode                                                             |
            | STATION_ID                 | #stazione_versione_primitive_2#                                                                 |
            | STATION_VERSION            | 2                                                                                               |
            | PSP_ID                     | #psp#                                                                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                                                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                                                                   |
            | IDEMPOTENCY_KEY            | NotNone                                                                                         |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                                                                 |
            | FEE                        | 2                                                                                               |
            | OUTCOME                    | None                                                                                            |
            | PAYMENT_METHOD             | CP                                                                                              |
            | PAYMENT_CHANNEL            | WISP                                                                                            |
            | TRANSFER_DATE              | None                                                                                            |
            | PAYER_ID                   | None                                                                                            |
            | APPLICATION_DATE           | None                                                                                            |
            | INSERTED_TIMESTAMP         | NotNone                                                                                         |
            | UPDATED_TIMESTAMP          | NotNone                                                                                         |
            | FK_PAYMENT_PLAN            | NotNone                                                                                         |
            | RPT_ID                     | None                                                                                            |
            | PAYMENT_TYPE               | MOD3                                                                                            |
            | CARRELLO_ID                | None                                                                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                                                                            |
            | FLAG_IO                    | N                                                                                               |
            | RICEVUTA_PM                | Y                                                                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                                                                            |
            | FLAG_PAYPAL                | N                                                                                               |
            | INSERTED_BY                | activatePaymentNoticeV2                                                                         |
            | UPDATED_BY                 | closePayment-v2                                                                                 |
            | TRANSACTION_ID             | $transaction_id                                                                                 |
            | CLOSE_VERSION              | v2                                                                                              |
            | FEE_PA                     | 1                                                                                               |
            | BUNDLE_ID                  | NotNone                                                                                         |
            | BUNDLE_PA_ID               | NotNone                                                                                         |
            | PM_INFO                    | None                                                                                            |
            | MBD                        | N                                                                                               |
            | FEE_SPO                    | None                                                                                            |
            | PAYMENT_NOTE               | responseFull                                                                                    |
            | FLAG_STANDIN               | N                                                                                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        And verify 2 record for the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # PM_METADATA
        And verify 10 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORD
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                           |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken', '$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                                |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                   |
            | ESITO              | INVIATA                                                                                                |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                       |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                    |
        # paGetPaymentV2 REQ COUNT 2 RECORD
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                           |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken', '$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                         |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                    |
            | ESITO              | INVIATA                                                                                                |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                       |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                    |
        # paGetPaymentV2 RESP COUNT 2 RECORD
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                           |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken', '$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                         |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                   |
            | ESITO              | RICEVUTA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                       |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                    |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0











    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_17 @after
    Scenario: NMU flow paNEW VP2 KO, FLOW: con checkPosition con 2 nav, activateV2-> paGetPayment, activateV2 -> paGetPayment -> pspNotifyPaymentV2 in timeout -> closeV2+ -> mod3CancelV2  (OLD_NM1-47)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 16000
        And waiting after triggered refresh job ALL
        And from body with datatable vertical checkPositionBody_2element initial JSON checkPosition
            | fiscalCode1   | #creditor_institution_code# |
            | fiscalCode2   | #creditor_institution_code# |
            | noticeNumber1 | 310#iuv#                    |
            | noticeNumber2 | 310#iuv1#                   |
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv      | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1Request
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310$iuv1     | 10.00  | 120000         |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv1                             |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2Request
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        Given from body with datatable vertical pspNotifyPaymentV2_Timeout_noOptional initial XML pspNotifyPaymentV2
            | delay | 10000 |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2
        And from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 15 seconds for expiration
        # NMU_CANCEL_UTILITY
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value           |
            | PAYMENT_TOKENS     | NotNone         |
            | NUM_TOKEN          | 2               |
            | VALID_TO           | NotNone         |
            | INSERTED_TIMESTAMP | NotNone         |
            | INSERTED_BY        | closePayment-v2 |
            | BUSY               | NotNone         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table NMU_CANCEL_UTILITY retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        When job mod3CancelV2 triggered after 2 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        And wait 2 seconds for expiration
        # POSITION_ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv                                          |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_1Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1Request.idempotencyKey |
        # POSITION_ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$iuv1                                         |
            | PSP_ID                | #psp#                                           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2Request.amount        |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | closePayment-v2                                 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                                   |
            | NOTICE_ID      | $activatePaymentNoticeV2_2Request.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2Request.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                                     |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2Request.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode                   |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId                   |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken                |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode                   |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId                   |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken                |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ##ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_BY        | activatePaymentNoticeV2,mod3CancelV2         |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                        |
            | ID                 | NotNone                                      |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS             | PAYING,INSERTED                              |
            | INSERTED_BY        | activatePaymentNoticeV2,mod3CancelV2         |
            | INSERTED_TIMESTAMP | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                        |
            | ID                  | NotNone                                      |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2Request.fiscalCode |
            | STATUS              | INSERTED                                     |
            | FK_POSITION_SERVICE | NotNone                                      |
            | INSERTED_TIMESTAMP  | NotNone                                      |
            | UPDATED_TIMESTAMP   | NotNone                                      |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1Request.fiscalCode    |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_1Request.amount        |
            | FEE                        | 2.0                                             |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2Request.fiscalCode    |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #psp#                                           |
            | BROKER_PSP_ID              | #id_broker_psp#                                 |
            | CHANNEL_ID                 | #canale_versione_primitive_2#                   |
            | AMOUNT                     | $activatePaymentNoticeV2_2Request.amount        |
            | FEE                        | 2.0                                             |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | closePayment-v2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | NotNone                                         |
            | RICEVUTA_PM                | Y                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | N                                               |
            | TRANSACTION_ID             | NotNone                                         |
            | CLOSE_VERSION              | v2                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                         |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #psp#                                                                                           |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                                        |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1Request.noticeNumber','$activatePaymentNoticeV2_2Request.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                              |
        # PM_METADATA
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column         | value                                                                                                                                             |
            | TRANSACTION_ID | $transaction_id                                                                                                                                   |
            | KEY            | Token,Token,Tipo versamento,outcomePaymentGateway,timestampOperation,totalAmount,paymentGateway,fee,authorizationCode,rrn                         |
            | VALUE          | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken,CP,00,2021-07-09T17:06:03,22,00,2,123456,11223344 |
            | INSERTED_BY    | closePayment-v2                                                                                                                                   |
            | UPDATED_BY     | closePayment-v2                                                                                                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
            | ORDER BY       | ID ASC          |
        # NMU_CANCEL_UTILITY
        And verify 0 record for the table NMU_CANCEL_UTILITY retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPayment RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 1 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                                                                          |
            | PAYMENT_TOKEN                            | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #stazione_versione_primitive_2#                                                                       |
            | TIPO_EVENTO                              | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO                        | REQ                                                                                                   |
            | ESITO                                    | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 1 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys                               | where_values                                    |
            | PAYMENT_TOKEN                            | $activatePaymentNoticeV2_1Response.paymentToken |
            | IDENTIFICATIVO_STAZIONE_INTERMEDIARIO_PA | #stazione_versione_primitive_2#                 |
            | TIPO_EVENTO                              | closePayment-v2                                 |
            | SOTTO_TIPO_EVENTO                        | RESP                                            |
            | ESITO                                    | INVIATA                                         |
            | INSERTED_TIMESTAMP                       | TRUNC(SYSDATE-1)                                |
            | ORDER BY                                 | DATA_ORA_EVENTO ASC                             |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_18
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 with expiration Time -> 2x paGetPaymentV2 -> mod3CancelV2 -> closeV2+ KO con Unacceptable outcome when token has expired (OLD-NMU-205)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 2000           | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 2000           | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And replace 2iuv content with $iuv content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | OK                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                           |
            | BROKER_PSP_ID              | #brokerEcommerce#                                 |
            | CHANNEL_ID                 | #canaleEcommerce#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | None                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                               |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                           |
            | BROKER_PSP_ID              | #brokerEcommerce#                                 |
            | CHANNEL_ID                 | #canaleEcommerce#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | None                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                               |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #pspEcommerce#,#pspEcommerce#                                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1.noticeNumber','$activatePaymentNoticeV2_2.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0
        And from $closePaymentv2Resp.description json check value Unacceptable outcome when token has expired in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_19
    Scenario: NMU flow paNEW KO, FLOW: 2x activateV2 with expiration Time -> 2x paGetPaymentV2 -> mod3CancelV2 -> closeV2- KO con Unacceptable outcome when token has expired (OLD-NMU-206)
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 2000           | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_1
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1
        And saving paGetPaymentV2 request in paGetPaymentV2_1Request
        And replace 1iuv content with $iuv content
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 2000           | 10.00  |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And saving activatePaymentNoticeV2 request in activatePaymentNoticeV2_2
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_2
        And saving paGetPaymentV2 request in paGetPaymentV2_2Request
        And replace 2iuv content with $iuv content
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$1iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_1.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_1.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_1.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_1.idempotencyKey |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | CREDITOR_REFERENCE_ID | 10$2iuv                                         |
            | PSP_ID                | #pspEcommerce#                                  |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                         |
            | TOKEN_VALID_TO        | NotNone                                         |
            | DUE_DATE              | NotNone                                         |
            | AMOUNT                | $activatePaymentNoticeV2_2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
            | INSERTED_BY           | activatePaymentNoticeV2                         |
            | UPDATED_BY            | activatePaymentNoticeV2                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                            |
            | NOTICE_ID      | $activatePaymentNoticeV2_2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2_2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                              |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2_2.idempotencyKey |
        When job mod3CancelV2 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable vertical closePaymentV2Body_CP_2paymentTokens initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2_1Response.paymentToken |
            | token2                | $activatePaymentNoticeV2_2Response.paymentToken |
            | outcome               | KO                                              |
            | idPSP                 | #psp#                                           |
            | idBrokerPSP           | #id_broker_psp#                                 |
            | idChannel             | #canale_versione_primitive_2#                   |
            | paymentMethod         | CP                                              |
            | transactionId         | #transaction_id#                                |
            | totalAmountExt        | 22                                              |
            | feeExt                | 2                                               |
            | primaryCiIncurredFee  | 1                                               |
            | idBundle              | 0bf0c282-3054-11ed-af20-acde48001122            |
            | idCiBundle            | 0bf0c35e-3054-11ed-af20-acde48001122            |
            | timestampOperationExt | 2023-11-30T12:46:46.554+01:00                   |
            | rrn                   | 11223344                                        |
            | outPaymentGateway     | 00                                              |
            | totalAmount1          | 22                                              |
            | fee1                  | 2                                               |
            | timestampOperation1   | 2021-07-09T17:06:03                             |
            | authorizationCode     | 123456                                          |
            | paymentGateway        | 00                                              |
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 400
        And check outcome is KO of v2/closepayment response
        And check description is Unacceptable outcome when token has expired of v2/closepayment response
        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | PAYING,CANCELLED                                |
            | INSERTED_TIMESTAMP    | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_1.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_1Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                           |
            | ID                    | NotNone                                         |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2_2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                         |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2_2Response.paymentToken |
            | STATUS                | CANCELLED                                       |
            | INSERTED_TIMESTAMP    | NotNone                                         |
            | UPDATED_TIMESTAMP     | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_STATUS
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                 |
            | ID                 | NotNone                               |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS             | PAYING,INSERTED                       |
            | INSERTED_TIMESTAMP | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # POSITION_STATUS_SNAPSHOT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_1.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                                 |
            | ID                  | NotNone                               |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2_2.fiscalCode |
            | STATUS              | INSERTED                              |
            | FK_POSITION_SERVICE | NotNone                               |
            | INSERTED_TIMESTAMP  | NotNone                               |
            | UPDATED_TIMESTAMP   | NotNone                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
        # POSITION_PAYMENT
        ###ACTIVATE 1
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_1.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_1Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_1Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_1.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                           |
            | BROKER_PSP_ID              | #brokerEcommerce#                                 |
            | CHANNEL_ID                 | #canaleEcommerce#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | None                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                               |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_1.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        ###ACTIVATE 2
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                           |
            | ID                         | NotNone                                         |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2_2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2_2Request.creditorReferenceId    |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2_2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2_2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#                 |
            | STATION_VERSION            | 2                                               |
            | PSP_ID                     | #pspEcommerce#                                           |
            | BROKER_PSP_ID              | #brokerEcommerce#                                 |
            | CHANNEL_ID                 | #canaleEcommerce#                   |
            | AMOUNT                     | $activatePaymentNoticeV2.amount                 |
            | FEE                        | None                                            |
            | OUTCOME                    | None                                            |
            | INSERTED_BY                | activatePaymentNoticeV2                         |
            | UPDATED_BY                 | activatePaymentNoticeV2                                 |
            | FK_PAYMENT_PLAN            | NotNone                                         |
            | RPT_ID                     | None                                            |
            | PAYMENT_TYPE               | MOD3                                            |
            | CARRELLO_ID                | None                                            |
            | ORIGINAL_PAYMENT_TOKEN     | None                                            |
            | FLAG_IO                    | N                                               |
            | RICEVUTA_PM                | None                                               |
            | FLAG_ACTIVATE_RESP_MISSING | None                                            |
            | FLAG_PAYPAL                | None                                               |
            | TRANSACTION_ID             | None                                         |
            | CLOSE_VERSION              | None                                              |
            | INSERTED_TIMESTAMP         | NotNone                                         |
            | UPDATED_TIMESTAMP          | NotNone                                         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                            |
            | NOTICE_ID  | $activatePaymentNoticeV2_2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                  |
        # PM_SESSION_DATA
        #ACTIVATE 1
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_1Response.paymentToken |
        #ACTIVATE 2
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                    |
            | ID_SESSIONE | $activatePaymentNoticeV2_2Response.paymentToken |
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column        | value                                                                                           |
            | PAYMENT_TOKEN | $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken |
            | PSP_ID        | #pspEcommerce#,#pspEcommerce#                                                                   |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                                                          |
            | NOTICE_ID  | ('$activatePaymentNoticeV2_1.noticeNumber','$activatePaymentNoticeV2_2.noticeNumber') |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                                                                |
        # PM_METADATA
        And verify 0 record for the table PM_METADATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values    |
            | TRANSACTION_ID | $transaction_id |
        # RE #####
        # activatePaymentNoticeV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # activatePaymentNoticeV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | activatePaymentNoticeV2                                                                               |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 REQ COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # paGetPaymentV2 RESP COUNT 2 RECORDS
        And verify 2 record for the table RE retrived by the query on db re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | paGetPaymentV2                                                                                        |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | REQ                                                                                                   |
            | ESITO              | RICEVUTA                                                                                              |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_versione_primitive_2# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value KO in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_1Response.paymentToken in position 0
        And from $closePaymentv2Req.paymentTokens.paymentToken json check value $activatePaymentNoticeV2_2Response.paymentToken in position 1
        And from $closePaymentv2Req.totalAmount json check value 22.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 22.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                                                                          |
            | PAYMENT_TOKEN      | ('$activatePaymentNoticeV2_1Response.paymentToken','$activatePaymentNoticeV2_2Response.paymentToken') |
            | TIPO_EVENTO        | closePayment-v2                                                                                       |
            | SOTTO_TIPO_EVENTO  | RESP                                                                                                  |
            | ESITO              | INVIATA                                                                                               |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                                                                                      |
            | ORDER BY           | DATA_ORA_EVENTO ASC                                                                                   |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value KO in position 0
        And from $closePaymentv2Resp.description json check value Unacceptable outcome when token has expired in position 0







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_20 @after
    Scenario: NMU flow paNEW VP2 KO, FLOW: con activateV2-> paGetPaymentV2 -> pspNotifyPayment Timeout -> closeV2, mod3CancelV2 -> SPOV2- ->KO PPT_SEMANTICA (OLD_NM1-61)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical pspNotifyPayment_Timeout_noOptional initial XML pspNotifyPayment
            | delay | 10000 |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #id_broker_psp#                               |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 10 seconds for expiration
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal sendPaymentOutcomeV2Body_full initial XML sendPaymentOutcomeV2
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcomeV2 response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | closePayment-v2                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                            |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                  |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED                                     |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                |
            | ID                 | NotNone                              |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode  |
            | STATUS             | PAYING,INSERTED                      |
            | INSERTED_BY        | activatePaymentNoticeV2,mod3CancelV2 |
            | INSERTED_TIMESTAMP | NotNone                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
            | FK_POSITION_SERVICE | NotNone                             |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
            | DUE_DATE              | NotNone                         |
            | RETENTION_DATE        | None                            |
            | AMOUNT                | $activatePaymentNoticeV2.amount |
            | FLAG_FINAL_PAYMENT    | Y                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | NotNone                         |
            | FK_POSITION_SERVICE   | NotNone                         |
            | INSERTED_BY           | activatePaymentNoticeV2         |
            | UPDATED_BY            | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.0                                           |
            | OUTCOME                    | None                                          |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | closePayment-v2                               |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | NotNone                                       |
            | RICEVUTA_PM                | Y                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | FLAG_PAYPAL                | N                                             |
            | TRANSACTION_ID             | NotNone                                       |
            | CLOSE_VERSION              | v2                                            |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | company                 |
            | OFFICE_NAME        | office                  |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNoticeV2.amount     |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNoticeV2             |
            | UPDATED_BY               | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        #RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value /RFB/00202200000217527/5.00/TXT/ in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 10$iuv in position 0
        # paGetPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Req
        And from $paGetPaymentV2Req.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paGetPaymentV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Req.transferType xml check value PAGOPA in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Resp
        And from $paGetPaymentV2Resp.outcome xml check value OK in position 0
        And from $paGetPaymentV2Resp.data.creditorReferenceId xml check value 10$iuv in position 0
        And from $paGetPaymentV2Resp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # sendPaymentOutcomeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Req
        And from $sendPaymentOutcomeV2Req.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeV2Req.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeV2Req.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $sendPaymentOutcomeV2Req.password xml check value #password# in position 0
        And from $sendPaymentOutcomeV2Req.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeV2Req.outcome xml check value KO in position 0
        # sendPaymentOutcomeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcomeV2                          |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeV2Resp
        And from $sendPaymentOutcomeV2Resp.outcome xml check value KO in position 0







    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_21 @after
    Scenario: NMU flow paNEW VP2 KO, FLOW: con  activateV2-> paGetPaymentV2 -> pspNotifyPayment Timeout -> closeV2, mod3CancelV2 -> SPO+ ->KO PPT_SEMANTICA (OLD_NM1-62)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical pspNotifyPayment_Timeout_noOptional initial XML pspNotifyPayment
            | delay | 10000 |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #id_broker_psp#                               |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 10 seconds for expiration
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | OK      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | closePayment-v2                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                            |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                  |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED                                     |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                |
            | ID                 | NotNone                              |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode  |
            | STATUS             | PAYING,INSERTED                      |
            | INSERTED_BY        | activatePaymentNoticeV2,mod3CancelV2 |
            | INSERTED_TIMESTAMP | NotNone                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
            | FK_POSITION_SERVICE | NotNone                             |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
            | DUE_DATE              | NotNone                         |
            | RETENTION_DATE        | None                            |
            | AMOUNT                | $activatePaymentNoticeV2.amount |
            | FLAG_FINAL_PAYMENT    | Y                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | NotNone                         |
            | FK_POSITION_SERVICE   | NotNone                         |
            | INSERTED_BY           | activatePaymentNoticeV2         |
            | UPDATED_BY            | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.0                                           |
            | OUTCOME                    | None                                          |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | closePayment-v2                               |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | NotNone                                       |
            | RICEVUTA_PM                | Y                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | FLAG_PAYPAL                | N                                             |
            | TRANSACTION_ID             | NotNone                                       |
            | CLOSE_VERSION              | v2                                            |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | company                 |
            | OFFICE_NAME        | office                  |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNoticeV2.amount     |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNoticeV2             |
            | UPDATED_BY               | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        #RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value /RFB/00202200000217527/5.00/TXT/ in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 10$iuv in position 0
        # paGetPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Req
        And from $paGetPaymentV2Req.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paGetPaymentV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Req.transferType xml check value PAGOPA in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Resp
        And from $paGetPaymentV2Resp.outcome xml check value OK in position 0
        And from $paGetPaymentV2Resp.data.creditorReferenceId xml check value 10$iuv in position 0
        And from $paGetPaymentV2Resp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value OK in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0






    @ALL @FLOW @FLOW_FULL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_FULL_22 @after
    Scenario: NMU flow paNEW VP2 KO, FLOW: con  activateV2-> paGetPaymentV2 -> pspNotifyPayment Timeout -> closeV2, mod3CancelV2 -> SPO- ->KO PPT_SEMANTICA (OLD_NM1-63)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 1000
        And waiting after triggered refresh job ALL
        And from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_full initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount | expirationTime |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 310#iuv#     | 10.00  | 2000           |
        And from body with datatable vertical paGetPaymentV2_full initial XML paGetPaymentV2
            | outcome                     | OK                                  |
            | creditorReferenceId         | 10$iuv                              |
            | paymentAmount               | 10.00                               |
            | dueDate                     | 2021-12-12                          |
            | description                 | pagamentoTest                       |
            | companyName                 | company                             |
            | entityUniqueIdentifierType  | G                                   |
            | entityUniqueIdentifierValue | 44444444444                         |
            | fullName                    | Massimo Benvegnù                    |
            | transferAmount              | 10.00                               |
            | fiscalCodePA                | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                        | IT45R0760103200000000001016         |
            | remittanceInformation       | /RFB/00202200000217527/5.00/TXT/    |
            | transferCategory            | paGetPaymentTest                    |
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        Given from body with datatable vertical pspNotifyPayment_Timeout_noOptional initial XML pspNotifyPayment
            | delay | 10000 |
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment
        Given from body with datatable vertical closePaymentV2Body_CP initial json v2/closepayment
            | token1                | $activatePaymentNoticeV2Response.paymentToken |
            | outcome               | OK                                            |
            | idPSP                 | #psp#                                         |
            | idBrokerPSP           | #id_broker_psp#                               |
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
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
        And wait 10 seconds for expiration
        When job mod3CancelV2 triggered after 4 seconds
        Then verify the HTTP status code of mod3CancelV2 response is 200
        Given from body with datatable horizontal sendPaymentOutcomeBody_full initial XML sendPaymentOutcome
            | idPSP | idBrokerPSP     | idChannel                     | password   | paymentToken                                  | outcome |
            | #psp# | #id_broker_psp# | #canale_versione_primitive_2# | #password# | $activatePaymentNoticeV2Response.paymentToken | KO      |
        When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_SEMANTICA of sendPaymentOutcome response
        And wait 1 seconds for expiration
        # POSITION_ACTIVATE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | CREDITOR_REFERENCE_ID | 10$iuv                                        |
            | PSP_ID                | #psp#                                         |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | TOKEN_VALID_FROM      | NotNone                                       |
            | TOKEN_VALID_TO        | NotNone                                       |
            | DUE_DATE              | NotNone                                       |
            | AMOUNT                | $activatePaymentNoticeV2.amount               |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
            | INSERTED_BY           | activatePaymentNoticeV2                       |
            | UPDATED_BY            | closePayment-v2                               |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        And verify 1 record for the table POSITION_ACTIVATE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys      | where_values                            |
            | IDEMPOTENCY_KEY | $activatePaymentNoticeV2.idempotencyKey |
        # POSITION_PAYMENT_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                                          |
            | ID                    | NotNone                                                        |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode                            |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId                            |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken                  |
            | STATUS                | PAYING,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED |
            | INSERTED_TIMESTAMP    | NotNone                                                        |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 5 record for the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                                         |
            | ID                    | NotNone                                       |
            | PA_FISCAL_CODE        | $activatePaymentNoticeV2.fiscalCode           |
            | FK_POSITION_PAYMENT   | NotNone                                       |
            | CREDITOR_REFERENCE_ID | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN         | $activatePaymentNoticeV2Response.paymentToken |
            | STATUS                | CANCELLED                                     |
            | INSERTED_TIMESTAMP    | NotNone                                       |
            | UPDATED_TIMESTAMP     | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_STATUS
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                                |
            | ID                 | NotNone                              |
            | PA_FISCAL_CODE     | $activatePaymentNoticeV2.fiscalCode  |
            | STATUS             | PAYING,INSERTED                      |
            | INSERTED_BY        | activatePaymentNoticeV2,mod3CancelV2 |
            | INSERTED_TIMESTAMP | NotNone                              |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_STATUS_SNAPSHOT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column              | value                               |
            | ID                  | NotNone                             |
            | PA_FISCAL_CODE      | $activatePaymentNoticeV2.fiscalCode |
            | STATUS              | INSERTED                            |
            | FK_POSITION_SERVICE | NotNone                             |
            | INSERTED_TIMESTAMP  | NotNone                             |
            | UPDATED_TIMESTAMP   | NotNone                             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
        # POSITION_PAYMENT_PLAN
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                | value                           |
            | ID                    | NotNone                         |
            | CREDITOR_REFERENCE_ID | 10$iuv                          |
            | DUE_DATE              | NotNone                         |
            | RETENTION_DATE        | None                            |
            | AMOUNT                | $activatePaymentNoticeV2.amount |
            | FLAG_FINAL_PAYMENT    | Y                               |
            | INSERTED_TIMESTAMP    | NotNone                         |
            | UPDATED_TIMESTAMP     | NotNone                         |
            | METADATA              | NotNone                         |
            | FK_POSITION_SERVICE   | NotNone                         |
            | INSERTED_BY           | activatePaymentNoticeV2         |
            | UPDATED_BY            | activatePaymentNoticeV2         |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT_PLAN retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_PAYMENT
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                     | value                                         |
            | ID                         | NotNone                                       |
            | PA_FISCAL_CODE             | $activatePaymentNoticeV2.fiscalCode           |
            | CREDITOR_REFERENCE_ID      | $paGetPaymentV2.creditorReferenceId           |
            | PAYMENT_TOKEN              | $activatePaymentNoticeV2Response.paymentToken |
            | BROKER_PA_ID               | $activatePaymentNoticeV2.fiscalCode           |
            | STATION_ID                 | #stazione_versione_primitive_2#               |
            | STATION_VERSION            | 2                                             |
            | PSP_ID                     | #psp#                                         |
            | BROKER_PSP_ID              | #id_broker_psp#                               |
            | CHANNEL_ID                 | #canale_IMMEDIATO_MULTIBENEFICIARIO#          |
            | AMOUNT                     | $activatePaymentNoticeV2.amount               |
            | FEE                        | 2.0                                           |
            | OUTCOME                    | None                                          |
            | INSERTED_BY                | activatePaymentNoticeV2                       |
            | UPDATED_BY                 | closePayment-v2                               |
            | FK_PAYMENT_PLAN            | NotNone                                       |
            | RPT_ID                     | None                                          |
            | PAYMENT_TYPE               | MOD3                                          |
            | CARRELLO_ID                | None                                          |
            | ORIGINAL_PAYMENT_TOKEN     | None                                          |
            | FLAG_IO                    | NotNone                                       |
            | RICEVUTA_PM                | Y                                             |
            | FLAG_ACTIVATE_RESP_MISSING | None                                          |
            | FLAG_PAYPAL                | N                                             |
            | TRANSACTION_ID             | NotNone                                       |
            | CLOSE_VERSION              | v2                                            |
            | INSERTED_TIMESTAMP         | NotNone                                       |
            | UPDATED_TIMESTAMP          | NotNone                                       |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_PAYMENT retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                          |
            | NOTICE_ID  | $activatePaymentNoticeV2.noticeNumber |
            | ORDER BY   | INSERTED_TIMESTAMP ASC                |
        # POSITION_SERVICE
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column             | value                   |
            | ID                 | NotNone                 |
            | DESCRIPTION        | NotNone                 |
            | COMPANY_NAME       | company                 |
            | OFFICE_NAME        | office                  |
            | DEBTOR_ID          | NotNone                 |
            | INSERTED_TIMESTAMP | NotNone                 |
            | UPDATED_TIMESTAMP  | NotNone                 |
            | INSERTED_BY        | activatePaymentNoticeV2 |
            | UPDATED_BY         | activatePaymentNoticeV2 |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_SERVICE retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
        # POSITION_TRANSFER
        And generate list columns list_columns and dict fields values expected dict_fields_values_expected for query checks all values with datatable horizontal
            | column                   | value                               |
            | ID                       | NotNone                             |
            | CREDITOR_REFERENCE_ID    | 10$iuv                              |
            | PA_FISCAL_CODE_SECONDARY | $activatePaymentNoticeV2.fiscalCode |
            | IBAN                     | IT45R0760103200000000001016         |
            | AMOUNT                   | $activatePaymentNoticeV2.amount     |
            | REMITTANCE_INFORMATION   | NotNone                             |
            | TRANSFER_CATEGORY        | NotNone                             |
            | TRANSFER_IDENTIFIER      | 1                                   |
            | VALID                    | Y                                   |
            | FK_POSITION_PAYMENT      | NotNone                             |
            | INSERTED_TIMESTAMP       | NotNone                             |
            | UPDATED_TIMESTAMP        | NotNone                             |
            | FK_PAYMENT_PLAN          | NotNone                             |
            | INSERTED_BY              | activatePaymentNoticeV2             |
            | UPDATED_BY               | activatePaymentNoticeV2             |
        And checks all values by $dict_fields_values_expected of the record for each columns $list_columns of the table POSITION_TRANSFER retrived by the query on db nodo_online with where datatable horizontal
            | where_keys     | where_values                          |
            | NOTICE_ID      | $activatePaymentNoticeV2.noticeNumber |
            | PA_FISCAL_CODE | $activatePaymentNoticeV2.fiscalCode   |
            | ORDER BY       | INSERTED_TIMESTAMP,ID ASC             |
        # PM_SESSION_DATA
        And verify 0 record for the table PM_SESSION_DATA retrived by the query on db nodo_online with where datatable horizontal
            | where_keys  | where_values                                  |
            | ID_SESSIONE | $activatePaymentNoticeV2Response.paymentToken |
        #RE #####
        # activatePaymentNoticeV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Req
        And from $activatePaymentNoticeV2Req.idPSP xml check value #pspEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idBrokerPSP xml check value #brokerEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.idChannel xml check value #canaleEcommerce# in position 0
        And from $activatePaymentNoticeV2Req.password xml check value #password# in position 0
        And from $activatePaymentNoticeV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $activatePaymentNoticeV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        # activatePaymentNoticeV2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | activatePaymentNoticeV2                       |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key activatePaymentNoticeV2Resp
        And from $activatePaymentNoticeV2Resp.outcome xml check value OK in position 0
        And from $activatePaymentNoticeV2Resp.totalAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.paymentDescription xml check value pagamentoTest in position 0
        And from $activatePaymentNoticeV2Resp.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $activatePaymentNoticeV2Resp.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 1
        And from $activatePaymentNoticeV2Resp.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.remittanceInformation xml check value /RFB/00202200000217527/5.00/TXT/ in position 0
        And from $activatePaymentNoticeV2Resp.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        And from $activatePaymentNoticeV2Resp.creditorReferenceId xml check value 10$iuv in position 0
        # paGetPaymentV2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Req
        And from $paGetPaymentV2Req.idPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idBrokerPA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.idStation xml check value #stazione_versione_primitive_2# in position 0
        And from $paGetPaymentV2Req.qrCode.fiscalCode xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Req.qrCode.noticeNumber xml check value $activatePaymentNoticeV2.noticeNumber in position 0
        And from $paGetPaymentV2Req.amount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Req.transferType xml check value PAGOPA in position 0
        # paGetPayment RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | paGetPaymentV2                                |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key paGetPaymentV2Resp
        And from $paGetPaymentV2Resp.outcome xml check value OK in position 0
        And from $paGetPaymentV2Resp.data.creditorReferenceId xml check value 10$iuv in position 0
        And from $paGetPaymentV2Resp.data.paymentAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.dueDate xml check value 2021-12-12 in position 0
        And from $paGetPaymentV2Resp.data.description xml check value pagamentoTest in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.idTransfer xml check value 1 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferAmount xml check value $activatePaymentNoticeV2.amount in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.fiscalCodePA xml check value $activatePaymentNoticeV2.fiscalCode in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.IBAN xml check value IT45R0760103200000000001016 in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.remittanceInformation xml check value NotNone in position 0
        And from $paGetPaymentV2Resp.data.transferList.transfer.transferCategory xml check value paGetPaymentTest in position 0
        # closePayment-v2 REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Req
        And from $closePaymentv2Req.fee json check value 2.0 in position 0
        And from $closePaymentv2Req.idBrokerPSP json check value #id_broker_psp# in position 0
        And from $closePaymentv2Req.idChannel json check value #canale_IMMEDIATO_MULTIBENEFICIARIO# in position 0
        And from $closePaymentv2Req.idPSP json check value #psp# in position 0
        And from $closePaymentv2Req.outcome json check value OK in position 0
        And from $closePaymentv2Req.paymentMethod json check value CP in position 0
        And from $closePaymentv2Req.paymentToken json check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $closePaymentv2Req.totalAmount json check value 12.0 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.rrn json check value 11223344 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.outcomePaymentGateway json check value 00 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.totalAmount json check value 12.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.fee json check value 2.0 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.timestampOperation json check value 2021-07-09T17:06:03 in position 1
        And from $closePaymentv2Req.additionalPaymentInformations.authorizationCode json check value 123456 in position 0
        And from $closePaymentv2Req.additionalPaymentInformations.paymentGateway json check value 00 in position 0
        # closePayment-v2 RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | closePayment-v2                               |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve json PAYLOAD at position 0 and save it under the key closePaymentv2Resp
        And from $closePaymentv2Resp.outcome json check value OK in position 0
        # sendPaymentOutcome REQ
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | REQ                                           |
            | ESITO              | RICEVUTA                                      |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeReq
        And from $sendPaymentOutcomeReq.idPSP xml check value #psp# in position 0
        And from $sendPaymentOutcomeReq.idBrokerPSP xml check value #id_broker_psp# in position 0
        And from $sendPaymentOutcomeReq.idChannel xml check value #canale_versione_primitive_2# in position 0
        And from $sendPaymentOutcomeReq.password xml check value #password# in position 0
        And from $sendPaymentOutcomeReq.paymentTokens.paymentToken xml check value $activatePaymentNoticeV2Response.paymentToken in position 0
        And from $sendPaymentOutcomeReq.outcome xml check value KO in position 0
        # sendPaymentOutcome RESP
        And execution query to get value result_query on the table RE, with the columns PAYLOAD with db name re with where datatable horizontal
            | where_keys         | where_values                                  |
            | PAYMENT_TOKEN      | $activatePaymentNoticeV2Response.paymentToken |
            | TIPO_EVENTO        | sendPaymentOutcome                          |
            | SOTTO_TIPO_EVENTO  | RESP                                          |
            | ESITO              | INVIATA                                       |
            | INSERTED_TIMESTAMP | TRUNC(SYSDATE-1)                              |
            | ORDER BY           | DATA_ORA_EVENTO ASC                           |
        And through the query result_query retrieve xml PAYLOAD at position 0 and save it under the key sendPaymentOutcomeResp
        And from $sendPaymentOutcomeResp.outcome xml check value KO in position 0
