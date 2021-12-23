Feature:  semantic check for activatePaymentNoticeReq regarding idempotency - PPT_ERRORE_IDEMPOTENZA [SEM_APNR_20]

  Background:
    Given systems up
	And parameter useIdempotency = true in NODO4_CFG.CONFIGURATION_KEYS
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
  Scenario Outcome: Execute activatePaymentNotice request different from Activate Phase 1 with same idempotencyKey, before idempotencyKey expires
    Given activatePaymentNotice soap-request with same idempotencyKey as Activate Phase 1
	And <elem> with <value> in activatePaymentNoticeReq
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti before idempotencyKey expires
    Then check outcome is KO
	And check faultCode is PPT_ERRORE_IDEMPOTENZA
    Examples:
      | elem                 | value                    | soapUI test          |
      | noticeNumber         | 311456789012345678       | noticeNumber diverso |
      | fiscalCode           | 40000000001              | fiscalCodePA diverso |
	  | amount               | 12.00                    | amount diverso       |
	  | dueDate              | 2021-10-31               | dueDate diversa      |
	  | paymentNote          | altraCausale             | paymentNote diverso  |
      | noticeNumber         | None                     | dueDateAssente       |
      | noticeNumber         | None                     | expirationTimeAssente|
	  | noticeNumber         | None                     | paymentNoteAssente   |