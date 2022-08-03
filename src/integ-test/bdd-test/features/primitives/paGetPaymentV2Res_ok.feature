Feature: response checks for paGetPaymentResV2 - OK

	Background:
		Given systems up
		And initial XML activatePaymentNoticeV2
		"""
		<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
			xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
			<soapenv:Header/>
			<soapenv:Body>
				<nod:activatePaymentNoticeV2Request>
					<idPSP>70000000001</idPSP>
					<idBrokerPSP>70000000001</idBrokerPSP>
					<idChannel>70000000001_01</idChannel>
					<password>pwdpwdpwd</password>
					<qrCode>
						<fiscalCode>#creditor_institution_code#</fiscalCode>
						<noticeNumber>#notice_number#</noticeNumber>
					</qrCode>
					<amount>10.00</amount>
					<paymentNote>causale</paymentNote>
				</nod:activatePaymentNoticeV2Request>
			</soapenv:Body>
		</soapenv:Envelope>
		"""
		And EC new version  
        And stazione with versione_primitive = 2 
 
	Scenario Outline: Check paGetPaymentV2 response with missing optional fields
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
							<e-mail>paGetPayment@test.it</e-mail>
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
		And <elem> with <tagvalue> in paGetPaymentV2
		And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
		When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
		Then check outcome is OK of activatePaymentNoticeV2 response
		Examples:
		  | elem                  | tagvalue   | soapUI test     |
		  | soapenv:Header        | None       | RES_PGPR_V2_01  |
		  | retentionDate         | None       | RES_PGPR_V2_27  |
		  | lastPayment           | None       | RES_PGPR_V2_30  |
		  | companyName           | None       | RES_PGPR_V2_36  |
		  | officeName            | None       | RES_PGPR_V2_39  |
		  | streetName            | None       | RES_PGPR_V2_57  |
		  | civicNumber           | None       | RES_PGPR_V2_60  |
		  | postalCode            | None       | RES_PGPR_V2_63  |
		  | city                  | None       | RES_PGPR_V2_66  |
		  | stateProvinceRegion   | None       | RES_PGPR_V2_69  |
		  | country               | None       | RES_PGPR_V2_72  |
		  | e-mail                | None       | RES_PGPR_V2_76  |
		  | transfer.metadata     | None       | RES_PGPR_V2_114 |
          | metadata              | None       | RES_PGPR_V2_122 |


  Scenario Outline: Check outcome OK on amount or fiscalCodePA of paGetPaymentV2Res different from paGetPaymentV2Req
    Given EC replies to nodo-dei-pagamenti with the paGetPaymentV2
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
						  <fiscalCodePA>77777777777</fiscalCodePA>
						  <IBAN>IT45R0760103200000000001016</IBAN>
						  <remittanceInformation>testPaGetPayment</remittanceInformation>
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
			  </paf:paGetPaymentRes>
		  </soapenv:Body>
	</soapenv:Envelope>
    """
	  And <elem> with <tagvalue> in paGetPaymentV2
	  And <elem1> with <tagvalue> in paGetPaymentV2
	  When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
	  Then check outcome is OK of activatePaymentNoticeV2 response
	  Examples:
		  | elem          | elem1          | tagvalue    | soapUI test     |
		  | paymentAmount | transferAmount | 8.00        | RES_PGPR_V2_129 |
		  | fiscalCodePA  | -              | 66666666666 | RES_PGPR_V2_130 |