Feature: semantic checks OK for activatePaymentNoticeReq

  Background:
    Given systems up
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
			   <expirationTime>120000</expirationTime>
               <amount>10.00</amount>
			   <dueDate>2021-12-31</dueDate>
			   <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """ 

  Scenario: Check valid URL in WSDL namespace
    When PSP sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK

  # denylist value check: combination fiscalCode-idChannel-idPSP identifies a record in NODO4_CFG.DENYLIST table of nodo-dei-pagamenti database  [SEM_APNR_24]
  Scenario: Check outcome OK if combination psp-channel-pa in denylist
    Given fiscalCode with 77777777777 in activatePaymentNoticeReq
	And idBrokerPSP with 70000000002 in activatePaymentNoticeReq
    And idChannel with 70000000002_01 in activatePaymentNoticeReq
    When PSP sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK

  # idPsp in idempotencyKey (idempotencyKey: <idPSp>+"_"+<RANDOM STRING>) not in db  [SEM_APNR_17]
  Scenario: Check outcome OK on non-existent psp in idempotencyKey
    Given idempotencyKey with 70000000001_UNKNOWN890 in activatePaymentNoticeReq
    When PSP sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK

  # idPsp in idempotencyKey (idempotencyKey: <idPsp>+"_"+<RANDOM STRING>) with field ENABLED = N  [SEM_APNR_18]
  Scenario: Check outcome OK on non-existent psp in idempotencyKey
    Given idempotencyKey with 70000000001_NOTENABLED in activatePaymentNoticeReq
    When psp sends activatePaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is OK
