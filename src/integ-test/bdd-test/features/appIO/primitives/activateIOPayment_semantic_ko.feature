Feature: Semantic checks for activateIOPayment - KO

  Background:
    Given systems up

  @runnable
  Scenario: set config parameter scheduler
    Given nodo-dei-pagamenti has config parameter scheduler.jobName_annullamentoRptMaiRichiesteDaPm.enabled set to false

  @runnable
  Scenario Outline: Check errors on activateIOPayment
    Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paGetPaymentRes>
      <outcome>OK</outcome>
      <data>
      <creditorReferenceId>#cod_segr#$1iuv</creditorReferenceId>
      <paymentAmount>10.00</paymentAmount>
      <dueDate>2021-07-31</dueDate>
      <description>TARI 2021</description>
      <companyName>company PA</companyName>
      <officeName>office PA</officeName>
      <debtor>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>John Doe</fullName>
      <streetName>street</streetName>
      <civicNumber>12</civicNumber>
      <postalCode>89020</postalCode>
      <city>city</city>
      <stateProvinceRegion>MI</stateProvinceRegion>
      <country>IT</country>
      <e-mail>john.doe@test.it</e-mail>
      </debtor>
      <transferList>
      <transfer>
      <idTransfer>1</idTransfer>
      <transferAmount>10.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT96R0123454321000000012345</IBAN>
      <remittanceInformation>TARI Comune EC_TE</remittanceInformation>
      <transferCategory>0101101IM</transferCategory>
      </transfer>
      </transferList>
      </data>
      </paf:paGetPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activateIOPaymentReq>
      <idPSP>#psp_AGID#</idPSP>
      <idBrokerPSP>#broker_AGID#</idBrokerPSP>
      <idChannel>#canale_AGID#</idChannel>
      <password>pwdpwdpwd</password>
      <!--Optional:-->
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>$1noticeNumber</noticeNumber>
      </qrCode>
      <!--Optional:-->
      <expirationTime>6000</expirationTime>
      <amount>10.00</amount>
      <!--Optional:-->
      <dueDate>2021-12-12</dueDate>
      <!--Optional:-->
      <paymentNote>responseFull</paymentNote>
      <!--Optional:-->
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
    And EC new version
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
      | fiscalCode   | 11111122223        | PPT_DOMINIO_DISABILITATO            | SEM_AIPR_10                                            |
      | noticeNumber | 511456789012345678 | PPT_STAZIONE_INT_PA_SCONOSCIUTA     | SEM_AIPR_12 - auxDigit inesistente                     |
      | noticeNumber | 011456789012345678 | PPT_STAZIONE_INT_PA_SCONOSCIUTA     | SEM_AIPR_12 - auxDigit 0 - progressivo inesistente     |
      | noticeNumber | 323134567890787583 | PPT_STAZIONE_INT_PA_SCONOSCIUTA     | SEM_AIPR_12 - auxDigit 3 - segregationCode inesistente |
      | noticeNumber | 316456789012345678 | PPT_STAZIONE_INT_PA_DISABILITATA    | SEM_AIPR_13                                            |
      | noticeNumber | 099456789012345678 | PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE | SEM_AIRP_14                                            |
      | noticeNumber | 312456789012345678 | PPT_MULTI_BENEFICIARIO              | SEM_AIPR_15                                            |
      | noticeNumber | 010456789012345678 | PPT_INTERMEDIARIO_PA_DISABILITATO   | SEM_AIPR_16                                            |

  @runnable
  # idChannel value check: idChannel with value in NODO4_CFG.CANALI whose field MODELLO_PAGAMENTO in NODO4_CFG.CANALI_NODO table of nodo-dei-pagamenti database does not contain value 'ATTIVATO_PRESSO_PSP' (e.g. contains 'IMMEDIATO_MULTIBENEFICIARIO') [SEM_AIPR_07]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp channel not enabled for payment model 3
    Given generate 2 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paGetPaymentRes>
      <outcome>OK</outcome>
      <data>
      <creditorReferenceId>#cod_segr#$2iuv</creditorReferenceId>
      <paymentAmount>10.00</paymentAmount>
      <dueDate>2021-07-31</dueDate>
      <description>TARI 2021</description>
      <companyName>company PA</companyName>
      <officeName>office PA</officeName>
      <debtor>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>John Doe</fullName>
      <streetName>street</streetName>
      <civicNumber>12</civicNumber>
      <postalCode>89020</postalCode>
      <city>city</city>
      <stateProvinceRegion>MI</stateProvinceRegion>
      <country>IT</country>
      <e-mail>john.doe@test.it</e-mail>
      </debtor>
      <transferList>
      <transfer>
      <idTransfer>1</idTransfer>
      <transferAmount>10.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT96R0123454321000000012345</IBAN>
      <remittanceInformation>TARI Comune EC_TE</remittanceInformation>
      <transferCategory>0101101IM</transferCategory>
      </transfer>
      </transferList>
      </data>
      </paf:paGetPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activateIOPaymentReq>
      <idPSP>#psp_AGID#</idPSP>
      <idBrokerPSP>#broker_AGID#</idBrokerPSP>
      <idChannel>#canale_AGID#</idChannel>
      <password>pwdpwdpwd</password>
      <!--Optional:-->
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>$2noticeNumber</noticeNumber>
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
    And idChannel with 70000000001_03_ONUS in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPayment response
  #And check description is Il canale non è di tipo 'ATTIVATO_PRESSO_PSP' of activateIOPayment response

  @runnable 
  # idBrokerPSP-idPSP value check: idBrokerPSP not associated to idPSP [SEM_AIPR_11]
  Scenario: Check PPT_AUTORIZZAZIONE error on psp broker not associated to psp
    Given generate 3 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activateIOPaymentReq>
      <idPSP>#psp_AGID#</idPSP>
      <idBrokerPSP>#broker_AGID#</idBrokerPSP>
      <idChannel>#canale_AGID#</idChannel>
      <password>pwdpwdpwd</password>
      <!--Optional:-->
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>$3noticeNumber</noticeNumber>
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
    And initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paGetPaymentRes>
      <outcome>OK</outcome>
      <data>
      <creditorReferenceId>#cod_segr#$3iuv</creditorReferenceId>
      <paymentAmount>10.00</paymentAmount>
      <dueDate>2021-07-31</dueDate>
      <description>TARI 2021</description>
      <companyName>company PA</companyName>
      <officeName>office PA</officeName>
      <debtor>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>John Doe</fullName>
      <streetName>street</streetName>
      <civicNumber>12</civicNumber>
      <postalCode>89020</postalCode>
      <city>city</city>
      <stateProvinceRegion>MI</stateProvinceRegion>
      <country>IT</country>
      <e-mail>john.doe@test.it</e-mail>
      </debtor>
      <transferList>
      <transfer>
      <idTransfer>1</idTransfer>
      <transferAmount>10.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT96R0123454321000000012345</IBAN>
      <remittanceInformation>TARI Comune EC_TE</remittanceInformation>
      <transferCategory>0101101IM</transferCategory>
      </transfer>
      </transferList>
      </data>
      </paf:paGetPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    And idBrokerPSP with 91000000001 in activateIOPayment
    When psp sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_AUTORIZZAZIONE of activateIOPayment response
    And check description is Configurazione intermediario-canale non corretta of activateIOPayment response

  
  Scenario: Execute activateIOPayment (Phase 1)
    Given generate 4 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activateIOPaymentReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <!--Optional:-->
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>$4noticeNumber</noticeNumber>
      </qrCode>
      <!--Optional:-->
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <!--Optional:-->
      <dueDate>2021-12-12</dueDate>
      <!--Optional:-->
      <paymentNote>responseFull</paymentNote>
      <!--Optional:-->
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
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
    And initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <paf:paGetPaymentRes>
      <outcome>OK</outcome>
      <data>
      <creditorReferenceId>#cod_segr#$4iuv</creditorReferenceId>
      <paymentAmount>10.00</paymentAmount>
      <dueDate>2021-12-31</dueDate>
      <!--Optional:-->
      <retentionDate>2021-12-31T12:12:12</retentionDate>
      <!--Optional:-->
      <lastPayment>1</lastPayment>
      <description>description</description>
      <!--Optional:-->
      <companyName>company</companyName>
      <!--Optional:-->
      <officeName>office</officeName>
      <debtor>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>#creditor_institution_code#</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>paGetPaymentName</fullName>
      <!--Optional:-->
      <streetName>paGetPaymentStreet</streetName>
      <!--Optional:-->
      <civicNumber>paGetPayment99</civicNumber>
      <!--Optional:-->
      <postalCode>20155</postalCode>
      <!--Optional:-->
      <city>paGetPaymentCity</city>
      <!--Optional:-->
      <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
      <!--Optional:-->
      <country>IT</country>
      <!--Optional:-->
      <e-mail>paGetPayment@test.it</e-mail>
      </debtor>
      <!--Optional:-->
      <transferList>
      <!--1 to 5 repetitions:-->
      <transfer>
      <idTransfer>1</idTransfer>
      <transferAmount>3.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>2</idTransfer>
      <transferAmount>3.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>3</idTransfer>
      <transferAmount>4.00</transferAmount>
      <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      </transferList>
      <!--Optional:-->
      <metadata>
      <!--1 to 10 repetitions:-->
      <mapEntry>
      <key>1</key>
      <value>22</value>
      </mapEntry>
      </metadata>
      </data>
      </paf:paGetPaymentRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro AppIO

  @runnable
  # [SEM_AIPR_20]
  Scenario: Check second activateIOPayment is equal to the first
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And wait 10 seconds for expiration
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  @runnable
  # [SEM_AIPR_21]
  Scenario Outline: Check PPT_ERRORE_IDEMPOTENZA error on idempotencyKey validity (Phase 2)
    Given nodo-dei-pagamenti has config parameter useIdempotency set to true
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And <tag> with <tag_value> in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_ERRORE_IDEMPOTENZA of activateIOPayment response
    Examples:
      | tag                         | tag_value             | soapUI test |
      | noticeNumber                | 302119138889055636    | SEM_AIPR_21 |
      | fiscalCode                  | 88888888888           | SEM_AIPR_21 |
      | amount                      | 15.12                 | SEM_AIPR_21 |
      | dueDate                     | 2021-12-31            | SEM_AIPR_21 |
      | dueDate                     | None                  | SEM_AIPR_21 |
      | paymentNote                 | test_1                | SEM_AIPR_21 |
      | paymentNote                 | None                  | SEM_AIPR_21 |
      | expirationTime              | 123456                | SEM_AIPR_21 |
      | expirationTime              | None                  | SEM_AIPR_21 |
      | payer                       | None                  | SEM_AIPR_21 |
      | entityUniqueIdentifierType  | F                     | SEM_AIPR_21 |
      | entityUniqueIdentifierValue | 55555555555           | SEM_AIPR_21 |
      | fullName                    | name_1                | SEM_AIPR_21 |
      | streetName                  | streetName            | SEM_AIPR_21 |
      | streetName                  | None                  | SEM_AIPR_21 |
      | civicNumber                 | civicNumber           | SEM_AIPR_21 |
      | civicNumber                 | None                  | SEM_AIPR_21 |
      | postalCode                  | postalCode            | SEM_AIPR_21 |
      | postalCode                  | None                  | SEM_AIPR_21 |
      | city                        | new_city              | SEM_AIPR_21 |
      | city                        | None                  | SEM_AIPR_21 |
      | stateProvinceRegion         | stateProvinceRegion   | SEM_AIPR_21 |
      | stateProvinceRegion         | None                  | SEM_AIPR_21 |
      | country                     | FR                    | SEM_AIPR_21 |
      | country                     | None                  | SEM_AIPR_21 |
      | e-mail                      | test1@prova.gmail.com | SEM_AIPR_21 |
      | e-mail                      | None                  | SEM_AIPR_21 |

  @runnable
  # [SEM_AIPR_22]
  Scenario Outline: Check OK on idempotencyKey validity
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And generate 5 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And <tag> with <value> in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And restore initial configurations
    Examples:
      | tag          | value              | soapUI test |
      | noticeNumber | $5noticeNumber     | SEM_AIPR_22 |
  #| fiscalCode   | 90000000001        | SEM_AIPR_22 |

  @runnable
  Scenario Outline: Check PPT_PAGAMENTO_IN_CORSO error on idempotencyKey validity
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
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

  @runnable
  # [SEM_AIPR_23]
  Scenario: Check reuse of idempotencyKey with expired paymentToken
    Given nodo-dei-pagamenti has config parameter useIdempotency set to true
    And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And PSP waits expirationTime of activateIOPayment expires
    And wait 5 seconds for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And restore initial configurations

  @runnable
  # [SEM_AIPR_24]
  Scenario: [SEM_AIPR_24]
    Given nodo-dei-pagamenti has config parameter default_durata_token_IO set to 15000
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And wait 20 seconds for expiration
    And expirationTime with 12345 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  @runnable
  # [SEM_AIPR_25]
  Scenario: [SEM_AIPR_25]
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And wait 20 seconds for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  @runnable
  # [SEM_AIPR_26]
  Scenario: [SEM_AIPR_26]
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And wait 20 seconds for expiration
    And expirationTime with 12345 in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  @runnable
  # [SEM_AIPR_27]
  Scenario: Check reuse of idempotencyKey with expired idempotencyKey validity
    Given nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And wait 70 seconds for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And restore initial configurations

  @runnable 
  # [SEM_AIPR_28]
  Scenario: [SEM_AIPR_28]
    Given nodo-dei-pagamenti has config parameter useIdempotency set to false
    And nodo-dei-pagamenti has config parameter default_idempotency_key_validity_minutes set to 1
    And the Execute activateIOPayment (Phase 1) scenario executed successfully
    And wait 70 seconds for expiration
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And verify 0 record for the table IDEMPOTENCY_CACHE retrived by the query payment_status on db nodo_online under macro AppIO
    And restore initial configurations

  @runnable
  # [SEM_AIPR_29]
  Scenario: Check PPT_PAGAMENTO_IN_CORSO error with PAYING debtor position
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And random idempotencyKey having #psp# as idPSP in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response

  @runnable
  # [SEM_AIPR_30]
  Scenario: Check PPT_PAGAMENTO_IN_CORSO error with PAYING debtor position and without idempotencyKey
    Given the Execute activateIOPayment (Phase 1) scenario executed successfully
    And checks the value PAYING of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro AppIO
    And idempotencyKey with None in activateIOPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is KO of activateIOPayment response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activateIOPayment response
    And restore initial configurations
