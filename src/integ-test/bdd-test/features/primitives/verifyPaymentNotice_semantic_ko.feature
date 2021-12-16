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

  # idChannel value check: idChannel with field MODELLO_PAGAMENTO = ATTIVATO_PRESSO_PSP (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_VPNR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with 40000000001_03 in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTORIZZAZIONE
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP'

  # password value check: wrong password for an idChannel [SEM_VPNR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given idChannel with 70000000001_01 in verifyPaymentNoticeReq
    Given password with wrongPassword in verifyPaymentNoticeReq
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_AUTENTICAZIONE

#
#  # fiscalCode value check
#  Scenario Outline: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
#    Given <elem> with <value> in verifyPaymentNoticeReq
#    And <value> not present inside column ID_DOMINIO in NODO4_CFG.PA table of nodo-dei-pagamenti database
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_DOMINIO_SCONOSCIUTO
#    Examples:
#      | elem       | value       | soapUI test |
#      | fiscalCode | 10000000000 | SEM_VPNR_09 |
#
#
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
#
#
#  # station value check
#  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
#    Given <elem_1> with <value_1> and <elem_2> with <value_2> in verifyPaymentNoticeReq
#    And combination <value_1>-<value_2> identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA
#    Examples:
#      | elem_1     | value_1     | elem_2       | value_2            | soapUI test                                            |
#      | fiscalCode | 77777777777 | noticeNumber | 511456789012345678 | SEM_VPNR_11 - auxDigit inesistente                     |
#      | fiscalCode | 77777777777 | noticeNumber | 011456789012345678 | SEM_VPNR_11 - auxDigit 0 - progressivo inesistente     |
#      | fiscalCode | 77777777777 | noticeNumber | 316456789012345678 | SEM_VPNR_11 - auxDigit 3 - segregationCode inesistente |
#
#
#  # idBrokerPSP-idPSP value check
#  Scenario Outline: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
#    Given <elem> with <value> in verifyPaymentNoticeReq
#    And <value> not associated to idPSP in verifyPaymentNoticeReq
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_AUTORIZZAZIONE
#    And check description is Configurazione intermediario-canale non corretta
#    Examples:
#      | elem        | value       | soapUI test |
#      | idBrokerPSP | 97735020584 | SEM_VPNR_12 |
#
#
#  # station value check
#  Scenario Outline: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
#    Given <elem_1> with <value_1> and <elem_2> with <value_2> in verifyPaymentNoticeReq
#    And combination <value_1>-<value_2> identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA
#    Examples:
#      | elem_1     | value_1     | elem_2       | value_2            | soapUI test |
#      | fiscalCode | 77777777777 | noticeNumber | 006456789012345478 | SEM_VPNR_13 |
#
#
#  # station value check
#  Scenario Outline: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
#    Given <elem_1> with <value_1> and <elem_2> with <value_2> in verifyPaymentNoticeReq
#    And combination <value_1>-<value_2> identifies a station corresponding to an ID_STAZIONE value with field IP in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database not reachable (e.g. IP = 1.2.3.4)
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE
#    Examples:
#      | elem_1     | value_1     | elem_2       | value_2            | soapUI test |
#      | fiscalCode | 77777777777 | noticeNumber | 099456789012345678 | SEM_VPNR_14 |
#
#
#  # pa broker value check
#  Scenario Outline: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
#    Given <elem_1> with <value_1> and <elem_2> with <value_2> in verifyPaymentNoticeReq
#    And combination <value_1>-<value_2> identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is KO
#    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO
#    Examples:
#      | elem_1     | value_1     | elem_2       | value_2            | soapUI test |
#      | fiscalCode | 77777777777 | noticeNumber | 088456789012345678 | SEM_VPNR_15 |
#
#
#  # denylist value check
#  Scenario Outline: Check outcome OK if combination psp-channel-pa in denylist
#    Given <elem_1> with <value_1> and <elem_2> with <value_2> in verifyPaymentNoticeReq
#    And combination <value_1>-<value_2>-idPSP in verifyPaymentNoticeReq identifies a record in NODO4_CFG.DENYLIST table of nodo-dei-pagamenti database
#    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
#    Then check outcome is OK
#    Examples:
#      | elem_1     | value_1     | elem_2    | value_2        | soapUI test |
#      | fiscalCode | 77777777777 | idChannel | 70000000002_01 | SEM_VPNR_16 |
