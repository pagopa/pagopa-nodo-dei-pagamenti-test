Feature:  block checks for verifyPaymentReq - position status in PAID after retry with expired token [Verify_blocco_06]

  Background:
    Given systems up
   

  # Verify Phase 1
  Scenario: Execute verifyPaymentNotice request
    Given initial XML verifyPaymentNotice
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
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response
    

  # Activate Phase with expirationTime set to 2000
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
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


  # Mod3Cancel Phase
  Scenario: Execute mod3Cancel poller
    Given the Execute activatePaymentNotice request scenario executed successfully
    # When expirationTime inserted in activatePaymentNoticeReq has passed and mod3Cancel poller has been triggered
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200


  # Payment Outcome Phase
  Scenario: Execute sendPaymentOutcome request
    Given the Execute mod3Cancel poller scenario executed successfully
    And initial XML sendPaymentOutcome
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
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response
	
  Scenario: Execute paSendRT request
    Given the Execute sendPaymentOutcome request scenario executed successfully
    Then check EC receives paSendRT properly
  """
    $verifyPaymentNotice.noticeNumber
  """

  # Verify Phase 2
  Scenario: Execute a verifyPaymentNotice request with the same request as Verify Phase 1, immediately after the Payment Outcome Phase
    Given the Execute paSendRT request scenario executed successfully
    When psp sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of verifyPaymentNotice response
    And check faultCode is PPT_PAGAMENTO_DUPLICATO of verifyPaymentNotice response
