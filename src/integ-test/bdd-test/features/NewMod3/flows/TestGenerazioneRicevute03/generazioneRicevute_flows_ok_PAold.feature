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
                  <fiscalCode>#codicePA_old#</fiscalCode>
                  <noticeNumber>#notice_number#</noticeNumber>
               </qrCode>
            </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC old version

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  @prova
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
                      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
                      <noticeNumber>#notice_number#</noticeNumber>
                  </qrCode>
                  <expirationTime>2000</expirationTime>
                  <amount>10.00</amount>
                  <dueDate>2021-12-31</dueDate>
                  <paymentNote>causale</paymentNote>
              </nod:activatePaymentNoticeReq>
          </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Then checks the value $activatePaymentNotice.iuv of the record at column CREDITOR_REFERENCE_ID of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.paymentToken of the record at column PAYMENT_TOKEN of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP8 of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3


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

# Payment Outcome Phase outcome KO
  Scenario: Execute sendPaymentOutcome request
    Given the nodoInviaRPT request scenario executed successfully
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
   
	

  # test execution
   Scenario: Execution test DB_GR_21
    Given the nodoInviaRPT request scenario executed successfully
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is OK of sendPaymentOutcome response
    # And deb check 2 rt activision
    #La tabella RT è opportunamente popolata
    And api-config executes the sql {sql_code} and check RT 
    #La tabella RT_VERSAMENTI è opportunamente popolata
    And api-config executes the sql {sql_code} and check RT_VERSAMENTI
    #La tabella POSITION_RECEIPT non è popolata 
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT
    #La tabella RT_XML è opportunamente popolata
    And api-config executes the sql {sql_code} and check RT_XML
    #La tabella POSITION_RECEIPT_TRANSFER non è popolata
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_TRANSFER
    #La tabella POSITION_RECEIPT_XML non è popolata
    And api-config executes the sql {sql_code} and check POSITION_RECEIPT_XML
    #La tabella RPT_ACTIVATIONS è popolata in fase di activate e ripulita all'arrivo della nodoInviaRPT.
    And api-config executes the sql {sql_code} and check RPT_ACTIVATIONS
    
    









