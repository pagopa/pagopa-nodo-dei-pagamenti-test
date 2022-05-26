Feature:  block checks for verificaBollettino - position status in INSERTED (mod3Cancel poller) [VerificaBollettino_blocco_05]

  Background:
    Given systems up
    And initial XML verificaBollettino
      """
  <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
    <soapenv:Header />
    <soapenv:Body>
      <nod:verificaBollettinoReq>
        <idPSP>88888888888</idPSP>
        <idBrokerPSP>88888888888</idBrokerPSP>
        <idChannel>88888888888_01</idChannel>
        <password>**********</password>
        <ccPost>012345678912</ccPost>
        <noticeNumber>311111111112222222</noticeNumber>
      </nod:verificaBollettinoReq>
    </soapenv:Body>
  </soapenv:Envelope>
      """
	 And EC new version

  # Verify Phase 1
  Scenario: Execute verificaBollettino request
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    

  # Activate Phase with expirationTime set to 2000
  Scenario: Execute activatePaymentNotice request
    Given initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:activatePaymentNoticeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <idempotencyKey>#idempotency_key#</idempotencyKey>
               <qrCode>
                  <fiscalCode>#creditor_institution_code#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
               <expirationTime>2000</expirationTime>
               <amount>120.00</amount>
            </nod:activatePaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And paymentToken exists of activatePaymentNotice response
    And paymentToken length is less than 36 of activatePaymentNotice response

        Scenario: Execute nodoInviaRPT request
   Given the Execute activatePaymentNotice request scenario executed successfully
   And initial XML nodoInviaRPT
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
  #  When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti using the token of the activate phase
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check outcome is OK of nodoInviaRPT response

  # Mod3Cancel Phase
  Scenario: Execute mod3Cancel poller
    Given the Execute activatePaymentNotice request scenario executed successfully
    # When expirationTime inserted in activatePaymentNoticeReq has passed and mod3Cancel poller has been triggered
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200

	
  # Verify Phase 2
  Scenario: Execute verificaBollettino request with the same request as Verify Phase 1
	# Given the Mod3Cancel Phase executed successfully
    Given the Execute mod3Cancel poller scenario executed successfully
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response

