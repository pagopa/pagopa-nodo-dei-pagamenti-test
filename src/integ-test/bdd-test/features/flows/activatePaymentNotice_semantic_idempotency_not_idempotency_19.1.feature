Feature:  semantic check for activatePaymentNoticeReq regarding idempotency - not use idempotency [SEM_APNR_19.1]

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
    And nodo-dei-pagamenti is configured to use idempotency parameter

  # Activate Phase 1
  Scenario: Execute activatePaymentNotice request
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    
  # Activate Phase 2 
  Scenario: Execute activatePaymentNotice request with same request as Activate Phase 1
    Given the Execute activatePaymentNotice request scenario executed successfully
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
	And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
