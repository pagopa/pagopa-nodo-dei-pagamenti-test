Feature:  semantic checks for verifyPaymentReq

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>302094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """

  # idPSP value check: idPSP not in db [SEM_VPNR_01]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given idPSP with pspUnknown in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_PSP_SCONOSCIUTO of verifyPaymentNotice response

  # idPSP value check: idPSP with field ENABLED = N [SEM_VPNR_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_PSP_DISABILITATO of verifyPaymentNotice response

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_VPNR_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of verifyPaymentNotice response

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_VPNR_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of verifyPaymentNotice response

  # idChannel value check: idChannel not in db [SEM_VPNR_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_CANALE_SCONOSCIUTO of verifyPaymentNotice response

  # idChannel value check: idChannel with field ENABLED = N [SEM_VPNR_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_CANALE_DISABILITATO of verifyPaymentNotice response

  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_VPNR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with 70000000001_03_ONUS in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of verifyPaymentNotice response
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of verifyPaymentNotice response

  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_VPNR_12]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 97735020584 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of verifyPaymentNotice response
    And check description is Configurazione intermediario-canale non corretta of verifyPaymentNotice response

  # password value check: wrong password for an idChannel [SEM_VPNR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given idChannel with 70000000001_01 in verifyPaymentNotice
    Given password with wrongPassword in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_AUTENTICAZIONE of verifyPaymentNotice response

  # fiscalCode value check: fiscalCode not present inside column ID_DOMINIO in NODO4_CFG.PA table of nodo-dei-pagamenti database [SEM_VPNR_09]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
    Given fiscalCode with 10000000000 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_DOMINIO_SCONOSCIUTO of verifyPaymentNotice response

  # fiscalCode value check: fiscalCode with field ENABLED = N in NODO4_CFG.PA table of nodo-dei-pagamenti database corresponding to ID_DOMINIO [SEM_VPNR_10]
  Scenario: Check PPT_DOMINIO_DISABILITATO error on disabled pa
    Given fiscalCode with 11111122222 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_DOMINIO_DISABILITATO of verifyPaymentNotice response

  # station value check: combination fiscalCode-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_VPNR_11]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given fiscalCode with 77777777777 in verifyPaymentNotice
    And noticeNumber with <value> in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of verifyPaymentNotice response
    Examples:
      | value              | soapUI test                                            |
      | 511456789012345678 | SEM_VPNR_11 - auxDigit inesistente                     |
      | 011456789012345678 | SEM_VPNR_11 - auxDigit 0 - progressivo inesistente     |
      | 316456789012345678 | SEM_VPNR_11 - auxDigit 3 - segregationCode inesistente |

  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_VPNR_13]
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
    Given fiscalCode with 77777777777 in verifyPaymentNotice
    And noticeNumber with 006456789012345478 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of verifyPaymentNotice response

  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field IP in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database not reachable (e.g. IP = 1.2.3.4) [SEM_VPNR_14]
  Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
    Given fiscalCode with 77777777777 in verifyPaymentNotice
    And noticeNumber with 099456789012345678 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of verifyPaymentNotice response

  # pa broker value check: combination fiscalCode-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_VPNR_15]
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
    Given fiscalCode with 77777777777 in verifyPaymentNotice
    And noticeNumber with 088456789012345678 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of verifyPaymentNotice response
