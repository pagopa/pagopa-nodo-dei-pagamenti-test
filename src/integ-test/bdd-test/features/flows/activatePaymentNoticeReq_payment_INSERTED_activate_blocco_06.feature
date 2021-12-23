Feature:  block check for activatePaymentNoticeReq - position status in INSERTED (mod3Cancel) [Activate_blocco_06]

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
			   <expirationTime>2000</expirationTime>
			   <dueDate>2021-12-31</dueDate>
			   <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """ 
	And PA new version

  # Activate Phase 1  with expirationTime set to 2000
  Scenario: Execute activatePaymentNotice request
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK

  # Mod3Cancel Phase
  Scenario: Execute mod3Cancel poller
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code response is 200
	
  # Activate Phase 2
  Scenario: Execute activatePaymentNotice request with same request as Activate Phase 1 except for idempotencyKey
    Given same activatePaymentNotice soap-request as Activate Phase 1 except for idempotencyKey
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK