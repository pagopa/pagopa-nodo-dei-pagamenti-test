Feature:  block checks for verifyPaymentReq - position status in PAID after retry with expired token [Verify_blocco_12]

  Background:
    Given systems up
	And PA new version
    And valid verifyPaymentNoticeReq soap-request
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
                  <noticeNumber>302094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """

  # Verify Phase 1
  Scenario: Execute verifyPaymentNotice request
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK
    

  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    Given the Verify Phase 1 executed successfully
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti on the same position of verifyPaymentNotice, with request field <expirationTime> set to a short time (e.g. 2000ms)
    Then check outcome is OK
    And payment token exists

    
  # Mod3Cancel Phase
  Scenario: Execute mod3Cancel poller
    Given the Activate Phase executed successfully
    When expirationTime inserted in activatePaymentNoticeReq has passed and mod3Cancel poller has been triggered
    Then verify the HTTP status code response is 200
    
	
  # Payment Outcome Phase
  Scenario: Execute sendPaymentOutcome request
    Given the Mod3Cancel Phase executed successfully
    When psp sends sendPaymentOutcomeReq to nodo-dei-pagamenti using the token of the activate phase, and with request field <outcome> = OK
    Then check outcome is KO
    And check faultCode is PPT_TOKEN_SCADUTO

	
  # Verify Phase 2
  Scenario: Execute verifyPaymentNotice request with the same request as Verify Phase 1, immediately after the Payment Outcome Phase
	Given the Payment Outcome Phase executed successfully
    When psp sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
	And check faultCode is PPT_PAGAMENTO_DUPLICATO