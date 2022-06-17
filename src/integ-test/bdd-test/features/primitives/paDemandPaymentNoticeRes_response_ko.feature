Feature: response checks for paDemandPaymentNoticeResponse - KO

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
             <idServizio>#idServizio#</idServizio>
             <datiSpecificiServizio>#xmlServizio_Base64Binary#</datiSpecificiServizio>
          </nod:demandPaymentNoticeRequest>
       </soapenv:Body>
    </soapenv:Envelope>
      """

  # element value check
  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given initial XML paDemandPaymentNoticeResponse
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
	   <soapenv:Body>
		  <paf:paDemandPaymentNoticeResponse>
			 <outcome>#outcome#</outcome>
             <fault>
                <faultCode>#faultCode#</faultCode>
                <faultString>#faultString#</faultString>
                <id>#id#</id>
                <description>#description#</description>
             </fault> 
		  </paf:paDemandPaymentNoticeResponse>
	   </soapenv:Body>
	  </soapenv:Envelope>
    """
    And <elem> with <value> in paDemandPaymentNotice
    And if outcome is KO set fault to None in paDemandPaymentNoticeResponse
    And EC replies to nodo-dei-pagamenti with the paDemandPaymentNoticeResponse
    When PSP sends SOAP demandPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of demandPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response
    Examples:
      | elem                              | value          | soapUI test  |
      | soapenv:Body                      | None           | TRES_PDPN_03 |
      | soapenv:Body                      | Empty          | TRES_PDPN_04 |
      | paf:paDemandPaymentNoticeResponse | None           | TRES_PDPN_05 |
      | paf:paDemandPaymentNoticeResponse | Empty          | TRES_PDPN_07 |
      | outcome                           | None           | TRES_PDPN_08 |
      | outcome                           | Empty          | TRES_PDPN_09 |
      | outcome                           | PP             | TRES_PDPN_10 |
      | outcome                           | KO             | TRES_PDPN_11 |


  Scenario Outline: Check PPT_STAZIONE_INT_PA_ERRORE_RESPONSE error on invalid body element value
    Given initial XML paDemandPaymentNoticeResponse
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
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
				   <!--Optional:-->
				   <dueDate>#dueDate#</dueDate>
				   <!--Optional:-->
				   <detailDescription>#detailDescription#</detailDescription>
				   <!--Optional:-->
					<allCCP>#allCCP#</allCCP>
				</paymentOptionDescription>
			 </paymentList>
			 <!--Optional:-->
			 <paymentDescription>#paymentDescription#</paymentDescription>
			 <!--Optional:-->
			 <fiscalCodePA>#fiscalCode#</fiscalCodePA>
			 <!--Optional:-->
			 <companyName>#fiscalCode#</companyName>
			 <!--Optional:-->
			 <officeName>#officeName#</officeName> 
		  </paf:paDemandPaymentNoticeResponse>
	   </soapenv:Body>
	  </soapenv:Envelope>
    """
    And <tag> with <value> in paDemandPaymentNotice
    And EC replies to nodo-dei-pagamenti with the paDemandPaymentNoticeResponse
    When psp sends SOAP demandPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of demandPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of demandPaymentNotice response
    Examples: 
      | tag                       | value                 | soapUI test |
      | paymentList               | None                  | TRES_PDPN_23|
      | paymentList               | Empty                 | TRES_PDPN_25|
      | paymentList               | Occurrences,2         | TRES_PDPN_26|
      | paymentOptionDescription  | None                  | TRES_PDPN_27|
      | paymentOptionDescription  | Empty                 | TRES_PDPN_28|
      | paymentOptionDescription  | Occurrences,2         | TRES_PDPN_29|
      | amount                    | None                  | TRES_PDPN_30|
      | amount                    | Empty                 | TRES_PDPN_31|
      | amount                    | 11,34                 | TRES_PDPN_32|
      | amount                    | 11.342                | TRES_PDPN_33|
      | amount                    | 1219087657.34         | TRES_PDPN_34|
      | amount                    | ciao                  | TRES_PDPN_35|
      | options                   | None                  | TRES_PDPN_36|
      | options                   | Empty                 | TRES_PDPN_37|
      | options                   | KK                    | TRES_PDPN_38|
      | dueDate                   | Empty                 | TRES_PDPN_40|
      | dueDate                   | 20220613              | TRES_PDPN_41|
      | dueDate                   | 12-09-22              | TRES_PDPN_41|
      | dueDate                   | 12-08-2022T12:00:678  | TRES_PDPN_41|
      | detailDescription         | Empty                 | TRES_PDPN_43|
      | detailDescription         | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE        | TRES_PDPN_43|
      | allCCP                    | None                  | TRES_PDPN_45|
      | allCCP                    | Empty                 | TRES_PDPN_46|
      | allCCP                    | 3                     | TRES_PDPN_47|
      | paymentDescription        | None                  | TRES_PDPN_48|
      | paymentDescription        | Empty                 | TRES_PDPN_49|
      | paymentDescription        | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE        | TRES_PDPN_50|
      | fiscalCodePA              | None                  | TRES_PDPN_51|
      | fiscalCodePA              | Empty                 | TRES_PDPN_52|
      | fiscalCodePA              | 123456789012          | TRES_PDPN_53|
      | fiscalCodePA              | 12345jh%lk9           | TRES_PDPN_54|
      | companyName               | None                  | TRES_PDPN_55|
      | companyName               | Empty                 | TRES_PDPN_56|
      | companyName               | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE        | TRES_PDPN_57|
      | officeName                | Empty                 | TRES_PDPN_59|
      | officeName                | test di prova per una lunghezza superiore a 141 caratteri alfanumerici, per verificare che il nodo risponda PPT_STAZIONE_INT_PA_ERRORE_RESPONSE        | TRES_PDPN_60|

      
  # TRES_PDPN_61
  Scenario : Check extended faultBean present in demandPaymentNotice response
    Given initial XML paDemandPaymentNoticeResponse
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
	   <soapenv:Body>
		  <paf:paDemandPaymentNoticeResponse>
			 <outcome>KO</outcome>
             <fault>
                <faultCode>#faultCode#</faultCode>
                <faultString>#faultString#</faultString>
                <id>#id#</id>
                <description>#description#</description>
             </fault> 
		  </paf:paDemandPaymentNoticeResponse>
	   </soapenv:Body>
	  </soapenv:Envelope>
    """
    And nodo-dei-pagamenti has intermediari_psp parameter FAULT_BEAN_ESTESO set to Y
    And EC replies to nodo-dei-pagamenti with the paDemandPaymentNoticeResponse
    When psp sends SOAP demandPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of demandPaymentNotice response
    And fields originalFaultCode, originalFaultString, originalDescription are present in faultBean of demandPaymentNotice response
    
  Scenario : Check extended faultBean not present in demandPaymentNotice response
    Given initial XML paDemandPaymentNoticeResponse
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
	   <soapenv:Body>
		  <paf:paDemandPaymentNoticeResponse>
			 <outcome>KO</outcome>
             <fault>
                <faultCode>#faultCode#</faultCode>
                <faultString>#faultString#</faultString>
                <id>#id#</id>
                <description>#description#</description>
             </fault> 
		  </paf:paDemandPaymentNoticeResponse>
	   </soapenv:Body>
	  </soapenv:Envelope>
    """
    And nodo-dei-pagamenti has intermediari_psp parameter FAULT_BEAN_ESTESO set to N
    And EC replies to nodo-dei-pagamenti with the paDemandPaymentNoticeResponse
    When psp sends SOAP demandPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of demandPaymentNotice response
    And fields originalFaultCode, originalFaultString, originalDescription are not present in faultBean of demandPaymentNotice response