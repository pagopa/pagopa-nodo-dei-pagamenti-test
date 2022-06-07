Feature: process tests for nodoInviaCarrelloRPT

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

# CONTROLLA BENE
 # Activate phase [nodoInviaCarrelloMb_08] 
   Scenario: "verify the identificativo of the nodoInviaCarrelloRPT response is equals to {name}"
      Given the Execute nodoInviaCarrelloRPT request with Pa in RPT2 EC scenario executed successfully
      And multiBeneficiario with True
      #TODO
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response



 # Activate phase [nodoInviaCarrelloMb_09] 
   Scenario: verify the IUV_RPT1 of the nodoInviaCarrelloRPT response is not equals to IUV_RPT2
      Given the Execute nodoInviaCarrelloRPT request with IUV_RPT1 is not equals to IUV_RPT2 EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response

 # Activate phase [nodoInviaCarrelloMb_10] 
   Scenario: verify the dataEsecuione_RPT1 of the nodoInviaCarrelloRPT response is not equals to dataEsecuione_RPT2
      Given the Execute nodoInviaCarrelloRPT request with dataEsecuione_RPT1 is not equals to dataEsecuione_RPT2 EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response

 # Activate phase [nodoInviaCarrelloMb_11] 
   Scenario: verify the CCP_RPT of the nodoInviaCarrelloRPT response is not equals to idCarrello
      Given the Execute nodoInviaCarrelloRPT request with CCP_RPT is not equals to idCarrello EC scenario executed successfully
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response


 # Activate phase [nodoInviaCarrelloMb_12] 
   Scenario: verify the CCP_RPT of the nodoInviaCarrelloRPT response is not equals to idCarrello
      Given the Execute nodoInviaCarrelloRPT request with CCP_RPT2 is not equals to idCarrello EC scenario executed successfully
      And CCP_RPT1 is equals to idCarrello
      And u'multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response


 # Activate phase [nodoInviaCarrelloMb_13] 
   Scenario: verify the CCP_RPT of the nodoInviaCarrelloRPT response is not equals to idCarrello
      Given the Execute nodoInviaCarrelloRPT request with CCP_RPT1 is not equals to idCarrello EC scenario executed successfully
      And CCP_RPT2 is equals to idCarrello
      And multiBeneficiario with True
      When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response



  # IBAN- IBAN value check: IBAN not associated to idDominio in RPT1 [nodoInviaCarrelloMb_14]
  Scenario: Check PPT_MULTIBENEFICIARIO error on IBAN not associated to idDominio in RPT1
    Given IBAN with <IBAN> in nodoInviaCarrello
    And multiBeneficiario with True
    When PSP sends SOAP nodoInviaCarrello to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_MULTIBENEFICIARIO of verificaBollettino response


   # IBAN- IBAN value check: IBAN not associated to idDominio in RPT1 [nodoInviaCarrelloMb_15]
  Scenario: Check PPT_MULTIBENEFICIARIO error on IBAN with New in nodoInviaCarrello
    Given IBAN with New in nodoInviaCarrello
    And multiBeneficiario with True
    When PSP sends SOAP nodoInviaCarrello to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_MULTIBENEFICIARIO of verificaBollettino response



   
  # IBAN- IBAN value check: IBAN in <elem> associated to idDominio in <tag_value> [nodoInviaCarrelloMb_16]
  Scenario Outline: Check PPT_MULTIBENEFICIARIO error on Iban  #associated to idDominio in RPT1
    Given IBAN set <elem> with <value> in nodoInviaCarrello
    And multiBeneficiario with True
    When PSP sends SOAP nodoInviaCarrello to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_MULTIBENEFICIARIO of verificaBollettino response
    Examples:
      | elem                        | tag_value            | soapUI test                        |
      | soapenv:Body                | None                 |  nodoInviaCarrelloMb_16            |





  # Notice_Id value check: Notice_Id value associates old version station [nodoInviaCarrelloMb_17]
  Scenario: Check PPT_MULTIBENEFICIARIO error on Notice_Id with old version station 
    Given multiBeneficiario with True
    When PSP sends SOAP nodoInviaCarrello to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_MULTIBENEFICIARIO of verificaBollettino response


   
  # Notice_Id value check: Notice_Id value associates old version station [nodoInviaCarrelloMb_18]
  Scenario: Check PPT_MULTIBENEFICIARIO error on Notice_Id with old version station 
    Given multiBeneficiario with True
    When PSP sends SOAP nodoInviaCarrello to nodo-dei-pagamenti
    Then check outcome is KO of verificaBollettino response
    And check faultCode is PPT_MULTIBENEFICIARIO of verificaBollettino response












