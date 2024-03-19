Feature: T112_ChiediFlussoRendicontazione_1000PA 613
    Background:
        Given systems up

    Scenario: Send nodoChiediElencoFlussiRendicontazione
        Given initial XML nodoChiediElencoFlussiRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediElencoFlussiRendicontazione>
                    <identificativoIntermediarioPA>11111111111</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>1000recordElenco</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediElencoFlussiRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediElencoFlussiRendicontazione to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediElencoFlussiRendicontazione response
        And check elencoFlussiRendicontazione field exists in nodoChiediElencoFlussiRendicontazione response
        And check ppt:nodoChiediElencoFlussiRendicontazioneRisposta field exists in nodoChiediElencoFlussiRendicontazione response
        #And retrieve session token from $nodoChiediElencoFlussiRendicontazioneResponse.url

    @pagoPa     
    Scenario: Send nodoChiediFlussiRendicontazione1
        Given the Send nodoChiediElencoFlussiRendicontazione scenario executed successfully
        And initial XML nodoChiediFlussoRendicontazione
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediFlussoRendicontazione>
                    <identificativoIntermediarioPA>11111111111</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>1000recordElenco</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoFlusso>2022-03-1040000000001-2083</identificativoFlusso>
                </ws:nodoChiediFlussoRendicontazione>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediFlussoRendicontazione to nodo-dei-pagamenti
        Then verify the HTTP status code of nodoChiediFlussoRendicontazione response is 200
        And check ppt:nodoChiediFlussoRendicontazioneRisposta field exists in nodoChiediFlussoRendicontazione response


            