Feature:  idempotency check for activatePaymentNoticeReq - different psp in second activate [IDMP_ACT_16.1]

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
    And nodo-dei-pagamenti has config parameter useIdempotency set to true

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    
  # Activate Phase 2 
  Scenario: Execute activatePaymentNotice request with different idPSP-idBrokerPSP-idChannel before idempotencyKey expires
    Given the Execute activatePaymentNotice request scenario executed successfully
	And idPSP with 40000000001 in activatePaymentNotice
	And idBrokerPSP with 40000000001 in activatePaymentNotice
	And idChannel with 40000000001_01 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
	And check faultCode is PPT_PAGAMENTO_IN_CORSO

