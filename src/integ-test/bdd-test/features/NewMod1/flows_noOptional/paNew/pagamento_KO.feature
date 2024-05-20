Feature: NMU flows con pagamento KO

    Background:
        Given systems up

    @ALL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_1
    Scenario: NMU flow KO con Multitoken e close con 1 token unknown, FLOW: con checkPosition con 4 nav, 4xactivateV2 -> paGetPayment, closeV2+ con 4 token noti e un token sconosciuto riceve resp KO , nodo annulla i 4 token, 4xBIZ- (NMU-1)
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
        And wait 5 seconds for expiration

        # POSITION_PAYMENT_STATUS
        ###ACTIVATE 1
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_1.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_1Request.noticeNumber |
        ###ACTIVATE 2
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_2Request.noticeNumber |
        ###ACTIVATE 3
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_3.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And checks the value $paGetPayment_3Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_3Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_3Request.noticeNumber |
        ###ACTIVATE 4
        And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_4.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And checks the value $paGetPayment_4Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And checks the value $activatePaymentNoticeV2_4Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And checks the value PAYING,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |
        And verify 2 record for the table POSITION_STATUS retrived by the query on db nodo_online with where datatable horizontal
            | where_keys | where_values                                   |
            | NOTICE_ID  | $activatePaymentNoticeV2_4Request.noticeNumber |


    # # POSITION_PAYMENT_STATUS_SNAPSHOT
    # And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

    # # POSITION_STATUS
    # And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column ID of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And verify 2 record for the table POSITION_STATUS retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

    # # POSITION_STATUS_SNAPSHOT
    # And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column ID of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column FK_POSITION_SERVICE of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

    # # POSITION_PAYMENT
    # And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $paGetPayment_1Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2_1Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_first_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $paGetPayment_2Request.creditorReferenceId of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value #id_station# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value 2 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1
    # And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query notice_id_second_activatev2 on db nodo_online under macro NewMod1

    # # PM_SESSION_DATA
    # And verify 0 record for the table PM_SESSION_DATA retrived by the query id_sessione on db nodo_online under macro NewMod1

    # # POSITION_ACTIVATE
    # And checks the value $activatePaymentNoticeV2_1Response.paymentToken,$activatePaymentNoticeV2_2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1
    # And checks the value $activatePaymentNoticeV2.idPSP,$activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query notice_id_2_activatev2 on db nodo_online under macro NewMod1

    # # PM_METADATA
    # And verify 0 record for the table PM_METADATA retrived by the query transactionid on db nodo_online under macro NewMod1






    @ALL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_2
    Scenario: NMU flow KO con Multitoken e close outcome KO, FLOW: con checkPosition con 4 nav, 4x activateV2 -> paGetPayment, closeV2- -> nodo annulla i 4 token, 4x BIZ- (NMU-2)
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



    @ALL @NMU @NMUPANEW @NMUPANEWPAGKO @NMUPANEWPAGKO_3
    Scenario: NMU flow KO con Multitoken con un token scaduto, FLOW: con checkPosition con 4 nav, 4x activateV2 -> paGetPayment, mod3cancelV2 -> scade solo uno dei 4 token, closeV2+ con 4 token riceve resp KO e annulla gli altri 3 token rimasti ,4x BIZ- (NMU-3)
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
      