Feature: Semantic checks for paVerifyPaymentNoticeRes

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
    And EC new version
    And idChannel with USE_NEW_FAULT_CODE=Y

  @runnable
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
