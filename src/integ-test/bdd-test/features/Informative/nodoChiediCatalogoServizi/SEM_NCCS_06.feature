Feature: Semantic checks KO for nodoChiediCatalogoServizi
    Background:
        Given systems up
    
    @runnable
    Scenario: Check SEM_NCCS_06
    Given initial XML nodoChiediCatalogoServizi
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediCatalogoServizi>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>CANALE_NOT_ENABLED</identificativoCanale>
                <password>pwdpwdpwd</password>
                <!--Optional:-->
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoChiediCatalogoServizi>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti 
    Then check faultCode is PPT_CANALE_DISABILITATO of nodoChiediCatalogoServizi response