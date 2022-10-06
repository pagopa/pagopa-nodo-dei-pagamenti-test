Feature: process checks for VerifyPaymentNoticeReq - EC old

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
    And EC old version
   # verifyPaymentNotice KO - EC old [PRO_VPNR_07]

  Scenario: Check PPT_STAZIONE_INT_PA_TIMEOUT error when paVerifyPaymentRes is in timeout
    Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <paf:paVerifyPaymentNoticeRes>
                 <outcome>KO</outcome>
                 <fault>
                    <faultCode>PPT_STAZIONE_INT_PA_TIMEOUT</faultCode>
                    <faultString>Timeout risposta dalla stazione</faultString>
                    <id>66666666666</id>
                    <description>Timeout risposta dalla stazione</description> 
                 </fault>
              </paf:paVerifyPaymentNoticeRes>
           </soapenv:Body>
        </soapenv:Envelope>
        """
    #And EC wait for 30 seconds at paVerifyPaymentNoticeRes    
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of verifyPaymentNotice response
