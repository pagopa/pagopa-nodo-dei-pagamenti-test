Feature: NMU flows con pagamento KO

    Background:
        Given systems up

    @ALL @FLOW @FLOW_NOOPT @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_1
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv2     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv3     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_1unknown_noOptional initial json v2/closepayment
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





    @ALL @FLOW @FLOW_NOOPT @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_2
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv2     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv3     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_noOptional initial json v2/closepayment
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




    @ALL @FLOW @FLOW_NOOPT @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_3
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv      | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv1     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv2     | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable horizontal activatePaymentNoticeV2Body_with_expiration_noOptional initial XML activatePaymentNoticeV2
            | idPSP          | idBrokerPSP       | idChannel         | password   | fiscalCode                  | noticeNumber | expirationTime | amount |
            | #pspEcommerce# | #brokerEcommerce# | #canaleEcommerce# | #password# | #creditor_institution_code# | 302$iuv3     | 2000           | 10.00  |
        And from body with datatable vertical paGetPayment_noOptional initial XML paGetPayment
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
        Given from body with datatable vertical closePaymentV2Body_CP_4paymentTokens_1unknown_noOptional initial json v2/closepayment
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