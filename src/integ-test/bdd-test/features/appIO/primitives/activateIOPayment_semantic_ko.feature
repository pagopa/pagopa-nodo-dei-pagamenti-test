Feature: Semantic checks for activateIOPayment - KO

  Background:
    Given systems up
    And initial XML activateIOPayment
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
            <expirationTime>20000</expirationTime>
            <amount>10.00</amount>
            <!--Optional:-->
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <paymentNote>responseFull</paymentNote>
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
    Given idPSP with pspUnknown in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PSP_SCONOSCIUTO of activateIOPayment response


  # idPsp value check: idPSP with field ENABLED = N  [SEM_AIPR_02]
  Scenario: Check PPT_PSP_DISABILITATO error on disabled psp
    Given idPSP with NOT_ENABLED in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PSP_DISABILITATO of activateIOPayment response

  # idBrokerPSP value check: idBrokerPSP not present in db [SEM_AIPR_03]
  Scenario: Check PPT_INTERMEDIARIO_PSP_SCONOSCIUTO error on non-existent psp broker
    Given idBrokerPSP with brokerPspUnknown in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of activateIOPayment response

  # idBrokerPSP value check: idBrokerPSP with field ENABLED = N [SEM_AIPR_04]
  Scenario: Check PPT_INTERMEDIARIO_PSP_DISABILITATO error on disabled psp broker
    Given idBrokerPSP with INT_NOT_ENABLED in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of activateIOPayment response


  # idChannel value check: idChannel not in db [SEM_AIPR_05]
  Scenario: Check PPT_CANALE_SCONOSCIUTO error on non-existent psp channel
    Given idChannel with channelUnknown in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_CANALE_SCONOSCIUTO of activateIOPayment response

  # idChannel value check: idChannel with field ENABLED = N [SEM_AIPR_06]
  Scenario: Check PPT_CANALE_DISABILITATO error on disabled psp channel
    Given idChannel with CANALE_NOT_ENABLED in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_CANALE_DISABILITATO of activateIOPayment response


  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_AIPR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given idChannel with 70000000001_03_ONUS in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPayment response
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of activateIOPayment response


  # password value check: wrong password for an idChannel [SEM_AIPR_08]
  Scenario: Check PPT_AUTENTICAZIONE error on password not associated to psp channel
    Given password with wrongPassword in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_AUTENTICAZIONE of activateIOPayment response

  # fiscalCode value check: fiscalCode not present inside column ID_DOMINIO in NODO4_CFG.PA table of nodo-dei-pagamenti database [SEM_AIPR_09]
  Scenario: Check PPT_DOMINIO_SCONOSCIUTO error on non-existent pa
    Given fiscalCode with 10000000000 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_DOMINIO_SCONOSCIUTO of activateIOPayment response

  # fiscalCode value check: fiscalCode with field ENABLED = N in NODO4_CFG.PA table of nodo-dei-pagamenti database corresponding to ID_DOMINIO [SEM_AIPR_10]
  Scenario: Check PPT_DOMINIO_DISABILITATO error on disabled pa
    Given fiscalCode with 11111122222 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_DOMINIO_DISABILITATO of activateIOPayment response


  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_AIPR_11]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given idBrokerPSP with 97735020584 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPayment response
    And check description is Configurazione intermediario-canale non corretta of activateIOPayment response


  # station value check: combination fiscalCode-noticeNumber identifies a station not present inside column ID_STAZIONE in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_AIPR_12]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given noticeNumber with <value> in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of activateIOPayment response
    Examples:
      | value              | soapUI test                                            |
      | 511456789012345678 | SEM_AIPR_12 - auxDigit inesistente                     |
      | 011456789012345678 | SEM_AIPR_12 - auxDigit 0 - progressivo inesistente     |
      | 316456789012345678 | SEM_AIPR_12 - auxDigit 3 - segregationCode inesistente |



  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_AIPR_13]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
    Given noticeNumber with <value> in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of activateIOPayment response
    Examples:
      | value              | soapUI test |
      | 312134567890787583 | SEM_AIPR_13 |
      | 314134567890787583 | SEM_AIPR_13 |


  # station value check: combination fiscalCode-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field IP in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database not reachable (e.g. IP = 1.2.3.4) [SEM_AIRP_14]
  Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station
    Given noticeNumber with 099456789012345678 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of activateIOPayment response


  # station value check: combination fiscalCode-noticeNumber identifies a old version station [SEM_AIRP_15]
  Scenario: Check PPT_MULTIBENEFICIARIO error on old version station
    Given noticeNumber with 323456789012345678 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_MULTI_BENEFICIARIO of activateIOPayment response


  # pa broker value check: combination fiscalCode-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_AIRP_16]
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
    Given noticeNumber with 088456789012345678 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of activateIOPayment response
  
  
  #TROVARE UN MODO PER FAR COINCIDERE LE RICHIESTE NEL CASO OK E KO
  Scenario: Execute activateIOPayment (Phase 1)
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  Scenario Outline: Check PPT_ERRORE_IDEMPOTENZA error on validity idempotencyKey (Phase 2)
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    And <tag> with <tag_value> in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activateIOPayment response
    Examples:
      | tag                         | tag_value             | soapUI test |
      | fiscalCode                  | 90000000001           | SEM_AIPR_21 |
      | amount                      | 12.00                 | SEM_AIPR_21 |
      | dueDate                     | 2021-12-31            | SEM_AIPR_21 |
      | dueDate                     | None                  | SEM_AIPR_21 |
      | paymentNote                 | test_1                | SEM_AIPR_21 |
      | paymentNote                 | Empty                 | SEM_AIPR_21 |
      | paymentNote                 | None                  | SEM_AIPR_21 |
      | expirationTime              | 123456                | SEM_AIPR_21 |
      | expirationTime              | Empty                 | SEM_AIPR_21 |
      | expirationTime              | None                  | SEM_AIPR_21 |
      | payer                       | None                  | SEM_AIPR_21 |
      | entityUniqueIdentifierType  | F                     | SEM_AIPR_21 |
      | entityUniqueIdentifierValue | 55555555555           | SEM_AIPR_21 |
      | fullName                    | name_1                | SEM_AIPR_21 |
      | streetName                  | streetName            | SEM_AIPR_21 |
      | streetName                  | Empty                 | SEM_AIPR_21 |
      | streetName                  | None                  | SEM_AIPR_21 |
      | civicNumber                 | civicNumber           | SEM_AIPR_21 |
      | civicNumber                 | Empty                 | SEM_AIPR_21 |
      | civicNumber                 | None                  | SEM_AIPR_21 |
      | postalCode                  | postalCode            | SEM_AIPR_21 |
      | postalCode                  | Empty                 | SEM_AIPR_21 |
      | postalCode                  | None                  | SEM_AIPR_21 |
      | city                        | new_city              | SEM_AIPR_21 |
      | city                        | Empty                 | SEM_AIPR_21 |
      | city                        | None                  | SEM_AIPR_21 |
      | stateProvinceRegion         | stateProvinceRegion   | SEM_AIPR_21 |
      | stateProvinceRegion         | Empty                 | SEM_AIPR_21 |
      | stateProvinceRegion         | None                  | SEM_AIPR_21 |
      | country                     | FR                    | SEM_AIPR_21 |
      | country                     | Empty                 | SEM_AIPR_21 |
      | country                     | None                  | SEM_AIPR_21 |
      | e-mail                      | test1@prova.gmail.com | SEM_AIPR_21 |
      | e-mail                      | Empty                 | SEM_AIPR_21 |
      | e-mail                      | None                  | SEM_AIPR_21 |

  # SEM_AIPR_23
  Scenario: Check reuse of idempotencyKey with expired paymentToken
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And PSP waits expirationTime of activateIOPayment expires
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  # SEM_AIPR_27
  Scenario: Check reuse of idempotencyKey with expired idempotencyKey validity
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And PSP waits 3.0 minutes for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  # SEM_AIPR_29
  Scenario: Check PPT_PAGAMENTO_IN_CORSO error with PAYING debtor position
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And random idempotencyKey having $activateIOPayment.idPSP as idPSP in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  # SEM_AIPR_30
  Scenario: Check PPT_PAGAMENTO_IN_CORSO error with PAYING debtor position and without idempotencyKey
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And idempotencyKey with None in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
