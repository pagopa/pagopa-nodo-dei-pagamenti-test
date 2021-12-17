Feature:  semantic checks for verifyPaymentReq

  Background:
    Given systems up
    And valid verifyPaymentNoticeReq soap-request
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
    Given idPSP with pspUnknown in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_SCONOSCIUTO

  # idPSP value check: idPSP with field ENABLED = N [SEM_VPNR_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_PSP_DISABILITATO

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_VPNR_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_VPNR_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO

  # idChannel value check: idChannel not in db [SEM_VPNR_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_SCONOSCIUTO

  # idChannel value check: idChannel with field ENABLED = N [SEM_VPNR_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_CANALE_DISABILITATO

  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_VPNR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with 70000000001_03_ONUS in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTORIZZAZIONE
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP'

  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_VPNR_12]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 97735020584 in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTORIZZAZIONE
    And check description is Configurazione intermediario-canale non corretta

  # password value check: wrong password for an idChannel [SEM_VPNR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given idChannel with 70000000001_01 in verifyPaymentNoticeReq
    Given password with wrongPassword in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTENTICAZIONE

  # TODO review
#  # fiscalCode value check: ID_DOMINIO not present in NODO4_CFG.PA table of nodo-dei-pagamenti db [SEM_VPNR_09]
#  Scenario Outline: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
#    Given fiscalCode with 10000000000 in verifyPaymentNoticeReq
#    And <value> not present inside column ID_DOMINIO in NODO4_CFG.PA table of nodo-dei-pagamenti database
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_DOMINIO_SCONOSCIUTO
#    Examples:
#      | elem       | value       | soapUI test |
#      | fiscalCode | 10000000000 | SEM_VPNR_09 |

  # TODO review
#  # fiscalCode value check
#  Scenario Outline: Check PPT_DOMINIO_DISABILITATO error on disabled pa
#    Given <elem> with <value> in verifyPaymentNoticeReq
#    And set field ENABLED = N in NODO4_CFG.PA table of nodo-dei-pagamenti database corresponding to ID_DOMINIO = <value>
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_DOMINIO_DISABILITATO
#    Examples:
#      | elem       | value        | soapUI test |
#      | fiscalCode | 111111111111 | SEM_VPNR_10 |


  # station value check: combination fiscalCode-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_VPNR_11]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given fiscalCode with 77777777777 in verifyPaymentNoticeReq
    And noticeNumber with <value> in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA
    Examples:
      | value              | soapUI test                                            |
      | 511456789012345678 | SEM_VPNR_11 - auxDigit inesistente                     |
      | 011456789012345678 | SEM_VPNR_11 - auxDigit 0 - progressivo inesistente     |
      | 316456789012345678 | SEM_VPNR_11 - auxDigit 3 - segregationCode inesistente |

  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_VPNR_13]
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
    Given fiscalCode with 77777777777 in verifyPaymentNoticeReq
    And noticeNumber with 006456789012345478 in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA

  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field IP in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database not reachable (e.g. IP = 1.2.3.4) [SEM_VPNR_14]
  Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
    Given fiscalCode with 77777777777 in verifyPaymentNoticeReq
    And noticeNumber with 099456789012345678 in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE

  # pa broker value check: combination fiscalCode-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_VPNR_15]
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
    Given fiscalCode with 77777777777 in verifyPaymentNoticeReq
    And noticeNumber with 088456789012345678 in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO
