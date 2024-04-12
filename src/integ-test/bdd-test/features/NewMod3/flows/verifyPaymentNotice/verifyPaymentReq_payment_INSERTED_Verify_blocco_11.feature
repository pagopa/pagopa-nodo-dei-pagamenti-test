Feature:  block checks for verifyPaymentReq - position status in INSERTED (mod3CancelV2 poller) [Verify_blocco_11] 1362

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>#psp#</idPSP>
               <idBrokerPSP>#psp#</idBrokerPSP>
               <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
	 


  # Verify Phase 1
  Scenario: Execute verifyPaymentNotice request
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
    

  # Activate Phase with expirationTime set to 2000
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
               <expirationTime>2000</expirationTime>
               <amount>120.00</amount>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And paymentToken exists of activatePaymentNotice response
    And paymentToken length is less than 36 of activatePaymentNotice response


  # mod3CancelV2 Phase
  Scenario: Execute mod3CancelV2 poller
    Given the Execute activatePaymentNotice request scenario executed successfully
    # When expirationTime inserted in activatePaymentNoticeReq has passed and mod3CancelV2 poller has been triggered
    When job mod3CancelV2 triggered after 3 seconds
    Then verify the HTTP status code of mod3CancelV2 response is 200

	
  # Verify Phase 2
  @runnable
  Scenario: Execute verifyPaymentNotice request with the same request as Verify Phase 1
    Given the Execute mod3CancelV2 poller scenario executed successfully
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

