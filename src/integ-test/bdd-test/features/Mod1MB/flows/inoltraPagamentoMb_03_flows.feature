Feature: process tests for inoltropagamentoMb_03

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
         <multiBeneficiario>1</multiBeneficiario>
      </ws:nodoInviaCarrelloRPT>
   </soapenv:Body>
</soapenv:Envelope>
    """
    And EC new version


    
  # Verify phase
  Scenario: Execute nodoInviaCarrelloRPT request
    When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check outcome is OK of nodoInviaCarrelloRPT response


        #activate phase
  Scenario: Execute nodoChiediInformaioniPagamento request
    Given the Execute nodoChiediInformaioniPagamento request scenario executed successfully
    And initial XML nodoChiediInformaioniPagamento
      """
     ##manca primitiva
      """
    When psp sends SOAP nodoChiediInformaioniPagamento to nodo-dei-pagamenti
    Then check outcome is OK of nodoChiediInformaioniPagamento response


        #activate phase
  Scenario: Execute nodoInoltraEsitoPagamentoMod2 request
    Given the Execute nodoInoltraEsitoPagamentoMod2 request scenario executed successfully
    And initial XML nodoInoltraEsitoPagamentoMod2
      """
     ##manca primitiva
      """
    When psp sends SOAP nodoInoltraEsitoPagamentoMod1 to nodo-dei-pagamenti
    Then check outcome is OK of nodoInoltraEsitoPagamentoMod1 response



    #db check 1
    Scenario : DB check
    Given the Execute nodoInoltraEsitoPagamentoMod2 request scenario executed successfully
    Then checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP of the record at column STATO of STATI_RPT retrived by the query DB_INOLTRO_PAG_01_stati_rpt1 on db nodo_online under macro Mod1Mb
    And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_INVIATA_A_PSP,RPT_ACCETTATA_PSP of the record at column STATO of STATI_RPT retrived by the query DB_INOLTRO_PAG_01_stati_rpt11 on db nodo_online under macro Mod1Mb
    And checks the value RPT_ACCETTATA_PSP of the record at column STATO of STATI_RPT_SNAPSHOT retrived by the query DB_INOLTRO_PAG_01_stati_rpt2_napshot on db nodo_online under macro Mod1Mb
    And checks the value RPT_ACCETTATA_PSP of the record at column STATO of STATI_RPT_SNAPSHOT retrived by the query DB_INOLTRO_PAG_01_stati_rpt21_napshot on db nodo_online under macro Mod1Mb



    #db check 1
    Scenario : DB check
    Given the Execute nodoInoltraEsitoPagamentoMod2 request scenario executed successfully
    Then checks the value CART_RICEVUTO_NODO,CART_ACCETTATO_NODO,CART_PARCHEGGIATO_NODO,CART_INVIATO_A_PSP,CART_ACCETTATO_PSP of the record at column STATO of STATI_RPT retrived by the query DB_INOLTRO_PAG_01_stati_carrello on db nodo_online under macro Mod1Mb
    And checks the value CART_ACCETTATO_PSP of the record at column STATO of STATI_RPT_SNAPSHOT retrived by the query DB_INOLTRO_PAG_01_stati_carrello_napshot on db nodo_online under macro Mod1Mb
