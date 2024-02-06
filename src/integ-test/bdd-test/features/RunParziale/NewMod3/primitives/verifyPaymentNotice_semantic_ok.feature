Feature: Semantic checks for verifyPaymentReq - OK

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>#psp#</idPSP>
               <idBrokerPSP>#psp#</idBrokerPSP>
               <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
  
  @ALL
  Scenario: Check valid URL in WSDL namespace
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  @ALL
  # denylist value check: combination fiscalCode-idChannel-idPSP identifies a record in NODO4_CFG.DENYLIST table of nodo-dei-pagamenti database [SEM_VPNR_16]
  Scenario: Check outcome OK if combination psp-channel-pa in denylist
    Given generate 1 notice number and iuv with aux digit 3, segregation code 11 and application code NA
    And noticeNumber with $1noticeNumber in verifyPaymentNotice
    And fiscalCode with 44444444444 in verifyPaymentNotice
    And idPSP with 40000000001 in verifyPaymentNotice
    And idBrokerPSP with 40000000002 in verifyPaymentNotice
    And idChannel with 40000000002_01 in verifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
