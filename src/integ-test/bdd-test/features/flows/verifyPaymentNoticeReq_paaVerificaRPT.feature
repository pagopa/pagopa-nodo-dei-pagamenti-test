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
    Given EC replies to nodo-dei-pagamenti with the following paaVerificaRPTRes
    """
     <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
       <soapenv:Header/>
       <soapenv:Body>
          <ws:paaVerificaRPTRisposta>
             <paaVerificaRPTRisposta>
                <fault>
                   <faultCode>PAA_SEMANTICA</faultCode>
                   <faultString>Errore semantico</faultString>
                   <id>#creditor_institution_code#</id>
                </fault>
                <esito>KO</esito>
             </paaVerificaRPTRisposta>
          </ws:paaVerificaRPTRisposta>
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