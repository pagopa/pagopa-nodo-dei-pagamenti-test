Feature: syntax checks for closePayment outcome OK

  Background:
    Given systems up

  Scenario: closePayment
    Given initial JSON v1/closepayment
      """
      {
        "paymentTokens": [
          "a3738f8bff1f4a32998fc197bd0a6b05"
        ],
        "outcome": "OK",
        "identificativoPsp": "#psp#",
        "tipoVersamento": "BPAY",
        "identificativoIntermediario": "#id_broker_psp#",
        "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
        "pspTransactionId": "#psp_transaction_id#",
        "totalAmount": 12,
        "fee": 2,
        "timestampOperation": "2033-04-23T18:25:43Z",
        "additionalPaymentInformations": {
          "transactionId": "#transaction_id#",
          "outcomePaymentGateway": "EFF",
          "authorizationCode": "resOK"
        }
      }
      """

  # Scenario: closePayment without brackets in paymentTokens
  #   Given initial JSON v1/closepayment
  #     """
  #     {
  #       "paymentTokens": "a3738f8bff1f4a32998fc197bd0a6b05",
  #       "outcome": "OK",
  #       "identificativoPsp": "#psp#",
  #       "tipoVersamento": "BPAY",
  #       "identificativoIntermediario": "#id_broker_psp#",
  #       "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
  #       "pspTransactionId": "#psp_transaction_id#",
  #       "totalAmount": 12,
  #       "fee": 2,
  #       "timestampOperation": "2033-04-23T18:25:43Z",
  #       "additionalPaymentInformations": {
  #         "transactionId": "#transaction_id#",
  #         "outcomePaymentGateway": "EFF",
  #         "authorizationCode": "resOK"
  #       }
  #     }
  #     """

  # element value check
  Scenario Outline: Check syntax error on invalid body element value
    Given the closePayment scenario executed successfully
    And <elem> with <value> in v1/closepayment
    When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v1/closepayment response is 400
    And check esito is KO of v1/closepayment response
    And check descrizione is <elem> invalido of v1/closepayment response
    Examples:
      | elem                        | value                                                                                                                                                                                                                                                            | soapUI test |
      | paymentTokens               | None                                                                                                                                                                                                                                                             | SIN_CP_01   |
      #  | paymentTokens                  | No []                                 | SIN_CP_03.1 |
      | outcome                     | None                                                                                                                                                                                                                                                             | SIN_CP_04   |
      | outcome                     | Empty                                                                                                                                                                                                                                                            | SIN_CP_05   |
      | outcome                     | OO                                                                                                                                                                                                                                                               | SIN_CP_06   |
      | identificativoPsp           | None                                                                                                                                                                                                                                                             | SIN_CP_07   |
      | identificativoPsp           | 700000000017000000000170000000001700                                                                                                                                                                                                                             | SIN_CP_09   |
      | tipoVersamento              | None                                                                                                                                                                                                                                                             | SIN_CP_10   |
      | tipoVersamento              | Empty                                                                                                                                                                                                                                                            | SIN_CP_11   |
      | identificativoIntermediario | None                                                                                                                                                                                                                                                             | SIN_CP_13   |
      | identificativoIntermediario | 700000000017000000000170000000001700                                                                                                                                                                                                                             | SIN_CP_15   |
      | identificativoCanale        | None                                                                                                                                                                                                                                                             | SIN_CP_16   |
      | identificativoCanale        | 70000000001_0370000000001_0370000000                                                                                                                                                                                                                             | SIN_CP_18   |
      | pspTransactionId            | None                                                                                                                                                                                                                                                             | SIN_CP_19   |
      | pspTransactionId            | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_21   |
      | totalAmount                 | None                                                                                                                                                                                                                                                             | SIN_CP_22   |
      | totalAmount                 | 12.321                                                                                                                                                                                                                                                           | SIN_CP_25   |
      | totalAmount                 | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CP_26   |
      | fee                         | None                                                                                                                                                                                                                                                             | SIN_CP_27   |
      | fee                         | 12.321                                                                                                                                                                                                                                                           | SIN_CP_30   |
      | fee                         | 1234567890.12                                                                                                                                                                                                                                                    | SIN_CP_31   |
      | timestampOperation          | None                                                                                                                                                                                                                                                             | SIN_CP_32   |
      | timestampOperation          | Empty                                                                                                                                                                                                                                                            | SIN_CP_33   |
      | timestampOperation          | 2012-04-23                                                                                                                                                                                                                                                       | SIN_CP_34   |
      | timestampOperation          | 2012-04-23T18:25:43                                                                                                                                                                                                                                              | SIN_CP_34   |
      | timestampOperation          | 2012-04-23T18:25                                                                                                                                                                                                                                                 | SIN_CP_34   |
      | transactionId               | None                                                                                                                                                                                                                                                             | SIN_CP_37   |
      | transactionId               | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_39   |
      | outcomePaymentGateway       | None                                                                                                                                                                                                                                                             | SIN_CP_40   |
      | outcomePaymentGateway       | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_42   |
      | authorizationCode           | None                                                                                                                                                                                                                                                             | SIN_CP_43   |
      | authorizationCode           | abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fghilmno456pqrst789uvz0WYK_abcde123fgh | SIN_CP_45   |


  Scenario Outline: Check syntax error on invalid body element value
    Given the closePayment scenario executed successfully
    And <elem> with <value> in v1/closepayment
    When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v1/closepayment response is 400
    And check esito is KO of v1/closepayment response
    And check descrizione is paymentTokens invalido of v1/closepayment response
    Examples:
      | elem         | value                                 | soapUI test |
      | paymentToken | None                                  | SIN_CP_02   |
      | paymentToken | 87cacaf799cadf9vs9s7vasdvs676cavv4574 | SIN_CP_03   |

  # Scenario: check closePayment without brackets in paymentTokens
  #   Given the closePayment without brackets in paymentTokens scenario executed successfully
  #   When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
  #   Then verify the HTTP status code of v1/closepayment response is 400
  #   And check esito is KO of v1/closepayment response
  #   And check descrizione is paymentTokens invalido of v1/closepayment response


  Scenario: activateIOPayment
    Given initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activateIOPaymentReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>#password#</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>311#iuv#</noticeNumber>
      </qrCode>
      <!--Optional:-->
      <expirationTime>60000</expirationTime>
      <amount>10.00</amount>
      <!--Optional:-->
      <dueDate>2021-12-31</dueDate>
      <!--Optional:-->
      <paymentNote>responseFull</paymentNote>
      <!--Optional:-->
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>66666666666</entityUniqueIdentifierValue>
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
      <creditorReferenceId>11$iuv</creditorReferenceId>
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
      <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
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
      <transferAmount>10.00</transferAmount>
      <fiscalCodePA>$activateIOPayment.fiscalCode</fiscalCodePA>
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

  Scenario: check activateIOPayment OK
    Given the activateIOPayment scenario executed successfully
    When PSP send SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse

  Scenario: nodoChiediInformazioniPagamento
    Given the check activateIOPayment OK scenario executed successfully
    When WISP sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: check closePayment OK
    Given the closePayment scenario executed successfully
    And the nodoChiediInformazioniPagamento scenario executed successfully
    When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response

