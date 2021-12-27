Feature: semantic checks for verificaBollettinoReq

  Background:
    Given systems up
    And initial verificaBollettinoReq soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <nod:verificaBollettinoReq>
                 <idPSP>POSTE3</idPSP>
                 <idBrokerPSP>BANCOPOSTA</idBrokerPSP>
                 <idChannel>POSTE3</idChannel>
                 <password>pwdpwdpwd</password>
                 <ccPost>#codicePA#</ccPost>
                 <noticeNumber>#notice_number#</noticeNumber>
              </nod:verificaBollettinoReq>
           </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

  # idPSP value check: idPSP not in db [SEM_VB_01]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given idPSP with pspUnknown in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_SCONOSCIUTO

  # idPSP value check: idPSP with field ENABLED = N [SEM_VB_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_DISABILITATO

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_VB_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_VB_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO

  # idChannel value check: idChannel not in db [SEM_VB_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_SCONOSCIUTO

  # idChannel value check: idChannel with field ENABLED = N [SEM_VB_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_DISABILITATO

  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_VB_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with POSTE1_ONUS in verificaBollettinoReq
    And idPSP with POSTE1 in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTORIZZAZIONE
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP'

    # password value check: wrong password for an idChannel [SEM_VB_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given idChannel with POSTE3 in verificaBollettinoReq
    Given password with password in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTENTICAZIONE

    # ccPost value check: ccPost = codicePA not present in NODO4_CFG.CODIFICHE_PA table of nodo-dei-pagamenti db [SEM_VB_09]
   Scenario: Check PPT_SEMANTICA error on non-existent ccPost
    Given ccPost with 777777777772 in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_SEMANTICA
    And check description is Codifica non riconosciuta

  # station value check: noticeNumber with unknonw progressivo [SEM_VB_11]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given ccPost with 777777777777 in verificaBollettinoReq
    And noticeNumber with 713014851147176400 in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA

  # idBrokerPSP- idPSP value check: idBrokerPSP not associated to idPSP [SEM_VB_12]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 91000000001 in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTORIZZAZIONE
    And check description is Configurazione intermediario-canale non corretta

  # station value check: combination ccPost-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_VB_14]
  Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given ccPost with 777777777777 in verificaBollettinoReq
    And noticeNumber with 313019441991132400 in verificaBollettinoReq
    When PSP sends verificaBollettinoReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA
