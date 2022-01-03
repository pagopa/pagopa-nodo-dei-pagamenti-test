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

   # Activate Phase 2
  Scenario: Execute activatePaymentNotice request different from Activate Phase 1 with same idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
    And random noticeNumber in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    
  # Activate Phase 2
  # TODO modify with api-config
  # PA_STAZIONE_PA with OBJ_ID = 5266 to set:
  #   - aux_digit: 3
  #   - segregazione: 2
  # STAZIONI with OBJ_ID = 135 to set:
  #   - ip: localhost
  #   - port: 8089
  #   - servizio_pof: servizi/PagamentiTelematiciRPT
  #   - version: 2
  #   - servizio_nmp: Y
  #   -
  Scenario: Execute activatePaymentNotice request different from Activate Phase 1 with same idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
	And fiscalCode with 44444444444 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
