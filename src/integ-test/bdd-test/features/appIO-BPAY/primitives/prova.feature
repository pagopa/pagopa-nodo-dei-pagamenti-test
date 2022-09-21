  Feature: prova

  Background:
    Given systems up
  
  
  # syntax check - No error [SIN_CP_31.2]
  Scenario: activateIOPayment
    Given initial XML activateIOPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForIO.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activateIOPaymentReq>
      <idPSP>#psp_AGID#</idPSP>
      <idBrokerPSP>#broker_AGID#</idBrokerPSP>
      <idChannel>#canale_AGID#</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code#</fiscalCode>
      <noticeNumber>311#iuv#</noticeNumber>
      </qrCode>
      <amount>12.00</amount>
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
    And initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <paf:paGetPaymentRes>
      <outcome>OK</outcome>
      <data>
      <creditorReferenceId>11$iuv</creditorReferenceId>
      <paymentAmount>12.00</paymentAmount>
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
      <transferAmount>5.00</transferAmount>
      <fiscalCodePA>66666666666</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>2</idTransfer>
      <transferAmount>3.00</transferAmount>
      <fiscalCodePA>66666666666</fiscalCodePA>
      <IBAN>IT45R0760103200000000001016</IBAN>
      <remittanceInformation>testPaGetPayment</remittanceInformation>
      <transferCategory>paGetPaymentTest</transferCategory>
      </transfer>
      <transfer>
      <idTransfer>3</idTransfer>
      <transferAmount>4.00</transferAmount>
      <fiscalCodePA>66666666666</fiscalCodePA>
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
  
  
  
  
  # syntax check - No error with 2 tokens [SIN_CP_03.2]
  Scenario: check activateIOPayment OK 2 tokens
    Given the activateIOPayment scenario executed successfully
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse

  Scenario: check activateIOPayment2 OK 2 tokens
    Given the check activateIOPayment OK 2 tokens scenario executed successfully
    And random iuv in context
    And noticeNumber with 311$iuv in activateIOPayment
    And creditorReferenceId with 11$iuv in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activateIOPayment to nodo-dei-pagamenti
    Then check outcome is OK of activateIOPayment response
    And save activateIOPayment response in activateIOPaymentResponse2

  Scenario: nodoChiediInformazioniPagamento
    Given the check activateIOPayment2 OK 2 tokens scenario executed successfully
    When WISP sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: nodoChiediInformazioniPagamento2
    Given the nodoChiediInformazioniPagamento scenario executed successfully
    When WISP sends REST GET informazioniPagamento?idPagamento=$activateIOPaymentResponse2.paymentToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

  Scenario: closePayment 2 tokens
    Given the nodoChiediInformazioniPagamento2 scenario executed successfully
    And initial JSON v1/closepayment
      """
      {
        "paymentTokens": [
          "$activateIOPaymentResponse.paymentToken",
          "$activateIOPaymentResponse2.paymentToken"
        ],
        "outcome": "OK",
        "identificativoPsp": "#psp#",
        "tipoVersamento": "BPAY",
        "identificativoIntermediario": "#id_broker_psp#",
        "identificativoCanale": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
        "pspTransactionId": "#psp_transaction_id#",
        "totalAmount": 14,
        "fee": 2,
        "timestampOperation": "2033-04-23T18:25:43Z",
        "additionalPaymentInformations": {
          "transactionId": "#transaction_id#",
          "outcomePaymentGateway": "EFF",
          "authorizationCode": "resOK"
        }
      }
      """

  Scenario: check closePayment OK with 2 tokens
    Given the closePayment 2 tokens scenario executed successfully
    When WISP sends rest POST v1/closepayment_json to nodo-dei-pagamenti
    Then verify the HTTP status code of v1/closepayment response is 200
    And check esito is OK of v1/closepayment response