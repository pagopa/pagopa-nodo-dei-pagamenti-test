Feature:  semantic checks for demandPaymentNoticeReq

  Background:
    Given systems up
    And initial demandPaymentNoticeReq soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:demandPaymentNoticeRequest>
                 <idPSP>70000000001</idPSP>
                 <idBrokerPSP>70000000001</idBrokerPSP>
                 <idChannel>70000000001_01</idChannel>
                 <password>pwdpwdpwd</password>
                 <idServizio>00003</idServizio>
                 <datiSpecificiServizio>ciao</datiSpecificiServizio>
              </nod:demandPaymentNoticeRequest>
           </soapenv:Body>
        </soapenv:Envelope>
      """

  # idPSP value check: idPSP not in db [SEM_DPNR_01]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given idPSP with pspUnknown in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_SCONOSCIUTO

  # idPSP value check: idPSP with field ENABLED = N [SEM_DPNR_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_DISABILITATO

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_DPNR_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_DPNR_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO

  # idChannel value check: idChannel not in db [SEM_DPNR_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_SCONOSCIUTO

  # idChannel value check: idChannel with field ENABLED = N [SEM_DPNR_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_DISABILITATO
  
    # password value check: wrong password for an idChannel [SEM_DPNR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given idChannel with 70000000001 in demandPaymentNoticeReq
    Given password with password in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTENTICAZIONE        
    
    # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_DPNR_09]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 91000000001 in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTORIZZAZIONE
    And check description is Configurazione intermediario-canale non corretta
    
    # idServizio value check: idServizio not in db [SEM_DPNR_10]
  Scenario: Check PPT_SERVIZIO_SCONOSCIUTO error on non-existent idServizio
    Given idServizio with idServizioUnknown in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_SERVIZIO_SCONOSCIUTO
    
    # idServizio value check: idServizio inactive [SEM_DPNR_11] - timestamp di arrivo della chiamata non compreso tra i timestamp presenti nei campi DATA_INIZIO_VALIDITA e DATA_FINE_VALIDITA del record trovato all'interno della tabella CDS_SOGGETTO_SERVIZIO
  Scenario: Check PPT_SERVIZIO_NONATTIVO error on inactive idServizio
    Given idServizio with inactive idServizio in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_SERVIZIO_NONATTIVO
    
    # idServizio value check: idServizio version 1 [SEM_DPNR_12]
  Scenario: Check PPT_VERSIONE_SERVIZIO error on idServizio with version 1
    Given idServizio with version 1 in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_VERSIONE_SERVIZIO
    
    # idDominio value check: idDominio not in PA table [SEM_DPNR_13] - l'idDominio ricavato dalla tabella CDS_SOGGETTO non è presente nella tabella PA
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent idDominio
    Given idServizio associated to a 'cds_soggetto' not present in PA table in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_DOMINIO_SCONOSCIUTO
    
    # idDominio value check: idDominio not enabled in PA table [SEM_DPNR_14] - l'idDominio ricavato dalla tabella CDS_SOGGETTO è presente nella tabella PA ed è disabilitato
  Scenario: Check PPT_DOMINIO_DISABILITATO error on not enabled idDominio
    Given idServizio associated to a 'cds_soggetto' present in PA table and not enabled in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_DOMINIO_DISABILITATO
    
    # idBrokerPA value check: idBrokerPA not enabled [SEM_DPNR_15] - l'idBrokerPA ricavato è disabilitato
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on not enabled idBrokerPA
    Given idServizio associated to a 'cds_soggetto' present in PA table, associated to an idBrokerPA not enabled in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO
    
    # idStation value check: idStation not enabled to 4 model [SEM_DPNR_16] - l'idStation ricavata non è abilitata al quarto modello
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on idStation not enabled to 4 model
    Given idServizio associated to a 'cds_soggetto' present in PA table, associated to an idStation not enabled to 4 model in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA
    
    # idStation value check: idStation not enabled [SEM_DPNR_17] - l'idStation ricavata è disabilitata
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on idStation not enabled
    Given idServizio associated to a 'cds_soggetto' present in PA table, associated to an idStation not enabled in demandPaymentNoticeReq
    When psp sends demandPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA
    
    
    
    