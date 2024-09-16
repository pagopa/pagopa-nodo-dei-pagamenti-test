Feature: JIRA - PG-108

    # Questo test vuole verificare che, a seguito della fix riportata nel PG 108, la URL della chiamata verso la stazione scelta tramite l'idSoggettoServizio venga composta prendendo il SERVIZIO_POF e non più il SERVIZIO_4MOD 

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM4 @PG108
    Scenario: demandPaymentNotice
        Given generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter SERVIZIO_POF = 'POF', with where condition OBJ_ID = '16631' under macro update_query on db nodo_cfg
        And generic update through the query param_update_generic_where_condition of the table STAZIONI the parameter IP = 'api.dev.platform.pagopa.it', with where condition OBJ_ID = '16631' under macro update_query on db nodo_cfg
        And waiting after triggered refresh job ALL
        And wait 2 seconds for expiration
        Given from body with datatable horizontal demandPaymentNotice_noOptional initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00042              |
        And from body with datatable vertical paDemandPaymentNotice_noOptional initial XML paDemandPaymentNotice
            | outcome            | OK                          |
            | fiscalCode         | #creditor_institution_code# |
            | noticeNumber       | 302#iuv#                    |
            | amount             | 10.00                       |
            | options            | EQ                          |
            | allCCP             | false                       |
            | paymentDescription | paymentDescription          |
            | fiscalCodPA        | #creditor_institution_code# |
            | companyName        | companyName                 |
            | officeName         | officeName                  |
        And EC replies to nodo-dei-pagamenti with the paDemandPaymentNotice
        When psp sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of demandPaymentNotice response