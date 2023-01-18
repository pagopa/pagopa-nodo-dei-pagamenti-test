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

@runnable
  Scenario: Check PPT_STAZIONE_INT_PA_TIMEOUT error when paVerifyPaymentRes is in timeout
    Given EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header />
      <soapenv:Body>
         <paf:paVerifyPaymentNoticeRes>
            <delay>10000</delay>
            <outcome>OK</outcome>
            <paymentList>
               <paymentOptionDescription>
                  <amount>10.00</amount>
                  <options>EQ</options>
                  <dueDate>2021-07-31</dueDate>
                  <detailDescription>pagamentoTest</detailDescription>
                  <allCCP>false</allCCP>
               </paymentOptionDescription>
            </paymentList>
            <paymentDescription>Pagamento di Test</paymentDescription>
            <fiscalCodePA>#creditor_institution_code#</fiscalCodePA>
            <companyName>companyName</companyName>
            <officeName>officeName</officeName>
        </paf:paVerifyPaymentNoticeRes>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    #And EC wait for 30 seconds at paVerifyPaymentNoticeRes    
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of verifyPaymentNotice response
