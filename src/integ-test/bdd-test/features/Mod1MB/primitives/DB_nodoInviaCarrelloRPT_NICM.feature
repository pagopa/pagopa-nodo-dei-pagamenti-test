Feature: DB checks for nodoInviaCarrelloRPT - KO

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
      And EC New

   Scenario: Execute nodoInviaCarrelloRPT request
      When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of activateIOPayment response


   Scenario: check db NICM_DB_01
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And execute the sql NICM_DB_01_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_SUBJECT table is properly populated according to the query NICM_DB_01_Mb and primitive


   Scenario: check db NICM_DB_02
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And soggettoPagatore RTP1 in POSITION_SUBJECT
      #And POSITION_SERVICE is empty
      And execute the sql NICM_DB_02_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_SUBJECT table is properly populated according to the query NICM_DB_02_Mb and primitive

   Scenario: check db NICM_DB_04
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is True
      #And POSITION_SERVICE is empty
      And execute the sql NICM_DB_02_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_SERVICE table is properly populated according to the query NICM_DB_02_Mb and primitive




   Scenario: check db NICM_DB_06
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is True
      And flagFinalPayment == 'N'
      And execute the sql NICM_DB_06_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_PLAN table is properly populated according to the query NICM_DB_06_Mb and primitive

   Scenario: check db NICM_DB_10
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is True
      And flagFinalPayment == 'N'
      And execute the sql NICM_DB_10_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_TRANSFER table is properly populated according to the query NICM_DB_10_Mb and primitive



   Scenario: check db NICM_DB_12
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is True
      And execute the sql NICM_DB_12_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT table is properly populated according to the query NICM_DB_12_Mb and primitive


   Scenario: check db NICM_DB_13
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is True
      And execute the sql NICM_DB_13_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_STATUS table is properly populated according to the query NICM_DB_13_Mb and primitive



   Scenario: check db NICM_DB_16
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is True
      And execute the sql NICM_DB_16_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_STATUS table is properly populated according to the query NICM_DB_16_Mb and primitive

   Scenario: check db NICM_DB_17
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is True
      And execute the sql NICM_DB_17_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_STATUS_SNAPSHOT table is properly populated according to the query NICM_DB_17_Mb and primitive



   Scenario: check db NICM_DB_18
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is False
      And flagFinalPayment == 'N'
      And execute the sql NICM_DB_06_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_PLAN table is properly populated according to the query NICM_DB_06_Mb and primitive



   Scenario: check db NICM_DB_18
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is False
      And execute the sql NICM_DB_12_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT table is properly populated according to the query NICM_DB_12_Mb and primitive

   Scenario: check db NICM_DB_18
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is False
      And execute the sql NICM_DB_13_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_STATUS table is properly populated according to the query NICM_DB_13_Mb and primitive


   Scenario: check db NICM_DB_18
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is False
      And execute the sql NICM_DB_16_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_STATUS table is properly populated according to the query NICM_DB_16_Mb and primitive

   Scenario: check db NICM_DB_18
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And multiBeneficiario is False
      And execute the sql NICM_DB_17_Mb on db nodo_online under macro Mod1Mb
      Then checks the POSITION_PAYMENT_STATUS_SNAPSHOT table is properly populated according to the query NICM_DB_17_Mb and primitive

