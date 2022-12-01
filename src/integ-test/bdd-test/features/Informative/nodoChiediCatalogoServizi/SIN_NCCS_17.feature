Feature: Semantic checks KO for nodoChiediCatalogoServizi
    Background:
        Given systems up

    @midRunnable
    Scenario: Check SIN_NCCS_17
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
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And identificativoDominio with None in nodoChiediCatalogoServizi
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
