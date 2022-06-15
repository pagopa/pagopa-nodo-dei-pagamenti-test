Feature: process tests for annulli_02.1



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


  # Define primitive nodoChiediInformaioniPagamento
  Scenario: Define nodoChiediInformaioniPagamento
    Given initial XML nodoChiediInformaioniPagamento
	"""
	## Primitive missing
	"""

  # Define primitive nodoNotificaAnnullamento
  Scenario: Define nodoNotificaAnnullamento
    Given initial XML nodoNotificaAnnullamento
    """
  ##primitive missing
    """

    #db check 1
    Scenario: DB check
    Given the Execute nodoNotificaAnnullamento request scenario executed successfully
    Then checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ANNULLATA_WISP of the record at column STATO of STATI_RPT retrived by the query DB_Annulli_02.1_stati_rpt on db nodo_online under macro Mod1Mb
    Then checks the value  RPT_ANNULLATA_WISP of the record at column STATO of STATI_RPT_SNAPSHOT retrived by the query DB_Annulli_02.1_stati_rpt_snapshot on db nodo_online under macro Mod1Mb


   # test execution part2
   Scenario: Execution test [annulli_02.1]
   Given the nodoNotificaAnnullamento request scenario executed successfully
    Then checks the value CART_RICEVUTO_NODO,CART_ACCETTATO_NODO,CART_PARCHEGGIATO_NODO,CART_ANNULLATO_WISP of the record at column STATO of STATI_CARRELLO retrived by the query DB_Annulli_02.1_stati_carrello on db nodo_online under macro Mod1Mb
    Then checks the value  CART_ANNULLATO_WISP of the record at column STATO of STATI_CARRELLO_SNAPSHOT retrived by the query DB_Annulli_02.1_stati_carrello_snapshot on db nodo_online under macro Mod1Mb


      #controllo che le tabelle non siano popolate

      # test execution part3
      Scenario: Execution test [annulli_02.1]
      Given the nodoNotificaAnnullamento request scenario executed successfully
      When psp sends SOAP nodoNotificaAnnullamento to nodo-dei-pagamenti
      And execute the sqlDB_Annulli_02.1_position_payment_status on db nodo_online under macro Mod1Mb
      And execute the sql DB_Annulli_02.1_position_payment_status_snapshot on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_STATUS table is not populated according to the query DB_Annulli_02.1_position_payment_status and primitive
      Then checks the POSITION_PAYMENT_STATUS_SNAPSHOT table is not populated according to the query DB_Annulli_02.1_position_payment_status_snapshot and primitive


      
      # test execution part4
      Scenario: Execution test [annulli_02.1]
      Given the nodoNotificaAnnullamento request scenario executed successfully
      When psp sends SOAP nodoNotificaAnnullamento to nodo-dei-pagamenti
      And execute the sql DB_Annulli_02.1_position_statu on db nodo_online under macro Mod1Mb
      And execute the sql DB_Annulli_02.1_position_status_snapshot on db nodo_online under macro Mod1Mb
      Then checks the POSITION_STATUS table is not populated according to the query DB_Annulli_02.1_position_status and primitive
      Then checks the POSITION_STATUS_SNAPSHOT table is not populated according to the query DB_Annulli_02.1_position_status_snapshot and primitive



