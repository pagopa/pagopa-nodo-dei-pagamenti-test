Feature: Semantic checks for activateIOPaymentReq - KO

  Background:
    Given systems up
    And initial XML activateIOPaymentReq
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
        <soapenv:Header/>
        <soapenv:Body>
          <nod:activateIOPaymentReq>
            <idPSP>70000000001</idPSP>
            <idBrokerPSP>70000000001</idBrokerPSP>
            <idChannel>70000000001_01</idChannel>
            <password>pwdpwdpwd</password>
            <!--Optional:-->
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
              <fiscalCode>#creditor_institution_code#</fiscalCode>
              <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
            <!--Optional:-->
            <expirationTime>12345</expirationTime>
            <amount>10.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>test</paymentNote>
            <!--Optional:-->
            <payer>
              <uniqueIdentifier>
                <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
              </uniqueIdentifier>
              <fullName>name</fullName>
              <!--Optional:-->
              <streetName>street</streetName>
              <!--Optional:-->
              <civicNumber>civic</civicNumber>
              <!--Optional:-->
              <postalCode>code</postalCode>
              <!--Optional:-->
              <city>city</city>
              <!--Optional:-->
              <stateProvinceRegion>state</stateProvinceRegion>
              <!--Optional:-->
              <country>IT</country>
              <!--Optional:-->
              <e-mail>test.prova@gmail.com</e-mail>
            </payer>
          </nod:activateIOPaymentReq>
        </soapenv:Body>
      </soapenv:Envelope>
      """


  # idPSP value check: idPSP not in db [SEM_AIPR_01]
  Scenario: Check PPT_PSP_SCONOSCIUTO error on non-existent psp
    Given idPSP with pspUnknown in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_PSP_SCONOSCIUTO of activateIOPaymentReq response


  # idPsp value check: idPSP with field ENABLED = N  [SEM_AIPR_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_PSP_DISABILITATO of activateIOPaymentReq response

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_AIPR_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of activateIOPaymentReq response

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_AIPR_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of activateIOPaymentReq response


  # idChannel value check: idChannel not in db [SEM_AIPR_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_CANALE_SCONOSCIUTO of activateIOPaymentReq response

  # idChannel value check: idChannel with field ENABLED = N [SEM_AIPR_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_CANALE_DISABILITATO of activateIOPaymentReq response


  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_AIPR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with 70000000001_03_ONUS in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPaymentReq response
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of activateIOPaymentReq response


  # password value check: wrong password for an idChannel [SEM_AIPR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given password with wrongPassword in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_AUTENTICAZIONE of activateIOPaymentReq response

  # fiscalCode value check: fiscalCode not present inside column ID_DOMINIO in NODO4_CFG.PA table of nodo-dei-pagamenti database [SEM_AIPR_09]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
    Given fiscalCode with 10000000000 in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_DOMINIO_SCONOSCIUTO of activateIOPaymentReq response

  # fiscalCode value check: fiscalCode with field ENABLED = N in NODO4_CFG.PA table of nodo-dei-pagamenti database corresponding to ID_DOMINIO [SEM_AIPR_10]
  Scenario: Check PPT_DOMINIO_DISABILITATO error on disabled pa
    Given fiscalCode with 11111122222 in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_DOMINIO_DISABILITATO of activateIOPaymentReq response


  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_AIPR_11]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 97735020584 in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPaymentReq response
    And check description is Configurazione intermediario-canale non corretta of activateIOPaymentReq response


  # station value check: combination fiscalCode-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_AIPR_12]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given noticeNumber with <value> in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of activateIOPaymentReq response
    Examples:
      | value              | soapUI test                                            |
      | 511456789012345678 | SEM_AIPR_12 - auxDigit inesistente                     |
      | 011456789012345678 | SEM_AIPR_12 - auxDigit 0 - progressivo inesistente     |
      | 316456789012345678 | SEM_AIPR_12 - auxDigit 3 - segregationCode inesistente |



  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_AIPR_13]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
    Given noticeNumber with <value> in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of activateIOPaymentReq response
    Examples:
      | value              | soapUI test |
      | 312134567890787583 | SEM_AIPR_13 |
      | 314134567890787583 | SEM_AIPR_13 |


  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field IP in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database not reachable (e.g. IP = 1.2.3.4) [SEM_AIRP_14]
  Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
    Given noticeNumber with 099456789012345678 in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of activateIOPaymentReq response


  # station value check: combination fiscalCode-noticeNumber identifies a old version station [SEM_AIRP_15]
  Scenario: Check PPT_MULTIBENEFICIARIO error on old version station
    Given noticeNumber with 323456789012345678 in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_MULTI_BENEFICIARIO of activateIOPaymentReq response


  # pa broker value check: combination fiscalCode-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_AIRP_16]
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
    Given noticeNumber with 088456789012345678 in activateIOPaymentReq
    When psp sends SOAP activateIOPaymentReq to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPaymentReq response
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of activateIOPaymentReq response


