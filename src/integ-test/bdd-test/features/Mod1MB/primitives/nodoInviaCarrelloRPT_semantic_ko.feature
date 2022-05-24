Feature:  semantic checks for nodoInviaCarrelloRPT

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

  # idCarrello value check: idCarrello not in db [SEM_Mb_01]
  Scenario Outline: Check PPT_MULTIBENEFICIARIO error on non-existent psp
    Given idCarrello with <value> in nodoInviaCarrelloRPT
    When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check outcome is KO of nodoInviaCarrelloRPT response
    And check faultCode is PPT_MULTIBENEFICIARIO of nodoInviaCarrelloRPT response
    Examples:
      | value                                            | soapUI test  |
      | [azAZ09]{11}[azAZ09]{18}[09]{5}                  | SEM_Mb_1     |



      # station value check: combination idDominio-noticeNumber identifies a station not present inside column ID_CARRELLO in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_Mb_11]
  Scenario Outline: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error on non-existent station
    Given idDominio with 77777777777 in nodoInviaCarrelloRPT
    And noticeNumber with <value> in nodoInviaCarrelloRPT
    When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check outcome is KO of nodoInviaCarrelloRPT response
    And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoInviaCarrelloRPT response
    Examples:
      | value              | soapUI test                                            |
      | 5                  | SEM_AIPR_12 - auxDigit inesistente                     |
      | 011456789012345678 | SEM_AIPR_12 - auxDigit 0 - progressivo inesistente     |
      | 316456789012345678 | SEM_AIPR_12 - auxDigit 3 - segregationCode inesistente |


          # station value check: combination idDominio-noticeNumber identifies a station corresponding to an ID_STAZIONE value with field ENABLED = N in NODO4_CFG.STAZIONI table of nodo-dei-pagamenti database [SEM_Mb_12]
  Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error on disabled station
    Given idDominio with 77777777777 in nodoInviaCarrelloRPT
    And noticeNumber with 088456789012345678 in nodoInviaCarrelloRPT
    When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check outcome is KO of nodoInviaCarrelloRPT response
    And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoInviaCarrelloRPT response

    
     # pa broker value check: combination idDominio-noticeNumber identifies a pa broker corresponding to an ID_INTERMEDIARIO_PA value with field ENABLED = N in NODO4_CFG.INTERMEDIARI_PA table of nodo-dei-pagamenti database [SEM_Mb_13]
  Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error on disabled pa broker
    Given idDominio with 77777777777 in nodoInviaCarrelloRPT
    And noticeNumber with 088456789012345678 in nodoInviaCarrelloRPT
    When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check outcome is KO of nodoInviaCarrelloRPT response
    And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoInviaCarrelloRPT response

   


