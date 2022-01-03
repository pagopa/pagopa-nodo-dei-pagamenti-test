Feature:  semantic check for activatePaymentNoticeReq regarding idempotency - not PPT_ERRORE_IDEMPOTENZA [SEM_APNR_20.1]

  Background:
    Given systems up
    And initial XML activatePaymentNotice
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
			   <expirationTime>120000</expirationTime>
               <amount>10.00</amount>
			   <dueDate>2021-12-31</dueDate>
			   <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And nodo-dei-pagamenti has config parameter useIdempotency set to false

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Activate Phase 2.1
  Scenario Outline: Execute activatePaymentNotice request different from Activate Phase 1 with same idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
	And <elem> with <value> in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
	And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
    Examples:
      | elem                 | value                    | soapUI test          |
	  | amount               | 12.00                    | amount diverso       |
	  | dueDate              | 2021-10-31               | dueDate diversa      |
	  | paymentNote          | altraCausale             | paymentNote diverso  |
      | dueDate              | None                     | dueDateAssente       |
      | expirationTime       | None                     | expirationTimeAssente|
	  | paymentNote          | None                     | paymentNoteAssente   |
