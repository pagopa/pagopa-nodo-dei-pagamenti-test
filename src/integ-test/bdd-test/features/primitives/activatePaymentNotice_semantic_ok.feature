Feature: semantic checks OK for activatePaymentNotice

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

  Scenario: Check valid URL in WSDL namespace
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # denylist value check: combination fiscalCode-idChannel-idPSP identifies a record in NODO4_CFG.DENYLIST table of nodo-dei-pagamenti database  [SEM_APNR_24]
  Scenario: Check outcome OK if combination psp-channel-pa in denylist
    Given fiscalCode with 77777777777 in activatePaymentNotice
	And idBrokerPSP with 70000000002 in activatePaymentNotice
    And idChannel with 70000000002_01 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # idPsp in idempotencyKey (idempotencyKey: <idPSp>+"_"+<RANDOM STRING>) not in db  [SEM_APNR_17]
  Scenario: Check outcome OK on non-existent psp in idempotencyKey
    Given idempotencyKey with 00088877799_UNKNOWN890 in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

  # idPsp in idempotencyKey (idempotencyKey: <idPsp>+"_"+<RANDOM STRING>) with field ENABLED = N  [SEM_APNR_18]
  Scenario: Check outcome OK on disabled psp in idempotencyKey
    Given random idempotencyKey having 80000000001 as idPSP in activatePaymentNotice
    When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
