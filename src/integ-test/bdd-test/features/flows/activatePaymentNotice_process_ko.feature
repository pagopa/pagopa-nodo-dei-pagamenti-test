Feature: process check for activatePaymentNotice - KO [PRO_APNR_06]

  Background:
    Given systems up
    And initial activatePaymentNoticeReq soap-request
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:activatePaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <idempotencyKey>#idempotency_key#</idempotencyKey>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
               <amount>10.00</amount>
			   <expirationTime>120000</expirationTime>
			   <dueDate>2021-12-31</dueDate>
			   <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """ 
	And PA new version

  # KO from PA
  Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error when paGetPaymentRes contains KO outcome
    Given EC replies to nodo-dei-pagamenti with the following paGetPaymentRes
    """
	<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header/>
      <soapenv:Body>
        <paf:paGetPaymentRes>
         <outcome>KO</outcome>
         <fault>
            <faultCode>PAA_SINTASSI_EXTRAXSD</faultCode>
            <faultString>errore sintattico PA</faultString>
            <id>1</id>
            <description>Errore sintattico emesso dalla PA</description>
         </fault>
        </paf:paGetPaymentRes>
      </soapenv:Body>
    </soapenv:Envelope>
	"""
    When PSP sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA