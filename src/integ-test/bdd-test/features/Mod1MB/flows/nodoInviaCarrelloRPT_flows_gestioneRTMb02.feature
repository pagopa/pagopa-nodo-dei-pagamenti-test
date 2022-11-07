Feature: process tests for gestioneRTMb02



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
         </ws:nodoInviaCarrelloRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """


@runnable
   Scenario: Execution test [gestioneRTMb02]
      Given the nodoNotificaAnnullamento request scenario executed successfully
      When psp sends SOAP nodoNotificaAnnullamento to nodo-dei-pagamenti
      And execute the sql GESRT_DB_02_1_Mb on db nodo_online under macro Mod1Mb
      And execute the sql GESRT_DB_02_2_Mb on db nodo_online under macro Mod1Mb
      And checks the value PAYNG at position of the query  GESRT_DB_02_1_Mb
      And checks the value FAILED at nodo_online db of the query  GESRT_DB_02_1_Mb
      And checks the value FAILED in nodo_online db of the query  GESRT_DB_02_2_Mb
