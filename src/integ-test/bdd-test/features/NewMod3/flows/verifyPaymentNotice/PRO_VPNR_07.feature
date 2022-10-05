Feature: process checks for VerifyPaymentNoticeReq - EC old

  Background:
    Given systems up
     And EC old version
   # verifyPaymentNotice KO - EC old [PRO_VPNR_07]
   Scenario: Execute verifyPaymentNotice request OLD KO
     Given EC wait for 40 seconds at paVerifyPaymentNoticeRes
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
                        <fiscalCode>#creditor_institution_code_old#</fiscalCode>
                        <noticeNumber>#notice_number_old#</noticeNumber>
                     </qrCode>
                  </nod:verifyPaymentNoticeReq>
               </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of verifyPaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of verifyPaymentNotice response
