Feature: process tests for generazioneRicevute 

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
    Given the Execute activatePaymentNotice request scenario executed successfully
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
    # And db check 1 rt_activision


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
  #  When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti using the token of the activate phase
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check outcome is OK of nodoInviaRPT response

  # test execution
   Scenario: Execution test DB_GR_23
    Given the nodoInviaRPT request scenario executed successfully
    When job mod3Cancel triggered after 3 seconds
    Then verify the HTTP status code of mod3Cancel response is 200
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
















