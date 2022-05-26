Feature:  block checks for verificaBollettino - position status in PAID [VerificaBollettino_blocco_02]

  Background:
    Given systems up
    And EC new version

  # Verify Phase 1
  Scenario: Execute verificaBollettino request
    Given initial XML verificaBollettino
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
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is OK of verificaBollettino response
    

  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    Given the verificaBollettino scenario executed successfully
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
                  <fiscalCode>$verifyPaymentNotice.fiscalCode</fiscalCode>
                  <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
               </qrCode>
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
        Given the activatePaymentNotice scenario executed successfully
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
 When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check outcome is OK of nodoInviaRPT response

	
  # Payment Outcome Phase
  Scenario: Execute sendPaymentOutcome request
    Given the activatePaymentNotice scenario executed successfully
    Given initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
               <idPSP>70000000001</idPSP>
               <idBrokerPSP>70000000001</idBrokerPSP>
               <idChannel>70000000001_01</idChannel>
               <password>pwdpwdpwd</password>
               <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
               <outcome>OK</outcome>
               <details>
                  <paymentMethod>creditCard</paymentMethod>
                  <paymentChannel>app</paymentChannel>
                  <fee>2.00</fee>
                  <payer>
                     <uniqueIdentifier>
                        <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
                        <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
                     </uniqueIdentifier>
                     <fullName>John Doe</fullName>
                     <streetName>street</streetName>
                     <civicNumber>12</civicNumber>
                     <postalCode>89020</postalCode>
                     <city>city</city>
                     <stateProvinceRegion>MI</stateProvinceRegion>
                     <country>IT</country>
                     <e-mail>john.doe@test.it</e-mail>
                  </payer>
                  <applicationDate>2021-10-01</applicationDate>
                  <transferDate>2021-10-02</transferDate>
               </details>
            </nod:sendPaymentOutcomeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
   #  When psp sends SOAP sendPaymentOutcomeReq to nodo-dei-pagamenti using the token of the activate phase, and with request field <outcome> = OK
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response

	
  # Verify Phase 2
  Scenario: Execute verificaBollettino request with the same request as Verify Phase 1, immediately after the Payment Outcome Phase
    Given the Execute sendPaymentOutcome request scenario executed successfully
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of verificaBollettino response


  Scenario: Execute verificaBollettino request with the same request as Verify Phase 1, few seconds after the Payment Outcome Phase (e.g. 30s)
    Given EC replies to nodo-dei-pagamenti with the paSendRT
  """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
      <soapenv:Header />
      <soapenv:Body>
        <paf:paSendRTRes>
          <outcome>KO</outcome>
          <fault>
            <faultCode>PAA_ERRORE_MOCK</faultCode>
            <faultString>Errore semantico</faultString>
            <id>1</id>
          </fault>
        </paf:paSendRTRes>
      </soapenv:Body>
    </soapenv:Envelope>
  """
    And the Execute sendPaymentOutcome request scenario executed successfully
    When psp sends SOAP verificaBollettino to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of verificaBollettino response
