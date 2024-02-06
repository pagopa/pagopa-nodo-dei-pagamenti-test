Feature: process tests for paSendRT

  Background:
    Given systems up


  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    Given initial XML verifyPaymentNotice
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
        <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
                <fiscalCode>#creditor_institution_code#</fiscalCode>
                <noticeNumber>#notice_number#</noticeNumber>
            </qrCode>
        </nod:verifyPaymentNoticeReq>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  # Define primitive paGetPayment
  Scenario: Define paGetPayment
    Given initial XML paGetPayment
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <paf:paGetPaymentRes>
                <outcome>OK</outcome>
                <data>
                    <creditorReferenceId>$iuv</creditorReferenceId>
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
                            <transferAmount>5.00</transferAmount>
                            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
                            <IBAN>IT45R0760103200000000001016</IBAN>
                            <remittanceInformation>testPaGetPayment</remittanceInformation>
                            <transferCategory>paGetPaymentTest</transferCategory>
                        </transfer>
                        <transfer>
                            <idTransfer>2</idTransfer>
                            <transferAmount>5.00</transferAmount>
                            <fiscalCodePA>90000000001</fiscalCodePA>
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
    And initial XML activatePaymentNotice
	"""
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
        <soapenv:Header/>
        <soapenv:Body>
            <nod:activatePaymentNoticeReq>
                <idPSP>#psp#</idPSP>
                <idBrokerPSP>#psp#</idBrokerPSP>
                <idChannel>#canale_IMMEDIATO_MULTIBENEFICIARIO#</idChannel>
                <password>pwdpwdpwd</password>
                <idempotencyKey>#idempotency_key#</idempotencyKey>
                <qrCode>
                    <fiscalCode>$verifyPaymentNotice.fiscalCode</fiscalCode>
                    <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
                </qrCode>
                <expirationTime>120000</expirationTime>
                <amount>10.00</amount>
                <dueDate>2021-12-31</dueDate>
                <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
        </soapenv:Body>
    </soapenv:Envelope>
	"""


  # Define primitive sendPaymentOutcome
  Scenario: Define sendPaymentOutcome
    Given initial XML sendPaymentOutcome
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <nod:sendPaymentOutcomeReq>
          <idPSP>#psp#</idPSP>
          <idBrokerPSP>#psp#</idBrokerPSP>
          <idChannel>#canale_IMMEDIATO_MULTIBENEFICIARIO#</idChannel>
          <password>pwdpwdpwd</password>
          <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
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
    
 
  # Activate phase [PSRT_04]
  Scenario: Execute activatePaymentNotice request with lastPayment to 1
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  @pippoalf
  # Send Payment Outcome phase [PSRT_01]
  Scenario: Execute sendPaymentOutcome request with lastPayment to 1
    Given the Execute activatePaymentNotice request with lastPayment to 1 scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

##################################################################################################################


    Scenario: checkPosition
        Given initial json checkPosition
            """
            {
                "positionslist": [
                    {
                        "fiscalCode": "#creditor_institution_code#",
                        "noticeNumber": "309#iuv#"
                    }
                ]
            }
            """
        When WISP sends rest POST checkPosition_json to nodo-dei-pagamenti
        Then verify the HTTP status code of checkPosition response is 200
        And check outcome is OK of checkPosition response

    Scenario: activatePaymentNoticeV2 request
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>309$iuv</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paGetPaymentV2 response
        Given initial XML paGetPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <paf:paGetPaymentV2Response>
            <outcome>OK</outcome>
            <data>
            <creditorReferenceId>09$iuv</creditorReferenceId>
            <paymentAmount>10.00</paymentAmount>
            <dueDate>2021-12-12</dueDate>
            <!--Optional:-->
            <retentionDate>2021-12-30T12:12:12</retentionDate>
            <!--Optional:-->
            <lastPayment>1</lastPayment>
            <description>test</description>
            <companyName>company</companyName>
            <!--Optional:-->
            <officeName>office</officeName>
            <debtor>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>44444444444</entityUniqueIdentifierValue>
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
            <transferList>
            <!--1 to 5 repetitions:-->
            <transfer>
            <idTransfer>1</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>$activatePaymentNoticeV2.fiscalCode</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </metadata>
            </transfer>
            <transfer>
            <idTransfer>2</idTransfer>
            <transferAmount>5.00</transferAmount>
            <fiscalCodePA>90000000001</fiscalCodePA>
            <companyName>companySec</companyName>
            <IBAN>IT45R0760103200000000001016</IBAN>
            <remittanceInformation>/RFB/00202200000217527/5.00/TXT/</remittanceInformation>
            <transferCategory>paGetPaymentTest</transferCategory>
            <!--Optional:-->
            <metadata>
            <!--1 to 10 repetitions:-->
            <mapEntry>
            <key>1</key>
            <value>22</value>
            </mapEntry>
            </metadata>
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
            </paf:paGetPaymentV2Response>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: closePaymentV2 request
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2_1Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_versione_primitive_2#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                }
            }
            """

    Scenario: sendPaymentOutcomeV2 request
        Given initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeV2_1Response.paymentToken</paymentToken>
            </paymentTokens>
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
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """


    # FLUSSO_SPR_01

    Scenario: FLUSSO_SPR_01 (part 1)
        Given current date generation
        And the checkPosition scenario executed successfully
        And the activatePaymentNoticeV2 request scenario executed successfully
        And the paGetPaymentV2 response scenario executed successfully
        And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response
        And save activatePaymentNoticeV2 response in activatePaymentNoticeV2_1

    Scenario: FLUSSO_SPR_01 (part 2)
        Given the FLUSSO_SPR_01 (part 1) scenario executed successfully
        And the closePaymentV2 request scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response
    @pippoalf2
    Scenario: FLUSSO_SPR_01 (part 3)
        Given the FLUSSO_SPR_01 (part 2) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 request scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response
