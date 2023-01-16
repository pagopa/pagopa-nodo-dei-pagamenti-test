Feature: bug_prod

    Background:
        Given systems up

    Scenario: nodoInviaRPT
        Given initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>80184430587</identificativoDominio>
            <identificativoUnivocoVersamento>70E000GLMI5JHJ1HH178B5PXOJNMRX4DPL7</identificativoUnivocoVersamento>
            <codiceContestoPagamento>n/a</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>#password#</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_02#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response

# Scenario: nodoInviaCarrelloRPT
#     Given initial XML nodoInviaCarrelloRPT
#         """
#         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
#         <soapenv:Header>
#         <ppt:intestazioneCarrelloPPT>
#         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
#         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
#         <identificativoCarrello>$ccp</identificativoCarrello>
#         </ppt:intestazioneCarrelloPPT>
#         </soapenv:Header>
#         <soapenv:Body>
#         <ws:nodoInviaCarrelloRPT>
#         <password>#password#</password>
#         <identificativoPSP>#psp_AGID#</identificativoPSP>
#         <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
#         <identificativoCanale>#canale_AGID_02#</identificativoCanale>
#         <listaRPT>
#         <!--1 or more repetitions:-->
#         <elementoListaRPT>
#         <identificativoDominio>80184430587</identificativoDominio>
#         <identificativoUnivocoVersamento>70E000GLMI5JHJ1HH178B5PXOJNMRX4DPL7</identificativoUnivocoVersamento>
#         <codiceContestoPagamento>$ccp</codiceContestoPagamento>
#         <rpt>$rptAttachment</rpt>
#         </elementoListaRPT>
#         </listaRPT>
#         </ws:nodoInviaCarrelloRPT>
#         </soapenv:Body>
#         </soapenv:Envelope>
#         """
#     When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
#     Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response