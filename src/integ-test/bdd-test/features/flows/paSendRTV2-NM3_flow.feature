Feature: process tests for paSendRTV2 on NM3 flow

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
      And stazione with versione_primitive = 2
    
  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  # Define primitive paGetPaymentV2
  Scenario: Define paGetPaymentV2
    Given initial XML paGetPaymentV2
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
                      xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <paf:paGetPaymentV2Response>
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
              <e-mail>paGetPaymentV2@test.it</e-mail>
            </debtor>
            <!--Optional:-->
            <transferList>
              <!--1 to 5 repetitions:-->
              <transfer>
                <idTransfer>1</idTransfer>
                <transferAmount>10.00</transferAmount>
                <fiscalCodePA>77777777777</fiscalCodePA>
                <IBAN>IT45R0760103200000000001016</IBAN>
                <remittanceInformation>testPaGetPayment</remittanceInformation>
                <transferCategory>paGetPaymentTest</transferCategory>
              </transfer>
              <!--Optional:-->
              <metadata>
                <!--1 to 10 repetitions:-->
                <mapEntry>
                  <key>1</key>
                  <value>22</value>
                </mapEntry>
              </metadata>
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

  # Define primitive activatePaymentNotice
  Scenario: Define activatePaymentNotice
    Given initial XML activatePaymentNotice
	"""
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
					  xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
	  <soapenv:Header/>
	  <soapenv:Body>
		<nod:activatePaymentNoticeReq>
		  <idPSP>70000000001</idPSP>
		  <idBrokerPSP>70000000001</idBrokerPSP>
		  <idChannel>70000000001_01</idChannel>
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
          <idPSP>70000000001</idPSP>
          <idBrokerPSP>70000000001</idBrokerPSP>
          <idChannel>70000000001_01</idChannel>
          <password>pwdpwdpwd</password>
          <paymentToken></paymentToken>
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
    
  # Activate phase [PSRTV2_ACTV1_04]
  Scenario: Execute activatePaymentNotice request with lastPayment to 1
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    And the Define activatePaymentNotice scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    
  # Send Payment Outcome phase
  Scenario: Execute sendPaymentOutcome request with lastPayment to 1
    Given the Execute activatePaymentNotice request with lastPayment to 1 scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Activate phase [PSRTV2_ACTV1_04]
  Scenario: Execute activatePaymentNotice request with lastPayment to 0
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And lastPayment with 0 in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    And the Define activatePaymentNotice scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase
  Scenario: Execute sendPaymentOutcome request with lastPayment to 0
    Given the Execute activatePaymentNotice request with lastPayment to 0 scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Activate phase - 3 transfers in paGetPaymentV2 transferList and broadcast false for all stations [PSRTV2_ACTV1_05]
  Scenario: Execute activatePaymentNotice request with 3 transfers
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#   TODO with apiconfig: And broadcast with false in NODO4_CFG.PA_STAZIONE_PA for EC 77777777777, 90000000001 and 90000000002
	When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_05]
  Scenario: Execute sendPaymentOutcome request with 3 transfers
    Given the Execute activatePaymentNotice request with 3 transfers scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Send Payment Outcome phase [PSRTV2_ACTV1_14]
  Scenario: Execute sendPaymentOutcome request with 3 transfers and outcome KO
    Given the Execute activatePaymentNotice request with 3 transfers scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Activate phase - 4 transfers in paGetPaymentV2 transferList and broadcast false for all stations [PSRTV2_ACTV1_05]
  Scenario: Execute activatePaymentNotice request with 3 transfers with expiration time
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#   TODO with apiconfig: And broadcast with false in NODO4_CFG.PA_STAZIONE_PA for EC 77777777777, 90000000001 and 90000000002
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Mod3Cancel Phase - [PSRTV2_ACTV1_17]
  Scenario: Execute mod3Cancel poller with 3 transfers with expiration time
    Given the Execute activatePaymentNotice request with 3 transfers with expiration time scenario executed successfully
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    And check EC receives paSendRTV2 not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Activate phase - 5 transfers in paGetPaymentV2 transferList and broadcast true for secondary EC [PSRTV2_ACTV1_06]
  Scenario: Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#   TODO with apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201 (90000000001) and 13 (90000000002)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_06]
  Scenario: Execute sendPaymentOutcome request with 3 transfers and broadcast true for secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 1 the same fiscalCodePA of paGetPaymentV2
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPaymentV2

  # Send Payment Outcome phase [PSRTV2_ACTV1_15]
  Scenario: Execute sendPaymentOutcome request with 3 transfers and broadcast true for secondary EC and outcome KO
    Given the Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Activate phase - 6 transfers in paGetPaymentV2 transferList and broadcast true for secondary EC and expiration time [PSRTV2_ACTV1_18]
  Scenario: Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC with expirationTime
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>4.00</transferAmount><fiscalCodePA>90000000002</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#   TODO with apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201 (90000000001) and 13 (90000000002)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Mod3Cancel Phase - [PSRTV2_ACTV1_18]
  Scenario: Execute mod3Cancel poller with 3 transfers and broadcast true for secondary EC with expirationTime
    Given the Execute activatePaymentNotice request with 3 transfers and broadcast true for secondary EC with expirationTime scenario executed successfully
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    And check EC receives paSendRTV2 not properly with noticeNumber $activatePaymentNotice.noticeNumber

   # Activate phase - 2 transfers in paGetPaymentV2 transferList and broadcast true for 2 stations of secondary EC [PSRTV2_ACTV1_07]
  Scenario: Execute activatePaymentNotice request with 2 transfers and broadcast true for 2 stations of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And paymentAmount with 6.00 in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 11993 and 1201
	When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_07]
  Scenario: Execute sendPaymentOutcome request with 2 transfers and broadcast true for 2 stations of secondary EC
    Given the Execute activatePaymentNotice request with 2 transfers and broadcast true for 2 stations of secondary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 1 the same fiscalCodePA of paGetPaymentV2
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPaymentV2

  # Activate phase - 3 transfers in paGetPaymentV2 transferList (1 for primary EC and 2 for same secondary EC) and broadcast true for 1 station of secondary EC [PSRTV2_ACTV1_08]
  Scenario: Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>2.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>5.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201
	When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_08]
  Scenario: Execute sendPaymentOutcome request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 1 station of secondary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPaymentV2

  # Activate phase - 3 transfers in paGetPaymentV2 transferList (1 for primary EC and 2 for same secondary EC) and broadcast true for 2 stations of secondary EC [PSRTV2_ACTV1_09]
  Scenario: Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 2 stations of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>2.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>5.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    # TODO And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 11993 and 1201
	When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_09]
  Scenario: Execute sendPaymentOutcome request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 2 stations of secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers, 1 for primary EC and 2 for same secondary EC, and broadcast true for 2 stations of secondary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPaymentV2
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 3 the same fiscalCodePA of paGetPaymentV2

  # Activate phase - 3 transfers in paGetPaymentV2 transferList (2 for primary EC and 1 for secondary EC) and broadcast true for 1 station of secondary EC [PSRTV2_ACTV1_10]
  Scenario: Execute activatePaymentNotice request with 3 transfers, 2 for primary EC and 1 for secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>2.00</transferAmount><fiscalCodePA>77777777777</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer><transfer><idTransfer>2</idTransfer><transferAmount>3.00</transferAmount><fiscalCodePA>44444444444</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer><transfer><idTransfer>3</idTransfer><transferAmount>5.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>test</remittanceInformation><transferCategory>test</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    # TODO And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for OBJ_ID with 1201
	When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_10]
  Scenario: Execute sendPaymentOutcome request with 3 transfers, 2 for primary EC and 1 for secondary EC, and broadcast true for 1 station of secondary EC
    Given the Execute activatePaymentNotice request with 3 transfers, 2 for primary EC and 1 for secondary EC, and broadcast true for 1 station of secondary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode
    And check EC receives paSendRTV2 properly having in the transfer with idTransfer 2 the same fiscalCodePA of paGetPaymentV2

  # Activate phase - 1 transfer in paGetPaymentV2 transferList for secondary EC and broadcast false for all stations of secondary EC [PSRTV2_ACTV1_11]
  Scenario: Execute activatePaymentNotice request with 1 transfer for secondary EC and broadcast false for all stations of secondary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>10.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    # TODO apiconfig: And broadcast with false in NODO4_CFG.PA_STAZIONE_PA for EC 90000000001 (OBJ_ID = 1201)
	When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_11]
  Scenario: Execute sendPaymentOutcome request with 1 transfer for secondary EC and broadcast false for all stations of secondary EC
    Given the Execute activatePaymentNotice request with 1 transfer for secondary EC and broadcast false for all stations of secondary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Activate phase - 1 transfer in paGetPaymentV2 transferList and broadcast true for 1 station of primary EC [PSRTV2_ACTV1_12]
  Scenario: Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>10.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for EC 90000000001 (OBJ_ID = 1201)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Send Payment Outcome phase [PSRTV2_ACTV1_12]
  Scenario: Execute sendPaymentOutcome request with 1 transfer and broadcast true for 1 station of primary EC
    Given the Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # Send Payment Outcome phase [PSRTV2_ACTV1_13]
  Scenario: Execute sendPaymentOutcome request with 1 transfer and broadcast true for 1 station of primary EC and outcome KO
    Given the Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    And outcome with KO in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Activate phase - 1 transfer in paGetPaymentV2 transferList and broadcast true for 1 station of primary EC with expirationTime [PSRTV2_ACTV1_12]
  Scenario: Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC with expirationTime
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And expirationTime with 2000 in activatePaymentNotice
    And the Define paGetPaymentV2 scenario executed successfully
    And transferList with <transferList><transfer><idTransfer>1</idTransfer><transferAmount>10.00</transferAmount><fiscalCodePA>90000000001</fiscalCodePA><IBAN>IT45R0760103200000000001016</IBAN><remittanceInformation>testPaGetPayment</remittanceInformation><transferCategory>paGetPaymentTest</transferCategory></transfer></transferList> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
#    # TODO apiconfig: And broadcast with true in NODO4_CFG.PA_STAZIONE_PA for EC 90000000001 (OBJ_ID = 1201)
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Mod3Cancel Phase - [PSRTV2_ACTV1_16]
  Scenario: Execute mod3Cancel poller with 1 transfer and broadcast true for 1 station of primary EC with expirationTime
    Given the Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC with expirationTime scenario executed successfully
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
    And check EC receives paSendRTV2 not properly with noticeNumber $activatePaymentNotice.noticeNumber

  # Send Payment Outcome phase [PSRTV2_ACTV1_20]
  Scenario: Execute sendPaymentOutcome request with paSendRTV2 timeout response
    Given the Execute activatePaymentNotice request with 1 transfer and broadcast true for 1 station of primary EC scenario executed successfully
    And EC wait for 15 seconds at paSendRTV2 response
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And EC waits 60 seconds for expiration
    And check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
    And check EC receives paSendRTV2 properly having in the receipt $activatePaymentNotice.fiscalCode as fiscalcode

  # TODO problem to execute due to lack of mock functionalities - Send Payment Outcome phase [PSRTV2_ACTV1_28]
#  Scenario: paSendRTV2 OK response after timeout
#    Given initial XML paSendRTV2
#    """
#    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
#      <soapenv:Header/>
#      <soapenv:Body>
#        <paf:paSendRTV2Res>
#          <outcome>OK</outcome>
#        </paf:paSendRTV2Res>
#      </soapenv:Body>
#    </soapenv:Envelope>
#    """
#    And EC replies to nodo-dei-pagamenti with the paSendRTV2
#    When the Execute sendPaymentOutcome request with paSendRTV2 timeout response scenario executed successfully
#    Then check EC receives paSendRTV2 properly with noticeNumber $activatePaymentNotice.noticeNumber
#    And nodo-dei-pagamenti waits 60 seconds for expiration
#    And check EC receives paSendRTV2 not properly with noticeNumber $activatePaymentNotice.noticeNumber
#    # TODO check EC does not receive again the paSendRTV2 after 60 seconds


  # Activate phase [PSRTV2_ACTV1_30]
  Scenario: Execute activatePaymentNotice request with paGetPaymentV2 response returning a metadata existing in DB
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And metadata in transferList with               
    <metadata><mapEntry><key>CHIAVEOK</key><value>22</value></mapEntry></metadata> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And check activatePaymentNotice response not contain metadata
    
  # Send Payment Outcome phase
  Scenario: Execute sendPaymentOutcome request with paGetPaymentV2 response returning a metadata existing in DB
    Given the Execute activatePaymentNotice request with paGetPaymentV2 response returning a metadata existing in DB scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with $paGetPaymentV2.metadata as metadata
    
  # Activate phase [PSRTV2_ACTV1_31]
  Scenario: Execute activatePaymentNotice request with paGetPaymentV2 response returning a metadata not existing in DB
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And the Define activatePaymentNotice scenario executed successfully
    And the Define paGetPaymentV2 scenario executed successfully
    And metadata in transferList with               
    <metadata><mapEntry><key>CHIAVESCONOSCIUTA</key><value>22</value></mapEntry></metadata> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And check activatePaymentNotice response not contain metadata
    
  # Send Payment Outcome phase
  Scenario: Execute sendPaymentOutcome request with paGetPaymentV2 response returning a metadata not existing in DB
    Given the Execute activatePaymentNotice request with paGetPaymentV2 response returning a metadata not existing in DB scenario executed successfully
    And the Define sendPaymentOutcome scenario executed successfully
    And paymentToken with $activatePaymentNoticeResponse.paymentToken in sendPaymentOutcome
    When PSP sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    And check EC receives paSendRTV2 properly with $paGetPaymentV2.metadata as metadata