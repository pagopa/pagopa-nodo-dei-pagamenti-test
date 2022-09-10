Feature: semantic checks KO for activatePaymentNoticeV2Request

    Background:
        Given systems up

    Scenario: Prova update
        Given updating through the query generic_update of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED with where condition NOTICE_ID = 311019101221191500 under macro generic_queries on db nodo_online

    Scenario: Prova select
        Given the scenario Prova update executed successfully
        And checking the value NOTIFIED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select with where condition NOTICE_ID = 311019101221191500 on db nodo_online under macro generic_queries

    Scenario: Ripristino update
        Given the scenario Prova select executed successfully
        And updating through the query generic_update of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with NOTICE_SENT with where condition NOTICE_ID = 311019101221191500 under macro generic_queries on db nodo_online