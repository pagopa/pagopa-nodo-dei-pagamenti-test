Feature: process checks for VerifyPaymentNoticeReq - EC old

  Background:
   Given systems up
     And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC old version
    And idChannel with USE_NEW_FAULT_CODE=N
   # verifyPaymentNotice KO - EC old [PRO_VPNR_07]

  Scenario: Check PPT_STAZIONE_INT_PA_TIMEOUT error when paVerifyPaymentRes is in timeout
    Given EC wait for 30 seconds at paVerifyPaymentNoticeRes
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of verifyPaymentNotice response
