Feature:  semantic check for activatePaymentNoticeReq regarding idempotency - same idempotency OK [SEM_APNR_19]

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
#    And nodo-dei-pagamenti has parameter useIdempotency set to true in NODO4_CFG.CONFIGURATION_KEYS

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    
  # Activate Phase 2 
  Scenario: Execute activatePaymentNotice request with same request as Activate Phase 1 before idempotencyKey expires
    Given the current timestamp
    And the Execute activatePaymentNotice request scenario executed successfully
    And idempotencyKey is not expired yet
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
	And verify the paymentToken of last activatePaymentNotice response is equal to the paymementToken of the first activatePaymentNotice response
