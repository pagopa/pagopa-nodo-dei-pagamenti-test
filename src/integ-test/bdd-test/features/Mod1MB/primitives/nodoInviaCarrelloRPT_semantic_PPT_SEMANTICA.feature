Feature: semantic checks for nodoInviaCarrelloRPT - PPT_SEMANTICA [SEM_Mb_15]

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
    And EC New Version



    Scenario Outline: Check PPT_SEMANTICA error
    Given identificativoPSP different from WISP parking
    and multiBeneficiario with True
    When psp sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode with <value> is PPT_SEMANTICA of nodoInviaCarrelloRPT response
      Examples:
      | value                                                                                | soapUI test   |
      | flagMultibeneficiario non disponibile per pagamenti diversi da WISP2                 | SEM_Mb_15     |