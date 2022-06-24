Feature: response checks for paDemandPaymentNoticeResponse - OK

  Background:
    Given systems up
    And initial XML demandPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <nod:demandPaymentNoticeRequest>
             <idPSP>70000000001</idPSP>
             <idBrokerPSP>70000000001</idBrokerPSP>
             <idChannel>70000000001_01</idChannel>
             <password>pwdpwdpwd</password>
             <idSoggettoServizio>#idSoggettoServizio#</idSoggettoServizio>
             <datiSpecificiServizio>#xmlServizio_Base64Binary#</datiSpecificiServizio>
          </nod:demandPaymentNoticeRequest>
       </soapenv:Body>
    </soapenv:Envelope>
      """
    
  Scenario Outline: Check paDemandPaymentNoticeResponse response with missing optional fields
    Given initial XML paDemandPaymentNoticeResponse
    """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
       <soapenv:Header/>
	   <soapenv:Body>
		  <paf:paDemandPaymentNoticeResponse>
			 <outcome>#outcome#</outcome>
			 <qrCode>
				<fiscalCode>#fiscalCode#</fiscalCode>
				<noticeNumber>#noticeNumber#</noticeNumber>
			 </qrCode>
			 <paymentList>
				<paymentOptionDescription>
				   <amount>#amount#</amount>
				   <options>#options#</options>
				   <dueDate>#dueDate#</dueDate>
				   <detailDescription>#detailDescription#</detailDescription>
					<allCCP>#allCCP#</allCCP>
				</paymentOptionDescription>
			 </paymentList>
			 <paymentDescription>#paymentDescription#</paymentDescription>
			 <fiscalCodePA>#fiscalCode#</fiscalCodePA>
			 <companyName>#fiscalCode#</companyName>
			 <officeName>#officeName#</officeName> 
		  </paf:paDemandPaymentNoticeResponse>
	   </soapenv:Body>
	  </soapenv:Envelope>
    """
    And <elem> with <value> in paDemandPaymentNotice
    And EC replies to nodo-dei-pagamenti with the paDemandPaymentNoticeResponse
    When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of demandPaymentNotice response
    Examples:
      | elem               | value  | soapUI test  |
      | soapenv:Header     | None   | TRES_PDPN_01 |
      | soapenv:Header     | Empty  | TRES_PDPN_02 |      
      | dueDate            | None   | TRES_PDPN_39 |
      | detailDescription  | None   | TRES_PDPN_42 |
      | officeName         | None   | TRES_PDPN_58 |
