Feature:  block check for activatePaymentNoticeReq - position status in PAYING [Activate_blocco_01]

  Background:
    Given systems up
    And EC new version

  Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
          xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # Activate Phase 2
  Scenario: Execute activatePaymentNotice request with same request as Activate Phase 1 except for idempotencyKey
    Given the Execute activatePaymentNotice request scenario executed successfully
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
                  <fiscalCode>$activatePaymentNotice.fiscalCode</fiscalCode>
                  <noticeNumber>$activatePaymentNotice.noticeNumber</noticeNumber>
               </qrCode>
               <expirationTime>2000</expirationTime>
               <amount>120.00</amount>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """       
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response
    And check faultCode is PPT_PAGAMENTO_IN_CORSO of activatePaymentNotice response
