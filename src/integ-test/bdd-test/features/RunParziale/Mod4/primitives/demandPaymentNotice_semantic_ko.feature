Feature:  semantic checks for demandPaymentNoticeReq

    Background:
        Given systems up
        And initial XML demandPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:demandPaymentNoticeRequest>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idSoggettoServizio>00005</idSoggettoServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0byB4bWxuczp0YT0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byIgeG1sbnM6eHNpPSJodHRwOi8vd3d3LnczLm9yZy8yMDAxL1hNTFNjaGVtYS1pbnN0YW5jZSIgeHNpOnNjaGVtYUxvY2F0aW9uPSJodHRwOi8vUHVudG9BY2Nlc3NvUFNQLnNwY29vcC5nb3YuaXQvVGFzc2FBdXRvIFRhc3NhQXV0b21vYmlsaXN0aWNhXzFfMF8wLnhzZCAiPgo8dGE6dmVpY29sb0NvblRhcmdhPgo8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPgo8dGE6dmVpY29sb1RhcmdhPkFCMzQ1Q0Q8L3RhOnZlaWNvbG9UYXJnYT4KPC90YTp2ZWljb2xvQ29uVGFyZ2E+CjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </nod:demandPaymentNoticeRequest>
            </soapenv:Body>
            </soapenv:Envelope>
            """
    @demandSemKO_1 @Mod4 @ALL
    # idPSP value check: idPSP not in db
    Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
        Given idPSP with 1230984759 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_PSP_SCONOSCIUTO of demandPaymentNotice response
    
    @demandSemKO_2 @Mod4 @ALL
    # idPSP value check: idPSP with field ENABLED = N
    Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
        Given idPSP with NOT_ENABLED in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_PSP_DISABILITATO of demandPaymentNotice response

    @demandSemKO_3 @Mod4 @ALL
    # idBrokerPSP value check: idBrokerPSP not present in db
    Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
        Given idBrokerPSP with 1230984759 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of demandPaymentNotice response
    
    @demandSemKO_4 @Mod4 @ALL
    # idBrokerPSP value check: idBrokerPSP with field ENABLED = N
    Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
        Given idBrokerPSP with INT_NOT_ENABLED in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of demandPaymentNotice response
   
    @demandSemKO_5 @Mod4 @ALL
    # idChannel value check: idChannel not in db
    Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
        Given idChannel with 1230984759 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_CANALE_SCONOSCIUTO of demandPaymentNotice response
    
    @demandSemKO_6 @Mod4 @ALL
    # idChannel value check: idChannel with field ENABLED = N
    Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
        Given idChannel with CANALE_NOT_ENABLED in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_CANALE_DISABILITATO of demandPaymentNotice response
    
    @demandSemKO_7 @Mod4 @ALL
    # password value check: wrong password for an idChannel
    Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
        Given password with password in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_AUTENTICAZIONE of demandPaymentNotice response
    
    @demandSemKO_8 @Mod4 @ALL
    # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP
    Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
        Given idBrokerPSP with 91000000001 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_AUTORIZZAZIONE of demandPaymentNotice response
        And check description is Configurazione intermediario-canale non corretta of demandPaymentNotice response
    
    @demandSemKO_9 @Mod4 @ALL
    # idSoggettoServizio value check: idSoggettoServizio not in db
    Scenario: Check PPT_SERVIZIO_SCONOSCIUTO error on non-existent idSoggettoServizio
        Given idSoggettoServizio with 00099 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SERVIZIO_SCONOSCIUTO of demandPaymentNotice response

    @demandSemKO_10 @Mod4 @ALL 
    # idSoggettoServizio value check: idSoggettoServizio inactive - timestamp di arrivo della chiamata non compreso tra i timestamp presenti nei campi DATA_INIZIO_VALIDITA e DATA_FINE_VALIDITA del record trovato all'interno della tabella CDS_SOGGETTO_SERVIZIO
    Scenario: Check PPT_SERVIZIO_NONATTIVO error on inactive idSoggettoServizio
        Given idSoggettoServizio with 00002 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_SERVIZIO_NONATTIVO of demandPaymentNotice response

    @demandSemKO_11 @Mod4 @ALL
    # idSoggettoServizio value check: idSoggettoServizio version 1
    Scenario: Check PPT_VERSIONE_SERVIZIO error on idSoggettoServizio with version 1
        Given idSoggettoServizio with 60001 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_VERSIONE_SERVIZIO of demandPaymentNotice response

    @demandSemKO_12 @Mod4 @ALL
    # idDominio value check: idDominio not in PA table - l'idDominio ricavato dalla tabella CDS_SOGGETTO non è presente nella tabella PA
    Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent idDominio
        Given idSoggettoServizio with 00003 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_DOMINIO_SCONOSCIUTO of demandPaymentNotice response

    @demandSemKO_13 @Mod4 @ALL 
    # idDominio value check: idDominio not enabled in PA table - l'idDominio ricavato dalla tabella CDS_SOGGETTO è presente nella tabella PA ed è disabilitato
    Scenario: Check PPT_DOMINIO_DISABILITATO error on not enabled idDominio
        Given idSoggettoServizio with 00004 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_DOMINIO_DISABILITATO of demandPaymentNotice response

    @demandSemKO_14 @Mod4 @ALL 
    # idBrokerPA value check: idBrokerPA not enabled - l'idBrokerPA ricavato è disabilitato
    Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on not enabled idBrokerPA
        Given updates through the query update_id_intermediario_pa of the table INTERMEDIARI_PA the parameter ENABLED with N under macro Mod4 on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        And updates through the query update_id_intermediario_pa of the table INTERMEDIARI_PA the parameter ENABLED with Y under macro Mod4 on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of demandPaymentNotice response

    @demandSemKO_15 @Mod4 @ALL 
    # idStation value check: idStation not enabled to 4 model - l'idStation ricavata non è abilitata al quarto modello
    Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on idStation not enabled to 4 model
        Given idSoggettoServizio with 80003 in demandPaymentNotice
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of demandPaymentNotice response

    @demandSemKO_16 @Mod4 @ALL
    # idStation value check: idStation not enabled - l'idStation ricavata è disabilitata
    Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on idStation not enabled
        Given updates through the query update_id_stazione of the table STAZIONI the parameter ENABLED with N under macro Mod4 on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
        And updates through the query update_id_stazione of the table STAZIONI the parameter ENABLED with Y under macro Mod4 on db nodo_cfg
        And refresh job ALL triggered after 10 seconds
        Then check outcome is KO of demandPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of demandPaymentNotice response