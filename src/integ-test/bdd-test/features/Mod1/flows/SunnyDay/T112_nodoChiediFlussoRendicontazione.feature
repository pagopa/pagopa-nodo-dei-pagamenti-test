Feature: process tests for nodoChiediElencoFlussiRendicontazione
    Background:
        Given systems up

    Scenario: Send nodoChiediElencoFlussiRendicontazione
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediElencoFlussiRendicontazione>
                    <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                    <identificativoPSP>#psp#</identificativoPSP>
                </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediElencoFlussiRendicontazione response
        And check elencoFlussiRendicontazione field exists in nodoChiediElencoFlussiRendicontazione response
        And check ppt:nodoChiediElencoFlussiRendicontazioneRisposta field exists in nodoChiediElencoFlussiRendicontazione response
        #And retrieve session token from $nodoChiediElencoFlussiRendicontazioneResponse.url

@runnable      @testdev
    Scenario: Send nodoChiediFlussiRendicontazione
        Given the Send nodoChiediElencoFlussiRendicontazione scenario executed successfully
        And initial XML nodoChiediFlussoRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediFlussoRendicontazione>
                    <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoFlusso>$nodoChiediElencoFlussiRendicontazioneResponse.identificativoFlusso</identificativoFlusso>
                </ws:nodoChiediFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
        Then verify the HTTP status code of nodoChiediFlussoRendicontazione response is 200
        And check ppt:nodoChiediFlussoRendicontazioneRisposta field exists in nodoChiediFlussoRendicontazione response


            