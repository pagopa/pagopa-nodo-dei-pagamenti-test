Feature: semantic checks KO for activatePaymentNoticeReq

  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
          <soapenv:Header/>
          <soapenv:Body>
              <nod:activatePaymentNoticeReq>
                  <idPSP>70000000001</idPSP>
                  <idBrokerPSP>70000000001</idBrokerPSP>
                  <idChannel>70000000001_01</idChannel>
                  <password>pwdpwdpwd</password>
                  <idempotencyKey>#idempotency_key#</idempotencyKey>
                  <qrCode>
                      <fiscalCode>#creditor_institution_code#</fiscalCode>
                      <noticeNumber>#notice_number#</noticeNumber>
                  </qrCode>
                  <expirationTime>120000</expirationTime>
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """

  # idPSP value check: idPSP not in db [SEM_APNR_01]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given idPSP with pspUnknown in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PSP_SCONOSCIUTO of activatePaymentNotice response

  # idPSP value check: idPSP with field ENABLED = N [SEM_APNR_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PSP_DISABILITATO of activatePaymentNotice response

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_APNR_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of activatePaymentNotice response

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_APNR_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of activatePaymentNotice response

  # idChannel value check: idChannel not in db [SEM_APNR_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_CANALE_SCONOSCIUTO of activatePaymentNotice response

  # idChannel value check: idChannel with field ENABLED = N [SEM_APNR_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_CANALE_DISABILITATO of activatePaymentNotice response

  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_APNR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with 70000000001_03_ONUS in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNotice response
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of activatePaymentNotice response

  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_APNR_11]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 97735020584 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNotice response
    And check description is Configurazione intermediario-canale non corretta of activatePaymentNotice response

  # password value check: wrong password for an idChannel [SEM_APNR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given idChannel with 70000000001_01 in activatePaymentNotice
    And password with wrongPassword in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNotice response

  # fiscalCode value check: ID_DOMINIO not present in NODO4_CFG.PA table of nodo-dei-pagamenti db [SEM_APNR_09]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
    Given fiscalCode with 10000000000 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_DOMINIO_SCONOSCIUTO of activatePaymentNotice response

  # fiscalCode value check: ID_DOMINIO with field field ENABLED = N in NODO4_CFG.PA table of nodo-dei-pagamenti db [SEM_APNR_10]
  Scenario: Check PPT_DOMINIO_DISABILITATO error on disabled pa
    Given fiscalCode with 11111122222 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_DOMINIO_DISABILITATO of activatePaymentNotice response

  # station value check: combination fiscalCode-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_APNR_12]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given fiscalCode with 77777777777 in activatePaymentNotice
    # And idempotencyKey with <iKey> in activatePaymentNotice
    And noticeNumber with <value> in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of activatePaymentNotice response
    Examples:
      # | iKey                   | value              | soapUI test        |
      # | 70000000001_5114567890 | 511456789012345678 | SEM_APNR_12 - aux5 |
      # | 70000000001_0114567890 | 011456789012345678 | SEM_APNR_12 - aux0 |
      # | 70000000001_3004567890 | 300456789012345678 | SEM_APNR_12 - aux3 |
      | value              | soapUI test        |
      | 511456789012345678 | SEM_APNR_12 - aux5 |
      | 011456789012345678 | SEM_APNR_12 - aux0 |
      | 300456789012345678 | SEM_APNR_12 - aux3 |

  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_APNR_13]
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
    Given fiscalCode with 77777777777 in activatePaymentNotice
    And noticeNumber with 006456789012345478 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of activatePaymentNotice response

  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field IP in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database not reachable (e.g. IP = 1.2.3.4) [SEM_APNR_14]
  Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
    Given fiscalCode with 77777777777 in activatePaymentNotice
    And noticeNumber with 099456789012345678 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of activatePaymentNotice response

  # pa broker value check: combination fiscalCode-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_APNR_15]
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
    Given fiscalCode with 77777777777 in activatePaymentNotice
    And noticeNumber with 088456789012345678 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of activatePaymentNotice response

  # expirationTime > default_token_duration_validity_millis [SEM_APNR_25]
  Scenario: Check PPT_AUTORIZZAZIONE error if expirationTime > default_token_duration_validity_millis
    Given expirationTime with 10000 in activatePaymentNotice
    #	 TODO And default_token_duration_validity_millis with 7000 in NODO4_CFG.CONFIGURATION_KEYS
    #  TODO And nodo-dei-pagamenti must reload configuration
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNotice response
    And check description is expirationTime deve essere <= 7000 of activatePaymentNotice response
