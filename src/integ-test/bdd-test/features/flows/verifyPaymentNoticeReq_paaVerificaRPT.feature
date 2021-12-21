Feature:  process checks for VerifyPaymentNoticeReq - EC old

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
    And EC old version

    # paaVerificaRPTReq trigger - PRO_VPNR_01
  Scenario: Check the trigger of paaVerificaRPTReq
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check paaVerificaRPTReq is properly sent to PA
    
    # management of KO from EC - PRO_VPNR_05
  Scenario: Check PPT_ERRORE_EMESSO_DA_PAA error when paaVerificaRPTRes contains a KO
    Given EC responds to nodo-dei-pagamenti at paaVerificaRPTRes with:
    """
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
       <soapenv:Header/>
       <soapenv:Body>
          <paf:paVerifyPaymentNoticeRes>
             <outcome>KO</outcome>
             <fault>
                <faultCode>PAA_SEMANTICA</faultCode>
                <faultString>errore semantico PA</faultString>
                <id>#creditor_institution_code#</id>
                <description>errore semantico emesso dalla PA</description>
             </fault>
          </paf:paVerifyPaymentNoticeRes>
       </soapenv:Body>
    </soapenv:Envelope>
    """
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_ERRORE_EMESSO_DA_PAA
    
     # EC in timeout - PRO_VPNR_07
  Scenario: Check PPT_STAZIONE_INT_PA_TIMEOUT error when paaVerificaRPTRes is in timeout
    Given EC wait for 30 seconds at paVerifyPaymentNoticeReq
    When PSP sends verifyPaymentNoticeReq to nodo-dei-pagamenti
    Then check outcome is KO
    And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT