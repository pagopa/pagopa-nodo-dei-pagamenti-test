Feature:  semantic check for activatePaymentNoticeReq regarding idempotency - expired idempotency default key [SEM_APNR_22]

  Background:
    Given systems up
	And parameter useIdempotency = true in NODO4_CFG.CONFIGURATION_KEYS
	And default_idempotency_key_validity_minutes with 1 in NODO4_CFG.CONFIGURATION_KEYS
	And default_token_duration_validity_millis with 1800000 in NODO4_CFG.CONFIGURATION_KEYS
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

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK
    
  # Activate Phase 2
  Scenario: Execute activatePaymentNotice request with same request as Activate Phase 1, right after default_idempotency_key_validity_minutes has passed
    Given activatePaymentNotice soap-request with same request as Activate Phase 1
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti, right after default_idempotency_key_validity_minutes has passed
    Then check outcome is KO
	And check faultCode is PPT_PAGAMENTO_IN_CORSO
