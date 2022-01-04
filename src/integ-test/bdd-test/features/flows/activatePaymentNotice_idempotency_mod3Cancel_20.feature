Feature:  idempotency check for activatePaymentNoticeReq - mod3Cancel [IDMP_ACT_20]

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
          <expirationTime>2000</expirationTime>
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

  # Mod3Cancel Phase
  Scenario: Execute mod3Cancel poller
    Given the Execute activatePaymentNotice request scenario executed successfully 
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
	
  # Activate Phase 2 - different amount
  Scenario: Execute activatePaymentNotice request with different amount
    Given the Execute mod3Cancel poller scenario executed successfully
	And amount with 8.00 in activatePaymentNotice  
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

