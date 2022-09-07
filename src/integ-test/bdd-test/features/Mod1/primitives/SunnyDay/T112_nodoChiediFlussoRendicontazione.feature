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
                    <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>44444444444</identificativoDominio>
                    <identificativoPSP>40000000001</identificativoPSP>
                </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediElencoFlussiRendicontazione response
        And check elencoFlussiRendicontazione field exists in nodoChiediListaPendentiRPT response
        And check nodoChiediElencoFlussiRendicontazioneRisposta field exists in nodoChiediListaPendentiRPT response
        And retrieve session token from $nodoChiediElencoFlussiRendicontazioneResponse.url


    Scenario: Send nodoChiediFlussiRendicontazione
        Given the Send nodoChiediElencoFlussiRendicontazione scenario executed successfully
        And initial XML nodoChiediFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediFlussoRendicontazione>
                    <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>44444444444</identificativoDominio>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoFlusso>#identificativoFlusso#</identificativoFlusso>
                </ws:nodoChiediFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        Then check xmlRendicontazione field exists in nodoChiediFlussiRendicontazioneRisposta response
        And check nodoChiediFlussiRendicontazioneRisposta field exists in nodoChiediListaPendentiRPT response


            