Feature: process tests for generazioneRicevute 

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
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
    And EC new version

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response


  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
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
                  <expirationTime>120000</expirationTime>
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """

  Scenario: define paaAttivaRPTRes
    Given initial XML paaAttivaRPTRisposta
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
                <soapenv:Header/>
                <soapenv:Body>
                    <nod:paaAttivaRPTRisposta>
                        <esito>OK</esito>
                        <datiPagamento>
                            <importoSingoloVersamento>importo_singolo_versamento</importoSingoloVersamento>
                            <ibanAccredito>iban_accredito</ibanAccredito>
                            <bicAccredito>bic_accredito</bicAccredito>
                            <enteBeneficiario>ente_beneficiario</enteBeneficiario>
                            <credenzialiPagatore>credenziali_pagatore</credenzialiPagatore>
                            <causaleVersamento>causale_versamento</causaleVersamento>
                            <spezzoniCausaleVersamento>
                                <spezzoneCausaleVersamento>spezzone_causale_versamento</spezzoneCausaleVersamento>
                                <spezzoneStrutturaCausaleVersamento>
                                    <causaleSpezzone>causale_spezzone</causaleSpezzone>
                                    <importoSpezzone>importo_spezzone</importoSpezzone>
                                </spezzoneStrutturaCausaleVersamento>
                            </spezzoniCausaleVersamento>
                        </datiPagamento>
                    </nod:paaAttivaRPTRisposta>
                </soapenv:Body>
            </soapenv:Envelope>
            """

    # Activate phase
  Scenario: Execute activatePaymentNotice request
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    


  Scenario: Execute nodoInviaRPT request
   Given And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
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
    And job mod3Cancel triggered after 4 seconds
    And job paInviaRt triggered after 1 seconds
    #Then db check rt_activation 0
    And check outcome is OK of nodoInviaRPT response
    And verify the HTTP status code of mod3Cancel response is 200
    And verify the HTTP status code of paInviaRt response is 200

  Scenario: status RT_RIFIUTATA_PA scenario
    Given the nodoInviaRPT request scenario executed successfully
    #Then db check RT_RIFIUTATA_PA


     



# Payment Outcome Phase outcome KO
  Scenario: Execute sendPaymentOutcome request
    Given the status RT_RIFIUTATA_PA scenario executed successfully
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
               <outcome>KO</outcome>
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
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    
   
	

  # test execution
   Scenario: Execution test DB_GR_22
    Given the Execute sendPaymentOutcome request scenario executed successfully
    #Then db check 2
    And check faultCode is  PPT_TOKEN_SCADUTO of sendPaymentOutcome response 
    #And db check rety
    
    









