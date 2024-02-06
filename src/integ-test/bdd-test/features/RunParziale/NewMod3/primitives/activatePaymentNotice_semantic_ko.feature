Feature: Semantic checks KO for activatePaymentNoticeReq 1524

  Background:
    Given systems up
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
          <soapenv:Header/>
          <soapenv:Body>
              <nod:activatePaymentNoticeReq>
                  <idPSP>#psp#</idPSP>
                  <idBrokerPSP>#psp#</idBrokerPSP>
                  <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
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

  @ALL
  # idPSP value check: idPSP not in db [SEM_APNR_01]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given idPSP with pspUnknown in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PSP_SCONOSCIUTO of activatePaymentNotice response

  @ALL
  # idPSP value check: idPSP with field ENABLED = N [SEM_APNR_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PSP_DISABILITATO of activatePaymentNotice response

  @ALL
  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_APNR_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of activatePaymentNotice response

  @ALL
  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_APNR_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of activatePaymentNotice response

  @ALL
  # idChannel value check: idChannel not in db [SEM_APNR_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_CANALE_SCONOSCIUTO of activatePaymentNotice response

  @ALL
  # idChannel value check: idChannel with field ENABLED = N [SEM_APNR_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_CANALE_DISABILITATO of activatePaymentNotice response

  @ALL
  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_APNR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with #canale# in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNotice response
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of activatePaymentNotice response

  @ALL
  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_APNR_11]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 97735020584 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNotice response
    And check description is Configurazione intermediario-canale non corretta of activatePaymentNotice response

  @ALL
  # password value check: wrong password for an idChannel [SEM_APNR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given idChannel with #canale_ATTIVATO_PRESSO_PSP# in activatePaymentNotice
    And password with wrongPassword in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTENTICAZIONE of activatePaymentNotice response

  @ALL
  # fiscalCode value check: ID_DOMINIO not present in NODO4_CFG.PA table of nodo-dei-pagamenti db [SEM_APNR_09]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
    Given fiscalCode with 10000000000 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_DOMINIO_SCONOSCIUTO of activatePaymentNotice response

  @ALL
  # fiscalCode value check: ID_DOMINIO with field field ENABLED = N in NODO4_CFG.PA table of nodo-dei-pagamenti db [SEM_APNR_10]
  Scenario: Check PPT_DOMINIO_DISABILITATO error on disabled pa
    Given fiscalCode with 11111122223 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_DOMINIO_DISABILITATO of activatePaymentNotice response

  @ALL
  # station value check: combination fiscalCode-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_APNR_12]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    #Given fiscalCode with 77777777777 in activatePaymentNotice
    # And idempotencyKey with <iKey> in activatePaymentNotice
    Given noticeNumber with <value> in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of activatePaymentNotice response
    Examples:
      # | iKey                   | value              | soapUI test        |
      # | #psp#_5114567890 | 511456789012345678 | SEM_APNR_12 - aux5 |
      # | #canale_ATTIVATO_PRESSO_PSP#14567890 | 011456789012345678 | SEM_APNR_12 - aux0 |
      # | #psp#_3004567890 | 300456789012345678 | SEM_APNR_12 - aux3 |
      | value              | soapUI test        |
      | 511456789012345678 | SEM_APNR_12 - aux5 |
      | 011456789012345678 | SEM_APNR_12 - aux0 |
      | 301456789012345678 | SEM_APNR_12 - aux3 |

  @ALL
  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_APNR_13]
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
    #Given fiscalCode with 77777777777 in activatePaymentNotice
    Given noticeNumber with 316456789012345478 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of activatePaymentNotice response

  @ALL
  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field IP in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database not reachable (e.g. IP = 1.2.3.4) [SEM_APNR_14]
  Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
    #Given fiscalCode with 77777777777 in activatePaymentNotice
    Given noticeNumber with 099456789012345678 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of activatePaymentNotice response

  @ALL
  # pa broker value check: combination fiscalCode-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_APNR_15]
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
    #Given fiscalCode with 77777777777 in activatePaymentNotice
    Given noticeNumber with 010456789012345678 in activatePaymentNotice
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of activatePaymentNotice response

  @ALL
  # expirationTime > default_token_duration_validity_millis [SEM_APNR_25]
  Scenario: Check PPT_AUTORIZZAZIONE error if expirationTime > default_token_duration_validity_millis
    Given expirationTime with 900000 in activatePaymentNotice
    And nodo-dei-pagamenti has config parameter default_token_duration_validity_millis set to 7000
    # TODO And default_token_duration_validity_millis with 7000 in NODO4_CFG.CONFIGURATION_KEYS
    # TODO And nodo-dei-pagamenti must reload configuration
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_AUTORIZZAZIONE of activatePaymentNotice response
    And check description is expirationTime deve essere <= 7000 of activatePaymentNotice response
    And restore initial configurations
