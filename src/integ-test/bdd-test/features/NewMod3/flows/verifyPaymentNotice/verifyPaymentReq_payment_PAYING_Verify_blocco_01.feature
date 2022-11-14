Feature:  block checks for verifyPaymentReq - position status in PAYING [Verify_blocco_01]

   Background:
      Given systems up
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>${psp}</idPSP>
         <idBrokerPSP>${intermediarioPSP}</idBrokerPSP>
         <idChannel>${canale3}</idChannel>
         <password>${password}</password>
         <qrCode>
         <fiscalCode>${qrCodeCF}</fiscalCode>
         <noticeNumber>002${#TestCase#iuv}</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   # Verify Phase 1
   Scenario: Execute verifyPaymentNotice request
      When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response


   # Activate Phase
   Scenario: Execute activatePaymentNotice request
      Given initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeReq>
         <idPSP>${psp}</idPSP>
         <idBrokerPSP>${intermediarioPSP}</idBrokerPSP>
         <idChannel>${canale3}</idChannel>
         <password>${password}</password>
         <idempotencyKey>${psp}_${#TestCase#idempotenza}</idempotencyKey>
         <qrCode>
         <fiscalCode>${qrCodeCF}</fiscalCode>
         <noticeNumber>002${#TestCase#iuv}</noticeNumber>
         </qrCode>
         <expirationTime>6000</expirationTime>
         <amount>10.00</amount>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      #    And token exists and check
      And paymentToken length is less than 36 of activatePaymentNotice response


   # Payment Outcome Phase
   @runnable
   Scenario: Execute nodoInviaRPT request
      Given the activatePaymentNotice scenario executed successfully
      Given initial XML nodoInviaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazionePPT>
         <identificativoIntermediarioPA>${intermediarioPA}</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>${stazioneAux03}</identificativoStazioneIntermediarioPA>
         <identificativoDominio>${pa}</identificativoDominio>
         <identificativoUnivocoVersamento>${#TestCase#iuv}</identificativoUnivocoVersamento>
         <codiceContestoPagamento>${#TestCase#token}</codiceContestoPagamento>
         </ppt:intestazionePPT>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoInviaRPT>
         <password>${password}</password>
         <identificativoPSP>${pspFittizio}</identificativoPSP>
         <identificativoIntermediarioPSP>${intermediarioPSPFittizio}</identificativoIntermediarioPSP>
         <identificativoCanale>${canaleFittizio}</identificativoCanale>
         <tipoFirma></tipoFirma>
         <rpt>${#TestCase#rptAttachment}</rpt>
         </ws:nodoInviaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      #  When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti using the token of the activate phase, and with request field <outcome> = PAYING
      When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaRPT response
      And check faultCode is PPT_PAGAMENTO_IN_CORSO of verifyPaymentNotice response


   # Verify Phase 2
   @runnable
   Scenario: Execute verifyPaymentNotice1 request with the same request as Verify Phase 1
      Given the activatePaymentNotice scenario executed successfully
      When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is KO of verifyPaymentNotice response
      And check faultCode is PPT_PAGAMENTO_IN_CORSO of verifyPaymentNotice response