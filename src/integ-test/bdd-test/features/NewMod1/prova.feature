Feature: prova

    Background:
        Given systems up

    Scenario: Assert
        Given checking the value NotNone of the record at column ID of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '311794281577753938' AND PA_FISCAL_CODE = '66666666666' on db nodo_online under macro generic_queries
        And checking the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query generic_select_id_asc with where condition NOTICE_ID = '311794281577753938' AND PA_FISCAL_CODE = '66666666666' on db nodo_online under macro generic_queries