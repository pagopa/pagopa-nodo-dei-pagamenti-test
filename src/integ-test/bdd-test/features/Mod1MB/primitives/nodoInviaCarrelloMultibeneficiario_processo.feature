Feature: process tests for nodoInviaCarrelloRPT

   Background:
      Given systems up
      And initial XML verifyPaymentNotice
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

   # Activate phase [nodoInviaCarrelloMb_00]
   Scenario: Execute nodoInviaCarrelloRPT request with multiBeneficiario to True
      Given the Execute nodoInviaCarrelloRPT request with 5 deposits for both first and second RPT EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response


   # Activate phase [nodoInviaCarrelloMb_01]
   Scenario Outline: Execute nodoInviaCarrelloRPT request with multiBeneficiario to True
      Given RPT with <value> in nodoInviaCarrelloRPT
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response
      Examples:
         | value | soapUI test            |
         | 1     | nodoInviaCarrelloMb_01 |
         | 3     | nodoInviaCarrelloMb_01 |


   # Activate phase [nodoInviaCarrelloMb_02]
   Scenario: Execute nodoInviaCarrelloRPT request with multiBeneficiario to True
      Given the Execute nodoInviaCarrelloRPT request with 2 deposits for second RPT EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response


   # Activate phase [nodoInviaCarrelloMb_03]
   Scenario: Execute nodoInviaCarrelloRPT request with multiBeneficiario to True
      Given the Execute nodoInviaCarrelloRPT request with 4 deposits for first RPT and 1 for second RPT EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response

   # Activate phase [nodoInviaCarrelloMb_04]
   Scenario: Execute nodoInviaCarrelloRPT request with multiBeneficiario to True
      Given the Execute nodoInviaCarrelloRPT request with 5 deposits for first RPT and 1 for second RPT EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response


   # Activate phase [nodoInviaCarrelloMb_05]
   Scenario: Execute nodoInviaCarrelloRPT request with Pa in RPT1
      Given the Execute nodoInviaCarrelloRPT request with Pa in RPT1 EC scenario executed successfully
      And multiBeneficiario with True
      #TODO Invia tramite simulatore la primitiva nodoInviaCarrelloRPT in modo che il valore del tag <identificativoStazioneRichiedente> all'interno dell'XML RPT relativo alla seconda occorrenza dell'oggetto <listaRPT> sia diverso dal valore del campo <identificativoStazioneIntermediarioPA> in request alla primitiva nodoInviaCarrelloRPT
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response


   # Activate phase [nodoInviaCarrelloMb_06]
   Scenario: Execute nodoInviaCarrelloRPT request with identificativoStazioneIntermediarioPA in RPT1 and RPT2
      Given the Execute nodoInviaCarrelloRPT request with identificativoStazioneIntermediarioPA in RPT1 and RPT2 EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response



   # Activate phase [nodoInviaCarrelloMb_07]
   Scenario: Execute nodoInviaCarrelloRPT request with Pa in RPT2
      Given the Execute nodoInviaCarrelloRPT request with Pa in RPT2 EC scenario executed successfully
      And multiBeneficiario with True
      #TODO Invia tramite simulatore una nodoInviaCarrello con tag multibeneficiario = true, in cui la stazione da cui arriva il carrello è associata alla PA contenuta all'interno della RPT2 e non alla PA contenuta nella RPT1
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response







