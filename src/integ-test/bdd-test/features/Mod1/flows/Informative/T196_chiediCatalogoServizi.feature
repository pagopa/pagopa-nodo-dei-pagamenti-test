Feature: process tests for nodoChiediCatalogoServizi 318

    Background:
        Given systems up

@runnable
    Scenario: Send nodoChiediCatalogoServizi
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediCatalogoServizi>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <!-- questo campo manda in eccezione il Nodo3 ma non il 4 -->
                    <identificativoDominio>00493410583</identificativoDominio>
                </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response

@runnable
        Scenario: Send second nodoChiediCatalogoServizi
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediCatalogoServizi>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
                </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response