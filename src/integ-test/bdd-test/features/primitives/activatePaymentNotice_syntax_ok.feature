Feature:  syntax checks OK for activatePaymentNoticeReq

  Background:
    Given systems up
    And valid activatePaymentNoticeReq soap-request
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

  Scenario: Check valid URL in WSDL namespace
    # Given a valid WSDL
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK
	
  # idempotencyKey not present  [SIN_APNR_18]
  Scenario: Check outcome OK without idempotencyKey
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti without optional field idempotencyKey
    Then check outcome is OK
	

  # expirationTime not present  [SIN_APNR_35]
  Scenario: Check outcome OK without expirationTime
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti without optional field expirationTime
    Then check outcome is OK

	
  # amount not present  [SIN_APNR_39]
  Scenario: Check outcome OK without expirationTime
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti without optional field expirationTime
    Then check outcome is OK
	
	
  # dueDate not present  [SIN_APNR_44]
  Scenario: Check outcome OK without dueDate
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti without optional field dueDate
    Then check outcome is OK
	
	
  # paymentNote not present  [SIN_APNR_47]
  Scenario: Check outcome OK without paymentNote
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti without optional field paymentNote
    Then check outcome is OK