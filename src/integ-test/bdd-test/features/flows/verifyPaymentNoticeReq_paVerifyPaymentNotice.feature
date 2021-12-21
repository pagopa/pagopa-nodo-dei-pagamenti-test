Feature: process checks for VerifyPaymentNoticeReq - EC new

  Background:
    Given systems up
    And initial verifyPaymentNoticeReq soap-request
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
                  <noticeNumber>302094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

   # management of KO from PA - PRO_VPNR_06
  Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error when paVerifyPaymentRes contains a KO
    Given EC responds to nodo-dei-pagamenti at paVerifyPaymentNotice with:
    """
     TODO insert xml with KO
    """
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA
    
   # PA in timeout - PRO_VPNR_08
  Scenario: Check PPT_STAZIONE_INT_PA_TIMEOUT error when paVerifyPaymentRes is in timeout
    Given EC wait for 30 seconds at paVerifyPaymentNotice
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT