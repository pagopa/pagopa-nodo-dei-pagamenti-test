Feature:  block checks for verificaBollettino - position status in PAID after retry with expired token [VerificaBollettino_blocco_06] 1344

  Background:
    Given systems up
    


  # Verify Phase 1
  Scenario: Execute verificaBollettino request
    Given initial XML verificaBollettino
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
         <nod:verificaBollettinoReq>
            <idPSP>#pspPoste#</idPSP>
            <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
            <idChannel>#channelPoste#</idChannel>
            <password>pwdpwdpwd</password>
            <ccPost>#ccPoste#</ccPost>
            <noticeNumber>#notice_number#</noticeNumber>
         </nod:verificaBollettinoReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response


   # Activate Phase
   Scenario: Execute activatePaymentNotice request
      Given the Execute verificaBollettino request scenario executed successfully
      And initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:activatePaymentNoticeReq>
               <idPSP>#pspPoste#</idPSP>
               <idBrokerPSP>#brokerPspPoste#</idBrokerPSP>
               <idChannel>#channelPoste#</idChannel>
               <password>pwdpwdpwd</password>
               <qrCode>
                  <fiscalCode>$verificaBollettinoResponse.fiscalCodePA</fiscalCode>
                  <noticeNumber>$verificaBollettino.noticeNumber</noticeNumber>
               </qrCode>
               <expirationTime>2000</expirationTime>
               <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response

   # Verify Phase 2
   @runnable 
   Scenario: Execute verificaBollettino request with the same request as Verify Phase 1
      Given the Execute activatePaymentNotice request scenario executed successfully
      When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
      Then check outcome is KO of verificaBollettino response
      And check faultCode is PPT_PAGAMENTO_IN_CORSO of verificaBollettino response