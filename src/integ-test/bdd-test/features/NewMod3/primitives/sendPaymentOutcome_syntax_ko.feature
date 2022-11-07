Feature: Syntax checks for sendPaymentOutcome - KO

  Background:
    Given systems up
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
          <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <paymentToken>12345678901234567890123456789012</paymentToken>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
              <paymentMethod>creditCard</paymentMethod>
              <!--Optional:-->
              <paymentChannel>app</paymentChannel>
              <fee>2.00</fee>
              <!--Optional:-->
              <payer>
                <uniqueIdentifier>
                  <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
                  <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
                </uniqueIdentifier>
                <fullName>name</fullName>
                <!--Optional:-->
                <streetName>street</streetName>
                <!--Optional:-->
                <civicNumber>civic</civicNumber>
                <!--Optional:-->
                <postalCode>postal</postalCode>
                <!--Optional:-->
                <city>city</city>
                <!--Optional:-->
                <stateProvinceRegion>state</stateProvinceRegion>
                <!--Optional:-->
                <country>IT</country>
                <!--Optional:-->
                <e-mail>prova@test.it</e-mail>
              </payer>
              <applicationDate>2021-12-12</applicationDate>
              <transferDate>2021-12-11</transferDate>
            </details>
          </nod:sendPaymentOutcomeReq>
        </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

  @runnable
  # attribute value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
    Given <attribute> set <value> for <elem> in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcome response
    Examples:
      | elem             | attribute     | value                                     | soapUI test |
      | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_SPO_01  |

  @runnable
  # element value check
  Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
    Given <elem> with <value> in sendPaymentOutcome
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_SINTASSI_EXTRAXSD of sendPaymentOutcome response
    Examples:
      | elem                        | value                                                                                                                                                                                                                                                             | soapUI test  |
      | soapenv:Body                | None                                                                                                                                                                                                                                                              | SIN_SPO_02   |
      | soapenv:Body                | Empty                                                                                                                                                                                                                                                             | SIN_SPO_03   |
      | nod:sendPaymentOutcomeReq   | Empty                                                                                                                                                                                                                                                             | SIN_SPO_04   |
      | idPSP                       | None                                                                                                                                                                                                                                                              | SIN_SPO_05   |
      | idPSP                       | Empty                                                                                                                                                                                                                                                             | SIN_SPO_06   |
      | idPSP                       | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_07   |
      | idBrokerPSP                 | None                                                                                                                                                                                                                                                              | SIN_SPO_08   |
      | idBrokerPSP                 | Empty                                                                                                                                                                                                                                                             | SIN_SPO_09   |
      | idBrokerPSP                 | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_10   |
      | idChannel                   | None                                                                                                                                                                                                                                                              | SIN_SPO_11   |
      | idChannel                   | Empty                                                                                                                                                                                                                                                             | SIN_SPO_12   |
      | idChannel                   | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_13   |
      | password                    | None                                                                                                                                                                                                                                                              | SIN_SPO_14   |
      | password                    | Empty                                                                                                                                                                                                                                                             | SIN_SPO_15   |
      | password                    | 1234567                                                                                                                                                                                                                                                           | SIN_SPO_16   |
      | password                    | 1234567890123456                                                                                                                                                                                                                                                  | SIN_SPO_17   |
      | paymentToken                | None                                                                                                                                                                                                                                                              | SIN_SPO_18   |
      | paymentToken                | Empty                                                                                                                                                                                                                                                             | SIN_SPO_19   |
      | paymentToken                | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_19.1 |
      | outcome                     | None                                                                                                                                                                                                                                                              | SIN_SPO_20   |
      | outcome                     | Empty                                                                                                                                                                                                                                                             | SIN_SPO_21   |
      | outcome                     | O%                                                                                                                                                                                                                                                                | SIN_SPO_22   |
      | outcome                     | O                                                                                                                                                                                                                                                                 | SIN_SPO_22   |
      | outcome                     | OKK                                                                                                                                                                                                                                                               | SIN_SPO_22   |
      | outcome                     | O1                                                                                                                                                                                                                                                                | SIN_SPO_22   |
      | paymentMethod               | None                                                                                                                                                                                                                                                              | SIN_SPO_23   |
      | paymentMethod               | Empty                                                                                                                                                                                                                                                             | SIN_SPO_24   |
      | paymentMethod               | fail                                                                                                                                                                                                                                                              | SIN_SPO_25   |
      | paymentChannel              | Empty                                                                                                                                                                                                                                                             | SIN_SPO_27   |
      | paymentChannel              | fail                                                                                                                                                                                                                                                              | SIN_SPO_28   |
      | fee                         | None                                                                                                                                                                                                                                                              | SIN_SPO_29   |
      | fee                         | Empty                                                                                                                                                                                                                                                             | SIN_SPO_30   |
      | fee                         | 2,00                                                                                                                                                                                                                                                              | SIN_SPO_31   |
      | fee                         | 2,134                                                                                                                                                                                                                                                             | SIN_SPO_32   |
      | fee                         | 2,5                                                                                                                                                                                                                                                               | SIN_SPO_33   |
      | fee                         | 1000000000.00                                                                                                                                                                                                                                                     | SIN_SPO_34   |
      | payer                       | RemoveParent                                                                                                                                                                                                                                                      | SIN_SPO_36   |
      | payer                       | Empty                                                                                                                                                                                                                                                             | SIN_SPO_37   |
      | uniqueIdentifier            | None                                                                                                                                                                                                                                                              | SIN_SPO_38   |
      | uniqueIdentifier            | RemoveParent                                                                                                                                                                                                                                                      | SIN_SPO_39   |
      | uniqueIdentifier            | Empty                                                                                                                                                                                                                                                             | SIN_SPO_40   |
      | entityUniqueIdentifierType  | None                                                                                                                                                                                                                                                              | SIN_SPO_41   |
      | entityUniqueIdentifierType  | Empty                                                                                                                                                                                                                                                             | SIN_SPO_42   |
      | entityUniqueIdentifierType  | FF                                                                                                                                                                                                                                                                | SIN_SPO_43   |
      | entityUniqueIdentifierType  | L                                                                                                                                                                                                                                                                 | SIN_SPO_44   |
      | entityUniqueIdentifierValue | None                                                                                                                                                                                                                                                              | SIN_SPO_45   |
      | entityUniqueIdentifierValue | Empty                                                                                                                                                                                                                                                             | SIN_SPO_46   |
      | entityUniqueIdentifierValue | 12345678901234567                                                                                                                                                                                                                                                 | SIN_SPO_47   |
      | fullName                    | None                                                                                                                                                                                                                                                              | SIN_SPO_48   |
      | fullName                    | Empty                                                                                                                                                                                                                                                             | SIN_SPO_49   |
      | fullName                    | 12345678901234567890123456789012345612345678901234567890123456789012345                                                                                                                                                                                           | SIN_SPO_50   |
      | streetName                  | Empty                                                                                                                                                                                                                                                             | SIN_SPO_52   |
      | streetName                  | 12345678901234567890123456789012345612345678901234567890123456789012345                                                                                                                                                                                           | SIN_SPO_53   |
      | civicNumber                 | Empty                                                                                                                                                                                                                                                             | SIN_SPO_55   |
      | civicNumber                 | 12345678901234567                                                                                                                                                                                                                                                 | SIN_SPO_56   |
      | postalCode                  | Empty                                                                                                                                                                                                                                                             | SIN_SPO_58   |
      | postalCode                  | 12345678901234567                                                                                                                                                                                                                                                 | SIN_SPO_59   |
      | city                        | Empty                                                                                                                                                                                                                                                             | SIN_SPO_61   |
      | city                        | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_62   |
      | stateProvinceRegion         | Empty                                                                                                                                                                                                                                                             | SIN_SPO_64   |
      | stateProvinceRegion         | 123456789012345678901234567890123456                                                                                                                                                                                                                              | SIN_SPO_65   |
      | country                     | Empty                                                                                                                                                                                                                                                             | SIN_SPO_67   |
      | country                     | ITT                                                                                                                                                                                                                                                               | SIN_SPO_68   |
      | country                     | it                                                                                                                                                                                                                                                                | SIN_SPO_69   |
      | e-mail                      | Empty                                                                                                                                                                                                                                                             | SIN_SPO_71   |
      | e-mail                      | provatest.it@                                                                                                                                                                                                                                                     | SIN_SPO_72   |
      | e-mail                      | prova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777provaprova7777777prrova77777777prova@t.it | SIN_SPO_73   |
      | applicationDate             | None                                                                                                                                                                                                                                                              | SIN_SPO_74   |
      | applicationDate             | Empty                                                                                                                                                                                                                                                             | SIN_SPO_75   |
      | applicationDate             | 20-12-2021                                                                                                                                                                                                                                                        | SIN_SPO_76   |
      | applicationDate             | 20-12-21                                                                                                                                                                                                                                                          | SIN_SPO_76   |
      | applicationDate             | 21-12-09                                                                                                                                                                                                                                                          | SIN_SPO_76   |
      | transferDate                | None                                                                                                                                                                                                                                                              | SIN_SPO_77   |
      | transferDate                | Empty                                                                                                                                                                                                                                                             | SIN_SPO_78   |
      | transferDate                | 20-12-2021                                                                                                                                                                                                                                                        | SIN_SPO_79   |
      | transferDate                | 20-12-21                                                                                                                                                                                                                                                          | SIN_SPO_79   |
      | transferDate                | 21-12-09                                                                                                                                                                                                                                                          | SIN_SPO_79   |
      | idempotencyKey              | Empty                                                                                                                                                                                                                                                             | SIN_SPO_81   |
      | idempotencyKey              | 60000000001.1244565744                                                                                                                                                                                                                                            | SIN_SPO_82   |
      | idempotencyKey              | 60000000001_%244565744                                                                                                                                                                                                                                            | SIN_SPO_82   |
      | idempotencyKey              | #psp#-1244565744                                                                                                                                                                                                                                            | SIN_SPO_82   |
      | idempotencyKey              | 1244565768_#psp#                                                                                                                                                                                                                                            | SIN_SPO_82   |
      | idempotencyKey              | 1244565744                                                                                                                                                                                                                                                        | SIN_SPO_82   |
      | idempotencyKey              | 600000000011244565744                                                                                                                                                                                                                                             | SIN_SPO_82   |
      | idempotencyKey              | 60000000001_12345678901                                                                                                                                                                                                                                           | SIN_SPO_83   |
      | idempotencyKey              | 60000000001_12445657                                                                                                                                                                                                                                              | SIN_SPO_84   |
      | idempotencyKey              | 600000hj123_124456576                                                                                                                                                                                                                                             | SIN_SPO_85   |