 Feature: process tests for gestioneRTMb01 
 
 
 Background:
    Given systems up
    And initial XML nodoInviaCarrelloRPT
      """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
   <soapenv:Header>
      <ppt:intestazioneCarrelloPPT>
         <identificativoIntermediarioPA>${intermediarioPA}</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>${stazione}</identificativoStazioneIntermediarioPA>
         <identificativoCarrello>${#TestCase#idCarrello}</identificativoCarrello>
      </ppt:intestazioneCarrelloPPT>
   </soapenv:Header>
   <soapenv:Body>
      <ws:nodoInviaCarrelloRPT>
         <password>${password}</password>
         <identificativoPSP>${pspAgid}</identificativoPSP>
         <identificativoIntermediarioPSP>${intermediarioPSPAgid}</identificativoIntermediarioPSP>
         <identificativoCanale>${canaleAgid}</identificativoCanale>
         <listaRPT>
            ${#TestCase#elementiListaRPT}
         </listaRPT>
         <requireLightPayment>01</requireLightPayment>
         <multiBeneficiario>0</multiBeneficiario>
      </ws:nodoInviaCarrelloRPT>
   </soapenv:Body>
</soapenv:Envelope>
      """

  # Verify phase
  Scenario: Execute nodoInviaCarrelloRPT request
    When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    #And UPDATE_TIMESTAMP in STATI_RPT_SNAPSHOT with value 600 seconds
    Then check outcome is OK of nodoInviaCarrelloRPT response


  # Define primitive nodoChiediInformaioniPagamento
  Scenario: Define nodoChiediInformaioniPagamento
    Given initial XML nodoChiediInformaioniPagamento
	"""
	## Primitive missing
	"""

  # Define primitive nodoInoltrPagamentoMod1
  Scenario: Define nodoInoltraPagamentoMod1
    Given initial XML nodoInoltraPagamentoMod1
    """
  ##primitive missing
    """




  Scenario: Execute a nodoInviaRT request
    Given the Execute nodoInoltraPagamentoMod1 request scenario executed successfully
    And initial XML nodoInviaRT
    """
<soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
   <soapenv:Header/>
   <soapenv:Body>
      <ws:nodoInviaRT>
         <identificativoIntermediarioPSP>${intermediarioPSP}</identificativoIntermediarioPSP>
         <identificativoCanale>${canale}</identificativoCanale>
         <password>${password}</password>
         <identificativoPSP>${psp}</identificativoPSP>
         <identificativoDominio>${pa(ila)}</identificativoDominio>
         <identificativoUnivocoVersamento>${#TestCase#iuv}</identificativoUnivocoVersamento>
         <codiceContestoPagamento>${#TestCase#idCarrello}</codiceContestoPagamento>
         <tipoFirma></tipoFirma>
         <forzaControlloSegno>1</forzaControlloSegno>
	    <rt>${#TestCase#rtAttachment2}</rt>
      </ws:nodoInviaRT>
   </soapenv:Body>
</soapenv:Envelope>
    """

      When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaRT response


          #db check 1
    Scenario: DB check
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
#todo implementare test per cui la tabella position_receipt non sia popolata tramite query DB_RECEIPIT_02_position_receipit



          #db check 1
    Scenario: DB check
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
#todo implementare test per cui la tabella position_receipt_transfer non sia popolata tramite query DB_RECEIPIT_02_position_receipit_transfer


          #db check 1
    Scenario: DB check
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
#todo implementare test per cui la tabella position_receipt_recipient non sia popolata tramite query DB_RECEIPIT_02_position_receipit_recipient


          #db check 1
    Scenario: DB check
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
#todo implementare test per cui la tabella position_receipt_recipient_status non sia popolata tramite query DB_RECEIPIT_02_position_receipit_recipient_status


          #db check 1
    Scenario: DB check
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
#todo implementare test per cui la tabella position_receipt_xml non sia popolata tramite query DB_RECEIPIT_02_position_receipit_xml
