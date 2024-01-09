Feature:  block checks for verificaBollettino - position status in PAYING [VerificaBollettino_blocco_01] 1347


   Background:
      Given systems up
      And EC new version


   # Verify RPT Phase
   Scenario: Execute nodoVerificaRPT request
      Given initial XML nodoVerificaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
               <ws:nodoVerificaRPT>
                  <identificativoPSP>#pspPoste#</identificativoPSP>
                  <identificativoIntermediarioPSP>#brokerPspPoste#</identificativoIntermediarioPSP>
                  <identificativoCanale>#channelPoste#</identificativoCanale>
                  <password>pwdpwdpwd</password>
                  <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
                  <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                  <codiceIdRPT>
                     <aim:aim128>
                        <aim:CCPost>#ccPoste#</aim:CCPost>
                        <aim:AuxDigit>3</aim:AuxDigit>
                        <aim:CodIUV>#cod_segr#012051482162400</aim:CodIUV>
                     </aim:aim128>
                  </codiceIdRPT>
               </ws:nodoVerificaRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
      Then check esito is KO of nodoVerificaRPT response
      And check faultString is La chiamata non è compatibile con il nuovo modello PSP. of nodoVerificaRPT response


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
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>$verificaBollettino.noticeNumber</noticeNumber>
         </qrCode>
         <expirationTime>60000</expirationTime>
         <amount>120.00</amount>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And paymentToken exists of activatePaymentNotice response
      And paymentToken length is less than 36 of activatePaymentNotice response


   # Verify Phase 2
   @runnable
   Scenario: Execute verificaBollettino2 request with the same request as Verify Phase 1
      Given the Execute activatePaymentNotice request scenario executed successfully
      When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
      Then check outcome is KO of verificaBollettino response
      And check faultCode is PPT_PAGAMENTO_IN_CORSO of verificaBollettino response