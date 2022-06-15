Feature: process tests for annulli_04



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

      # Mod3Cancel Phase
  Scenario: Execute paaInviaRT poller
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
    # When expirationTime inserted in activatePaymentNoticeReq has passed and paaInviaRT poller has been triggered
    When job paaInviaRT triggered after 600 seconds
    Then verify the HTTP status code of mod3Cancel response is 200


    #db check 1
    Scenario: DB check
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
    Then checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO of the record at column STATO of STATI_RPT retrived by the query DB_Annulli_04_stati_rpt on db nodo_online under macro Mod1Mb
    Then checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of STATI_RPT_SNAPSHOT retrived by the query DB_Annulli_04_stati_rpt_snapshot on db nodo_online under macro Mod1Mb


    #db check 2
    Scenario: DB check
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
    Then checks the value CART_RICEVUTO_NODO,CART_ACCETTATO_NODO,CART_PARCHEGGIATO_NODO of the record at column STATO of STATI_CARRELLO retrived by the query DB_Annulli_04_stati_carrello on db nodo_online under macro Mod1Mb
    Then checks the value CART_PARCHEGGIATO_NODO of the record at column STATO of STATI_CARRELLO_SNAPSHOT retrived by the query DB_Annulli_04_stati_carrello_snapshot on db nodo_online under macro Mod1Mb



