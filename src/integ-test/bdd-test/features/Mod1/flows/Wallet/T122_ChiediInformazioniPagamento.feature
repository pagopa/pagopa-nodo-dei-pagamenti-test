Feature: process tests for chiediInformazioniPagamento [T122]

    Background:
        Given systems up
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>${intermediarioPA}</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>${stazione}</identificativoStazioneIntermediarioPA>
            <identificativoDominio>${pa}</identificativoDominio>
            <identificativoUnivocoVersamento>${#TestCase#iuv}</identificativoUnivocoVersamento>
            <codiceContestoPagamento>${#TestCase#ccp}</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>${password}</password>
            <identificativoPSP>${pspAgid}</identificativoPSP>
            <identificativoIntermediarioPSP>${intermediarioPSPAgid}</identificativoIntermediarioPSP>
            <identificativoCanale>${canaleAgid}</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>${#TestCase#rptAttachment}</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        

    Scenario: Execute nodoInviaRPT request
        When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check outcome is OK of nodoInviaRPT response
