 Feature: Syntax checks for verificaBollettino - OK 1552
 
 Background:
    Given systems up
    And initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:verificaBollettinoReq>
               <idPSP>POSTE3</idPSP>
               <idBrokerPSP>BANCOPOSTA</idBrokerPSP>
               <idChannel>POSTE3</idChannel>
               <password>pwdpwdpwd</password>
               <ccPost>#ccPoste#</ccPost>
               <noticeNumber>#notice_number#</noticeNumber>
            </nod:verificaBollettinoReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
 
 @ALL    
 Scenario: SIN_VB_00
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
      
      
      
