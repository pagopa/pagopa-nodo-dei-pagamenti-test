Feature: Semantic checks for paVerifyPaymentNoticeRes

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
    And EC new version
    And idChannel with USE_NEW_FAULT_CODE=Y

   
  Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error on fault generated by EC
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
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verifyPaymentNotice response
    And check originalFaultCode is PAA_SEMANTICA of verifyPaymentNotice response
    And check originalFaultString is Errore semantico of verifyPaymentNotice response



 Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error on fault generated by EC when it isn't a known faultCode
   Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
           <soapenv:Header/>
           <soapenv:Body>
              <paf:paVerifyPaymentNoticeRes>
                 <outcome>KO</outcome>
                 <fault>
                    <faultCode>PAA_CIAO</faultCode>
                    <faultString>Errore sconosciuto</faultString>
                    <id>1</id>
                 </fault>
              </paf:paVerifyPaymentNoticeRes>
           </soapenv:Body>
        </soapenv:Envelope>
        """
   When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
   Then check outcome is KO of verifyPaymentNotice response
   And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of verifyPaymentNotice response
   And check originalFaultCode is PAA_CIAO of verifyPaymentNotice response
   And check originalFaultString is Errore sconosciuto of verifyPaymentNotice response
