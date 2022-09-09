Feature: process tests for nodoChiediCatalogoServizi

    Background:
        Given systems up

    Scenario: Send nodoChiediCatalogoServizi
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediCatalogoServizi>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <!-- questo campo manda in eccezione il Nodo3 ma non il 4 -->
                    <identificativoDominio>00493410583</identificativoDominio>
                </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check ppt:nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response

        Scenario: Send second nodoChiediCatalogoServizi
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediCatalogoServizi>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>44444444444</identificativoDominio>
                </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check ppt:nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response