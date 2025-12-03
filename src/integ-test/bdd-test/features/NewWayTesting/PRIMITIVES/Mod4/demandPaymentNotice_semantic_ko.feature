Feature:  semantic checks for demandPaymentNoticeReq 925

    Background:
        Given systems up


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_1
    # idPSP value check: idPSP not in db [SEM_DPNR_01]
    Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idPSP with 1230984759 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_PSP_SCONOSCIUTO of demandPaymentNotice response

    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_2
    # idPSP value check: idPSP with field ENABLED = N [SEM_DPNR_02]
    Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idPSP with NOT_ENABLED in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_PSP_DISABILITATO of demandPaymentNotice response

    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_3
    # idBrokerPSP value check: idBrokerPSP not present in db [SEM_DPNR_03]
    Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idBrokerPSP with 1230984759 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_4
    # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_DPNR_04]
    Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idBrokerPSP with INT_NOT_ENABLED in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_5
    # idChannel value check: idChannel not in db [SEM_DPNR_05]
    Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idChannel with 1230984759 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_CANALE_SCONOSCIUTO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_6
    # idChannel value check: idChannel with field ENABLED = N [SEM_DPNR_06]
    Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idChannel with CANALE_NOT_ENABLED in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_CANALE_DISABILITATO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_7
    # password value check: wrong password for an idChannel [SEM_DPNR_08]
    Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And password with password in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_AUTENTICAZIONE of demandPaymentNotice response

    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_8
    # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_DPNR_09]
    Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idBrokerPSP with 91000000001 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_AUTORIZZAZIONE of demandPaymentNotice response
        And check description is Configurazione intermediario-canale non corretta of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_9
    # idSoggettoServizio value check: idSoggettoServizio not in db [SEM_DPNR_10]
    Scenario: Check PPT_SERVIZIO_SCONOSCIUTO error on non-existent idSoggettoServizio
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idSoggettoServizio with 00099 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SERVIZIO_SCONOSCIUTO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_10
    # idSoggettoServizio value check: idSoggettoServizio inactive [SEM_DPNR_11] - timestamp di arrivo della chiamata non compreso tra i timestamp presenti nei campi DATA_INIZIO_VALIDITA e DATA_FINE_VALIDITA del record trovato all'interno della tabella CDS_SOGGETTO_SERVIZIO
    Scenario: Check PPT_SERVIZIO_NONATTIVO error on inactive idSoggettoServizio
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idSoggettoServizio with 00002 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SERVIZIO_NONATTIVO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_11
    # idSoggettoServizio value check: idSoggettoServizio version 1 [SEM_DPNR_12]
    Scenario: Check PPT_VERSIONE_SERVIZIO error on idSoggettoServizio with version 1
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idSoggettoServizio with 60001 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_VERSIONE_SERVIZIO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_12
    # idDominio value check: idDominio not in PA table [SEM_DPNR_13] - l'idDominio ricavato dalla tabella CDS_SOGGETTO non è presente nella tabella PA
    Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent idDominio
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idSoggettoServizio with 00003 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_DOMINIO_SCONOSCIUTO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_13
    # idDominio value check: idDominio not enabled in PA table [SEM_DPNR_14] - l'idDominio ricavato dalla tabella CDS_SOGGETTO è presente nella tabella PA ed è disabilitato
    Scenario: Check PPT_DOMINIO_DISABILITATO error on not enabled idDominio
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idSoggettoServizio with 00004 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_DOMINIO_DISABILITATO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_14 @after
    # idBrokerPA value check: idBrokerPA not enabled [SEM_DPNR_15] - l'idBrokerPA ricavato è disabilitato
    Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on not enabled idBrokerPA
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And update for table INTERMEDIARI_PA with parameter ENABLED = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys          | where_values |
            | ID_INTERMEDIARIO_PA | 77777777777  |
        And refresh job ALL triggered after 10 seconds
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        And update for table INTERMEDIARI_PA with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys          | where_values |
            | ID_INTERMEDIARIO_PA | 77777777777  |
        And refresh job ALL triggered after 10 seconds
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_15
    # idStation value check: idStation not enabled to 4 model [SEM_DPNR_16] - l'idStation ricavata non è abilitata al quarto modello
    Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on idStation not enabled to 4 model
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And idSoggettoServizio with 80003 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of demandPaymentNotice response


    @ALL @PRIMITIVE @NM4 @NM4SEMDPNRKO @NM4SEMDPNRKO_16
    # idStation value check: idStation not enabled [SEM_DPNR_17] - l'idStation ricavata è disabilitata
    Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on idStation not enabled
        Given from body with datatable horizontal demandPaymentNotice initial XML demandPaymentNotice
            | idPSP | idBrokerPSP     | idChannel                    | password   | idSoggettoServizio |
            | #psp# | #id_broker_psp# | #canale_ATTIVATO_PRESSO_PSP# | #password# | 00005              |
        And update for table STAZIONI with parameter ENABLED = 'N' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values   |
            | ID_STAZIONE | 77777777777_01 |
        And refresh job ALL triggered after 10 seconds
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        And update for table STAZIONI with parameter ENABLED = 'Y' on db nodo_cfg with where datatable horizontal
            | where_keys  | where_values   |
            | ID_STAZIONE | 77777777777_01 |
        And refresh job ALL triggered after 10 seconds
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of demandPaymentNotice response