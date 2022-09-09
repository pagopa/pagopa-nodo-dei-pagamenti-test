Feature: process tests for notificaAnnullamento_Carrello_2RPT-T139B

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
            <!--1 or more repetitions:-->
            <elementoListaRPT>
            <identificativoDominio>${pa}</identificativoDominio>
            <identificativoUnivocoVersamento>${#TestCase#iuv}</identificativoUnivocoVersamento>
            <codiceContestoPagamento>${#TestCase#ccp}</codiceContestoPagamento>
            <rpt>${#TestCase#rptAttachment}</rpt>
            </elementoListaRPT>
            <elementoListaRPT>
            <identificativoDominio>${pa}</identificativoDominio>
            <identificativoUnivocoVersamento>${#TestCase#iuv2}</identificativoUnivocoVersamento>
            <codiceContestoPagamento>${#TestCase#ccp}</codiceContestoPagamento>
            <rpt>${#TestCase#rptAttachment2}</rpt>
            </elementoListaRPT>
            </listaRPT>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """


    Scenario: Execute nodoInviaCarrelloRPT request
        When PSP sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then verify the HTTP status code of nodoInviaCarrelloRPT response is 200


    Scenario: Execute nodoNotificaAnnullamento
        Given the Execute nodoInviaCarrelloRPT scenario executed successfully
        When WISP sends rest GET notificaAnnullamento?idPagamento=$nodoInviaCarrelloRPTResponse.id to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200


