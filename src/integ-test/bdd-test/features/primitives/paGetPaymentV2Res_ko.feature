Feature: response checks for paGetPaymentV2Res - KO

Background:
  Given systems up
  And initial XML activatePaymentNoticeV2
  """
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
  
  # element value check
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given initial XML paGetPaymentV2
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <paf:paGetPaymentV2Response>
             <outcome>#outcome#</outcome>
             <fault>
                <faultCode>#faultCode#</faultCode>
                <faultString>#faultString#</faultString>
                <id>#id#</id>
                <description>#description#</description>
             </fault>
          </paf:paGetPaymentV2Response>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    And <elem> with <tagvalue> in paGetPaymentV2
    And if outcome is KO set fault to None in paGetPayment
    And EC replies to nodo-dei-pagamenti with the paGetPayment
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response
    Examples:
      | elem                       | tagvalue    | soapUI test    |
      | soapenv:Body               | Empty       | RES_PGPR_V2_02 |
      | soapenv:Body               | None        | RES_PGPR_V2_03 |
      | paf:paGetPaymentV2Response | None        | RES_PGPR_V2_05 |
      | paf:paGetPaymentV2Response | Empty       | RES_PGPR_V2_06 |
      | outcome                    | None        | RES_PGPR_V2_07 |
      | outcome                    | Empty       | RES_PGPR_V2_08 |
      | outcome                    | PP          | RES_PGPR_V2_09 |
      | outcome                    | KO          | RES_PGPR_V2_10 |


  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given initial XML paGetPaymentV2
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
       <soapenv:Header />
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
    And <tag> with <tagvalue> in paGetPaymentV2
    And EC replies to nodo-dei-pagamenti with the paGetPaymentV2
    When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
    Examples:
      | tag                         | tagvalue                                                                                                                                                                                                                                                          | soapUI test   |
      | data                        | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_13   |
      | data                        | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_12   |
      | creditorReferenceId         | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_14   |
      | creditorReferenceId         | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_15   |
      | creditorReferenceId         | test di prova per una lunghezza>35ch                                                                                                                                                                                                                                                    | RES_PGPR_V2_16   |
      | paymentAmount               | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_17   |
      | paymentAmount               | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_18   |
      | paymentAmount               | 0.00                                                                                                                                                                                                                                                              | RES_PGPR_V2_19   |
      | paymentAmount               | 11,34                                                                                                                                                                                                                                                             | RES_PGPR_V2_20   |
      | paymentAmount               | 11.342                                                                                                                                                                                                                                                            | RES_PGPR_V2_21   |
      | paymentAmount               | 11.3                                                                                                                                                                                                                                                              | RES_PGPR_V2_22   |
      | paymentAmount               | 1000000000.00                                                                                                                                                                                                                                                     | RES_PGPR_V2_23   |
      | dueDate                     | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_24   |
      | dueDate                     | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_25   |
      | dueDate                     | 12-28-2022                                                                                                                                                                                                                                                        | RES_PGPR_V2_26   |
      | dueDate                     | 12-09-22                                                                                                                                                                                                                                                          | RES_PGPR_V2_26   |
      | dueDate                     | 12-08-2022T12:00:678                                                                                                                                                                                                                                                            | RES_PGPR_V2_26   |
      | retentionDate               | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_28   |
      | retentionDate               | 12-28-2022                                                                                                                                                                                                                                                        | RES_PGPR_V2_28   |
      | retentionDate               | 12-09-22                                                                                                                                                                                                                                                          | RES_PGPR_V2_29   |
      | retentionDate               | 12-08-2022T12:00:678                                                                                                                                                                                                                                                             | RES_PGPR_V2_29   |
      | lastPayment                 | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_31   |
      | lastPayment                 | 2                                                                                                                                                                                                                                                                 | RES_PGPR_V2_32   |
      | description                 | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_33   |
      | description                 | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_34   |
      | description                 | test di prova per una lunghezza superiore 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                   | RES_PGPR_V2_35   |
      | companyName                 | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_37   |
      | companyName                 | test di prova per una lunghezza superiore 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                   | RES_PGPR_V2_38   |
      | officeName                  | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_40   |
      | officeName                  | test di prova per una lunghezza superiore 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                   | RES_PGPR_V2_41   |
      | debtor                      | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_42   |
      | debtor                      | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_43   |
      | uniqueIdentifier            | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_45   |
      | uniqueIdentifier            | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_46   |
      | entityUniqueIdentifierType  | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_48  |
      | entityUniqueIdentifierType  | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_49  |
      | entityUniqueIdentifierType  | H                                                                                                                                                                                                                                                                 | RES_PGPR_V2_50   |
      | entityUniqueIdentifierValue | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_51   |
      | entityUniqueIdentifierValue | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_52   |
      | entityUniqueIdentifierValue | lunghezza >16char                                                                                                                                                                                                                                                           | RES_PGPR_V2_53   |
      | fullName                    | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_54   |
      | fullName                    | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_55   |
      | fullName                    | test di prova per una lunghezza superiore a 70 caratteri alfanumerici ,                                                                                                                                                                                   | RES_PGPR_V2_56   |
      | streetName                  | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_58   |
      | streetName                  | test di prova per una lunghezza superiore a 70 caratteri alfanumerici ,                                                                                                                                                                                   | RES_PGPR_V2_59   |
      | civicNumber                 | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_61   |
      | civicNumber                 | lunghezza >16char                                                                                                                                                                                                                                                           | RES_PGPR_V2_62   |
      | postalCode                  | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_64   |
      | postalCode                  | lunghezza >16char                                                                                                                                                                                                                                                           | RES_PGPR_V2_65   |
      | city                        | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_67   |
      | city                        | test di prova per una lunghez>35char                                                                                                                                                                                                                                                    | RES_PGPR_V2_68   |
      | stateProvinceRegion         | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_70   |
      | stateProvinceRegion         | test di prova per una lunghez>35char                                                                                                                                                                                                                                                    | RES_PGPR_V2_71   |
      | country                     | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_73   |
      | country                     | ITA                                                                                                                                                                                                                                                               | RES_PGPR_V2_74   |
      | country                     | it                                                                                                                                                                                                                                                                | RES_PGPR_V2_75   |
      | e-mail                      | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_77   |
      | e-mail                      | prova%gmail.com                                                                                                                                                                                                                                                   | RES_PGPR_V2_78   |
      | e-mail                      | provaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovaprovapr@gmail.com | RES_PGPR_V2_79   |
      | transferList                | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_80   |
      | transferList                | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_81   |
      | transfer                    | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_83   |
      | transfer                    | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_84   |
      | transfer                    | Occurrences,6                                                                                                                                                                                                                                                     | RES_PGPR_V2_85   |
      | idTransfer                  | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_86   |
      | idTransfer                  | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_87   |
      | idTransfer                  | 11                                                                                                                                                                                                                                                                | RES_PGPR_V2_88   |
      | idTransfer                  | 6                                                                                                                                                                                                                                                                 | RES_PGPR_V2_89   |
      | idTransfer                  | a                                                                                                                                                                                                                                                                 | RES_PGPR_V2_90   |
      | transferAmount              | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_91   |
      | transferAmount              | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_92   |
      | transferAmount              | 0.00                                                                                                                                                                                                                                                              | RES_PGPR_V2_93  |
      | transferAmount              | 11,34                                                                                                                                                                                                                                                             | RES_PGPR_V2_94   |
      | transferAmount              | 11.342                                                                                                                                                                                                                                                            | RES_PGPR_V2_95   |
      | transferAmount              | 11.3                                                                                                                                                                                                                                                              | RES_PGPR_V2_96   |
      | transferAmount              | 1000000000.00                                                                                                                                                                                                                                                     | RES_PGPR_V2_97   |
      | transferAmount              | 8.00                                                                                                                                                                                                                                                              | RES_PGPR_V2_98   |
      | fiscalCodePA                | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_100  |
      | fiscalCodePA                | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_101  |
      | fiscalCodePA                | 777777777777                                                                                                                                                                                                                                                      | RES_PGPR_V2_102  |
      | fiscalCodePA                | 7777777777a                                                                                                                                                                                                                                                       | RES_PGPR_V2_103  |
      | IBAN                        | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_104  |
      | IBAN                        | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_105  |
      | IBAN                        | test di prova per una lunghezza>35ch                                                                                                                                                                                                                                                    | RES_PGPR_V2_106  |
      | remittanceInformation       | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_107  |
      | remittanceInformation       | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_108  |
      | remittanceInformation       | test di prova per una lunghezza superiore 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                                                                                                 | RES_PGPR_V2_109  |
      | transferCategory            | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_110  |
      | transferCategory            | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_111  |
      | transferCategory            | test di prova per una lunghezza superiore 140 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE                                                                                                                                                 | RES_PGPR_V2_112  |
      | transfer.metadata           | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_113  |
      | transfer.mapEntry           | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_116  |
      | transfer.mapEntry           | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_117  |
      | transfer.mapEntry           | Occurrences,11                                                                                                                                                                                                                                                    | RES_PGPR_V2_118  |
      | transfer.key                | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_119  |
      | transfer.value              | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_120  |
      | metadata                    | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_121  |
      | mapEntry                    | Empty                                                                                                                                                                                                                                                             | RES_PGPR_V2_124  |
      | mapEntry                    | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_125  |
      | mapEntry                    | Occurrences,11                                                                                                                                                                                                                                                    | RES_PGPR_V2_126  |
      | key                         | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_127  |
      | value                       | None                                                                                                                                                                                                                                                              | RES_PGPR_V2_128  |
      
 
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on non-existent or disabled body element value
    Given EC replies to nodo-dei-pagamenti with the paGetPaymentV2
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
	When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response
	    Examples:
      | elem              | tagvalue                       | soapUI test      |
      | fiscalCodePA      | 10000000000                    | RES_PGPR_V2_131  |
      | fiscalCodePA      | 11111122222                    | RES_PGPR_V2_132  |
      | IBAN              | IT45R0760103200000000001015    | RES_PGPR_V2_133  |
      | IBAN              | IT45R0760103200666666666666    | RES_PGPR_V2_134  |	    

      
  #RES_PGPR_V2_99
  Scenario: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on paymentAmount different from transferAmount sum 
    Given EC replies to nodo-dei-pagamenti with the paGetPaymentV2
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
					   </transfer
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
			  </paf:paGetPaymentV2Response>
		  </soapenv:Body>
	</soapenv:Envelope>
    """
	When PSP sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNoticeV2 response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNoticeV2 response