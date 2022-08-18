Feature: Semantic checks for activateIOPayment - KO

  Background:
    Given systems up

  Scenario Outline: Check errors on activateIOPayment
    Given initial XML activateIOPayment
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
    And <tag> with <tag_value> in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is <error> of activateIOPayment response
    Examples:
      | tag          | tag_value          | error                               | soapUI test                                            |
      | idPSP        | pspUnknown         | PPT_PSP_SCONOSCIUTO                 | SEM_AIPR_01                                            |
      | idPSP        | NOT_ENABLED        | PPT_PSP_DISABILITATO                | SEM_AIPR_02                                            |
      | idBrokerPSP  | brokerPspUnknown   | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO   | SEM_AIPR_03                                            |
      | idBrokerPSP  | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO  | SEM_AIPR_04                                            |
      | idChannel    | channelUnknown     | PPT_CANALE_SCONOSCIUTO              | SEM_AIPR_05                                            |
      | idChannel    | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO             | SEM_AIPR_06                                            |
      | password     | wrongPassword      | PPT_AUTENTICAZIONE                  | SEM_AIPR_08                                            |
      | fiscalCode   | 10000000000        | PPT_DOMINIO_SCONOSCIUTO             | SEM_AIPR_09                                            |
      | fiscalCode   | 11111122222        | PPT_DOMINIO_DISABILITATO            | SEM_AIPR_10                                            |
      | noticeNumber | 511456789012345678 | PPT_STAZIONE_INT_PA_SCONOSCIUTA     | SEM_AIPR_12 - auxDigit inesistente                     |
      | noticeNumber | 011456789012345678 | PPT_STAZIONE_INT_PA_SCONOSCIUTA     | SEM_AIPR_12 - auxDigit 0 - progressivo inesistente     |
      | noticeNumber | 316456789012345678 | PPT_STAZIONE_INT_PA_SCONOSCIUTA     | SEM_AIPR_12 - auxDigit 3 - segregationCode inesistente |
      | noticeNumber | 323134567890787583 | PPT_STAZIONE_INT_PA_DISABILITATA    | SEM_AIPR_13                                            |
      | noticeNumber | 314134567890787583 | PPT_STAZIONE_INT_PA_DISABILITATA    | SEM_AIPR_13                                            |
      | noticeNumber | 099456789012345678 | PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE | SEM_AIRP_14                                            |
      | noticeNumber | 312456789012345678 | PPT_MULTI_BENEFICIARIO              | SEM_AIPR_15                                            |
      | noticeNumber | 088456789012345678 | PPT_INTERMEDIARIO_PA_DISABILITATO   | SEM_AIPR_16                                            |

  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_AIPR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given initial XML activateIOPayment
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
    Given idChannel with 70000000001_03_ONUS in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPayment response
    And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of activateIOPayment response

  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_AIPR_11]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given initial XML activateIOPayment
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
    And idBrokerPSP with 97735020584 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPayment response
    And check description is Configurazione intermediario-canale non corretta of activateIOPayment response

  # [SEM_AIPR_20]
  Scenario: Execute activateIOPayment (Phase 1) - useIdempotency = false
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
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
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  Scenario: Check second activateIOPayment is equal to the first
    Given the Execute activateIOPayment (Phase 1) - useIdempotency = false scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  # [SEM_AIPR_21]
  Scenario: Execute activateIOPayment (Phase 1.1)
    Given initial XML activateIOPayment
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
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response

  Scenario Outline: Check PPT_ERRORE_IDEMPOTENZA error on idempotencyKey validity (Phase 2)
    Given the Execute activateIOPayment (Phase 1.1) scenario executed successfully
    And <tag> with <tag_value> in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activateIOPayment response
    Examples:
      | tag                         | tag_value             | soapUI test |
      | noticeNumber                | 302119138889055636    | SEM_AIPR_21 |
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

  # [SEM_AIPR_22]
  Scenario Outline: Check OK on idempotencyKey validity
    Given the Execute activateIOPayment (Phase 1) - useIdempotency = false scenario executed successfully
    And <tag> with <value> in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And restore initial configurations
    Examples:
      | tag          | value              | soapUI test |
      | noticeNumber | 302119138889055636 | SEM_AIPR_22 |
      | fiscalCode   | 90000000001        | SEM_AIPR_22 |

  Scenario Outline: Check PPT_PAGAMENTO_IN_CORSO error on idempotencyKey validity
    Given the Execute activateIOPayment (Phase 1) - useIdempotency = false scenario executed successfully
    And <tag> with <value> in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And restore initial configurations
    Examples:
      | tag                         | value                 | soapUI test |
      | amount                      | 12.00                 | SEM_AIPR_22 |
      | dueDate                     | 2021-12-31            | SEM_AIPR_22 |
      | dueDate                     | None                  | SEM_AIPR_22 |
      | paymentNote                 | test_1                | SEM_AIPR_22 |
      | paymentNote                 | None                  | SEM_AIPR_22 |
      | expirationTime              | 123456                | SEM_AIPR_22 |
      | expirationTime              | None                  | SEM_AIPR_22 |
      | payer                       | None                  | SEM_AIPR_22 |
      | entityUniqueIdentifierType  | F                     | SEM_AIPR_22 |
      | entityUniqueIdentifierValue | 55555555555           | SEM_AIPR_22 |
      | fullName                    | name_1                | SEM_AIPR_22 |
      | streetName                  | streetName            | SEM_AIPR_22 |
      | streetName                  | None                  | SEM_AIPR_22 |
      | civicNumber                 | civicNumber           | SEM_AIPR_22 |
      | civicNumber                 | None                  | SEM_AIPR_22 |
      | postalCode                  | postalCode            | SEM_AIPR_22 |
      | postalCode                  | None                  | SEM_AIPR_22 |
      | city                        | new_city              | SEM_AIPR_22 |
      | city                        | None                  | SEM_AIPR_22 |
      | stateProvinceRegion         | stateProvinceRegion   | SEM_AIPR_22 |
      | stateProvinceRegion         | None                  | SEM_AIPR_22 |
      | country                     | FR                    | SEM_AIPR_22 |
      | country                     | None                  | SEM_AIPR_22 |
      | e-mail                      | test1@prova.gmail.com | SEM_AIPR_22 |
      | e-mail                      | None                  | SEM_AIPR_22 |

  # [SEM_AIPR_23]
  Scenario: Check reuse of idempotencyKey with expired paymentToken
    Given the Execute activateIOPayment (Phase 1.1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And PSP waits expirationTime of activateIOPayment expires
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  # [SEM_AIPR_24]
  Scenario: [SEM_AIPR_24]
    Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 15000
    And the Execute activateIOPayment (Phase 1.1) scenario executed successfully
    #And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And wait 20 seconds for expiration
    And expirationTime with 12345 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And restore initial configurations

  # [SEM_AIPR_25]
  Scenario: [SEM_AIPR_25]
    Given the Execute activateIOPayment (Phase 1) - useIdempotency = false scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And wait 20 seconds for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  # [SEM_AIPR_26]
  Scenario: [SEM_AIPR_26]
    Given the Execute activateIOPayment (Phase 1) - useIdempotency = false scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And wait 20 seconds for expiration
    And expirationTime with 12345 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  # [SEM_AIPR_27]
  Scenario: Check reuse of idempotencyKey with expired idempotencyKey validity
    Given the Execute activateIOPayment (Phase 1.1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And PSP waits 3 minutes for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  # [SEM_AIPR_28]
  Scenario: [SEM_AIPR_28]
    Given the Execute activateIOPayment (Phase 1) - useIdempotency = false scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And PSP waits 3 minutes for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  # [SEM_AIPR_29]
  Scenario: Check PPT_PAGAMENTO_IN_CORSO error with PAYING debtor position
    Given the Execute activateIOPayment (Phase 1.1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And random idempotencyKey having $activateIOPayment.idPSP as idPSP in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  # [SEM_AIPR_30]
  Scenario: Check PPT_PAGAMENTO_IN_CORSO error with PAYING debtor position and without idempotencyKey
    Given the Execute activateIOPayment (Phase 1.1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO
    And idempotencyKey with None in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
