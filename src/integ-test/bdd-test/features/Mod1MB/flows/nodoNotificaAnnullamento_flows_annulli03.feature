Feature: process tests for annulli_03



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

   # Verify phase
   Scenario: Execute nodoInviaCarrelloRPT request
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response





   # test execution part1
   Scenario: Execution test [annulli_02.1]
      Given the nodoNotificaAnnullamento request scenario executed successfully
      When psp sends SOAP nodoNotificaAnnullamento to nodo-dei-pagamenti
      And execute the sql ANN_DB_03_1_Mb on db nodo_online under macro Mod1Mb
      And execute the sql ANN_DB_03_2_Mb on db nodo_online under macro Mod1Mb
      And checks the value RPT_RICEVUTA_NODO at position of the query  ANN_DB_03_1_Mb
      And checks the value RPT_ACCETTATA_NODO in nodo_online db of the query  ANN_DB_03_1_Mb
      And checks the value RPT_PARCHEGGIATA_NODO in nodo_online db of the query  ANN_DB_03_1_Mb
      And checks the value RPT_ANNULLATA_WISP in nodo_online db of the query  ANN_DB_03_1_Mb
      And checks the value RPT_ANNULLATA_WISP in nodo_online db of the query  ANN_DB_03_2_Mb

   # test execution part2
   Scenario: Execution test [annulli_02.1]
      Given the nodoNotificaAnnullamento request scenario executed successfully
      When psp sends SOAP nodoNotificaAnnullamento to nodo-dei-pagamenti
      And execute the sql ANN_DB_03_3_Mb on db nodo_online under macro Mod1Mb
      And execute the sql ANN_DB_03_4_Mb on db nodo_online under macro Mod1Mb
      And checks the value CART_RICEVUTO_NODO in nodo_online db ANN_DB_03_3_Mb
      And checks the value CART_ACCETTATO_NODO in nodo_online db ANN_DB_03_3_Mb
      And checks the value CART_PARCHEGGIATO_NODO in nodo_online db ANN_DB_03_3_Mb
      And checks the value CART_ANNULLATA_WISP in nodo_online db ANN_DB_03_3_Mb
      And checks the value CART_ANNULLATO_WISP in nodo_online db ANN_DB_03_4_Mb

   # test execution part3
   Scenario: Execution test [annulli_02.1]
      Given the nodoNotificaAnnullamento request scenario executed successfully
      When psp sends SOAP nodoNotificaAnnullamento to nodo-dei-pagamenti
      And execute the sql ANN_DB_03_5_Mb on db nodo_online under macro Mod1Mb
      And execute the sql ANN_DB_03_6_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_STATUS table is not populated according to the query ANN_DB_03_5_Mb and primitive
      Then checks the POSITION_PAYMENT_STATUS_SNAPSHOT table is not populated according to the query ANN_DB_03_6_Mb and primitive



   # test execution part4
   Scenario: Execution test [annulli_02.1]
      Given the nodoNotificaAnnullamento request scenario executed successfully
      When psp sends SOAP nodoNotificaAnnullamento to nodo-dei-pagamenti
      And execute the sql ANN_DB_03_7_Mb on db nodo_online under macro Mod1Mb
      And execute the sql ANN_DB_03_8_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_STATUS table is not populated according to the query ANN_DB_03_7_Mb and primitive
      Then checks the POSITION_STATUS_SNAPSHOT table is not populated according to the query ANN_DB_03_8_Mb and primitive



