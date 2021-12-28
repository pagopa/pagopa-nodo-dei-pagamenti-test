Feature: process checks for VerifyPaymentNoticeReq - EC new

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
                  <noticeNumber>302094719472095710</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC new version

   # management of KO from PA - PRO_VPNR_06
  Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error when paVerifyPaymentRes contains a KO
    Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
    """
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <paf:paVerifyPaymentNoticeRes>
                 <outcome>KO</outcome>
                 <fault>
                    <faultCode>PAA_SEMANTICA</faultCode>
                    <faultString>Errore semantico</faultString>
                    <id>1</id>
                 </fault>
              </paf:paVerifyPaymentNoticeRes>
           </soapenv:Body>
        </soapenv:Envelope>
    """
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verifyPaymentNotice response
    
   # PA in timeout - PRO_VPNR_08
  Scenario: Check PPT_STAZIONE_INT_PA_TIMEOUT error when paVerifyPaymentRes is in timeout
    Given EC wait for 30 seconds at paVerifyPaymentNotice
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of verifyPaymentNotice response
