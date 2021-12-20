Feature:  block checks for verifyPaymentReq - position status in INSERTED (mod3Cancel poller) [Verify_blocco_11]

  Background:
    Given systems up
    And initial verifyPaymentNoticeReq soap-request
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
	 And EC new version

  # Verify Phase 1
  Scenario: Execute verifyPaymentNotice request
    When psp sends verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK
    

  # Activate Phase with expirationTime set to 2000
  Scenario: Execute activatePaymentNotice request
    Given valid activatePaymentNoticeReq soap-request
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
               <expirationTime>2000</expirationTime>
               <amount>120.00</amount>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """    
    When psp sends activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK
    And token exists and check
	
  # Mod3Cancel Phase
  Scenario: Execute mod3Cancel poller
    # Given the Activate Phase executed successfully
    # When expirationTime inserted in activatePaymentNoticeReq has passed and mod3Cancel poller has been triggered
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code response is 200

	
  # Verify Phase 2
  Scenario: Execute verifyPaymentNotice request with the same request as Verify Phase 1
	# Given the Mod3Cancel Phase executed successfully
    When psp sends verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK
