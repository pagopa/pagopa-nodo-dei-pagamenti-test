Feature: process tests for paSendRT

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
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

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  # Define primitive paGetPayment
  Scenario: Define paGetPayment
    Given initial XML paGetPayment
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
      xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
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
      <transferAmount>10.00</transferAmount>
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

  # Define primitive activatePaymentNotice
  Scenario: Define activatePaymentNotice
    Given initial XML activatePaymentNotice
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
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <paymentToken>token</paymentToken>
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

  # Activate phase [PSRT_03]
  Scenario: Execute activatePaymentNotice request with lastPayment to 0
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And lastPayment with 0 in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    And the Define activatePaymentNotice scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase
  @runnable
  Scenario: Execute sendPaymentOutcome request with lastPayment to 0
    Given the Execute activatePaymentNotice request with lastPayment to 0 scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Activate phase [PSRT_04]
  @runnable
  Scenario: Execute activatePaymentNotice request with lastPayment to 1
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$verifyPaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define activatePaymentNotice scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Activate phase - 3 transfers in paGetPayment transferList and broadcast false for all stations [PSRT_05]
  Scenario: Execute activatePaymentNotice request with 3 transfers
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    #   TODO with apiconfig: And broadcast with false in NODO4_CFG.PA_STAZIONE_PA for EC 77777777777, 90000000001 and 90000000002
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_05]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 3 transfers
    Given the Execute activatePaymentNotice request with 3 transfers scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Activate phase - 5 transfers in paGetPayment transferList and broadcast true for secondary EC [PSRT_06]
  Scenario: Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    #   TODO with apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201 (90000000001) and 13 (90000000002)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_06]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 3 transfers and broadcast true for secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
  #And check EC receives paSendRT properly having in the transfer with idTransfer 1 the same fiscalCodePA of paGetPayment
  #And check EC receives paSendRT properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPayment

  # Activate phase - 2 transfers in paGetPayment transferList and broadcast true for 2 stations of secondary EC [PSRT_07]
  Scenario: Execute activatePaymentNotice request with 2 transfers and broadcast true for 2 stations of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And paymentAmount with 6.00 in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 11993 and 1201
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_07]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 2 transfers and broadcast true for 2 stations of secondary EC
    Given the Execute activatePaymentNotice request with 2 transfers and broadcast true for 2 stations of secondary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
  #And check EC receives paSendRT properly having in the transfer with idTransfer 1 the same fiscalCodePA of paGetPayment
  #And check EC receives paSendRT properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPayment


  # Activate phase - 3 transfers in paGetPayment transferList (1 for primary EC and 2 for same secondary EC) and broadcast true for 1 station of secondary EC [PSRT_08]
  Scenario: Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>2.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>5.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_08]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 1 station of secondary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
  #And check EC receives paSendRT properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPayment


  # Activate phase - 3 transfers in paGetPayment transferList (1 for primary EC and 2 for same secondary EC) and broadcast true for 2 stations of secondary EC [PSRT_09]
  Scenario: Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 2 stations of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>2.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>5.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    # TODO And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 11993 and 1201
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_09]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 2 stations of secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 2 stations of secondary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
  #And check EC receives paSendRT properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPayment
  #And check EC receives paSendRT properly having in the transfer with idTransfer 3 the same fiscalCodePA of paGetPayment


  # Activate phase - 3 transfers in paGetPayment transferList (2 for primary EC and 1 for secondary EC) and broadcast true for 1 station of secondary EC [PSRT_10]
  Scenario: Execute activatePaymentNotice request with 3 transfers, 2 for primary EC and 1 for secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>2.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>44444444444</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>5.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    # TODO And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_10]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 3 transfers, 2 for primary EC and 1 for secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers, 2 for primary EC and 1 for secondary EC, and broadcast true for 1 station of secondary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
  #And check EC receives paSendRT properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPayment


  # Activate phase - 1 transfer in paGetPayment transferList for secondary EC and broadcast false for all stations of secondary EC [PSRT_11]
  Scenario: Execute activatePaymentNotice request with 1 transfer for secondary EC and broadcast false for all stations of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>10.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    # TODO apiconfig: And broadcast with false in NODO4_CFG.PA_STAZIONE_PA for EC 90000000001 (OBJ_ID = 1201)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_11]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 1 transfer for secondary EC and broadcast false for all stations of secondary EC
    Given the Execute activatePaymentNotice request with 1 transfer for secondary EC and broadcast false for all stations of secondary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode


  # Activate phase - 1 transfer in paGetPayment transferList and broadcast true for 1 station of primary EC [PSRT_12]
  Scenario: Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>10.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for EC 90000000001 (OBJ_ID = 1201)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Activate phase - 1 transfer in paGetPayment transferList and broadcast true for 1 station of primary EC with expirationTime [PSRT_12]
  Scenario: Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC with expirationTime
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>10.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for EC 90000000001 (OBJ_ID = 1201)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Send Payment Outcome phase [PSRT_12]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 1 transfer and broadcast true for 1 station of primary EC
    Given the Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT properly with noticeNumber $activatePaymentNotice.noticeNumber
  #And check EC receives paSendRT properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Send Payment Outcome phase [PSRT_13]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 1 transfer and broadcast true for 1 station of primary EC and outcome KO
    Given the Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Send Payment Outcome phase [PSRT_14]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 3 transfers and outcome KO
    Given the Execute activatePaymentNotice request with 3 transfers scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Send Payment Outcome phase [PSRT_15]
  @runnable
  Scenario: Execute sendPaymentOutcome request with 3 transfers and broadcast true for secondary EC and outcome KO
    Given the Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
  #And check EC receives paSendRT not properly with noticeNumber $activatePaymentNotice.noticeNumber


  # Mod3Cancel Phase - [PSRT_16]
  @runnable
  Scenario: Execute mod3Cancel poller with 1 transfer and broadcast true for 1 station of primary EC with expirationTime
    Given the Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC with expirationTime scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200
  #And check EC receives paSendRT not properly with noticeNumber $activatePaymentNotice.noticeNumber


# Activate phase - 4 transfers in paGetPayment transferList and broadcast false for all stations [PSRT_05]
  Scenario: Execute activatePaymentNotice request with 3 transfers with expiration time
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    #   TODO with apiconfig: And broadcast with false in NODO4_CFG.PA_STAZIONE_PA for EC 77777777777, 90000000001 and 90000000002
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Mod3Cancel Phase - [PSRT_17]
  @runnable
  Scenario: Execute mod3Cancel poller with 3 transfers with expiration time
    Given the Execute activatePaymentNotice request with 3 transfers with expiration time scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200
  #And check EC receives paSendRT not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Activate phase - 6 transfers in paGetPayment transferList and broadcast true for secondary EC and expiration time [PSRT_18]
  Scenario: Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC with expirationTime
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    And the Define paGetPayment scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    #   TODO with apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201 (90000000001) and 13 (90000000002)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # Mod3Cancel Phase - [PSRT_18]
  @runnable
  Scenario: Execute mod3Cancel poller with 3 transfers and broadcast true for secondary EC with expirationTime
    Given the Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC with expirationTime scenario executed successfully
    And initial XML paSendRT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <paf:paSendRTRes>
      <outcome>KO</outcome>
      <!--Optional:-->
      <fault>
      <faultCode>PAA_SEMANTICA</faultCode>
      <faultString>chiamata da rifiutare</faultString>
      <id>$activatePaymentNotice.fiscalCode</id>
      </fault>
      </paf:paSendRTRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paSendRT
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200
#And check EC receives paSendRT not properly with noticeNumber $activatePaymentNotice.noticeNumber