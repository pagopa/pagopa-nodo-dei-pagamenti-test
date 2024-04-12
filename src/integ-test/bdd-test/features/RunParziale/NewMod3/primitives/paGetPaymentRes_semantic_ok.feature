Feature: Semantic checks for paGetPaymentRes - OK 1536

  Background:
    Given systems up
    And initial XML activatePaymentNotice
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
                      <fiscalCode>#creditor_institution_code#</fiscalCode>
                      <noticeNumber>#notice_number#</noticeNumber>
                  </qrCode>
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """
    

  @ALL
  Scenario Outline: Check outcome OK on amount or fiscalCodePA of paGetPaymentRes different from paGetPaymentReq
    Given EC replies to nodo-dei-pagamenti with the paGetPayment
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
	  And <elem> with <tagvalue> in paGetPayment
	  And <elem1> with <tagvalue> in paGetPayment
	  When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
	  Then check outcome is OK of activatePaymentNotice response
	  Examples:
		  | elem          | elem1          | tagvalue    | soapUI test |
		  | paymentAmount | transferAmount | 8.00        | SEM_PGPR_01 |
		  | fiscalCodePA  | -              | 44444444444 | SEM_PGPR_02 |