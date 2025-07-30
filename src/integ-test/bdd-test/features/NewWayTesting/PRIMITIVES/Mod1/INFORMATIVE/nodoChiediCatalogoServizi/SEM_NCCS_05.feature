Feature: Semantic checks KO for nodoChiediCatalogoServizi 219
    Background:
        Given systems up
    
    @runnable
    Scenario: Check SEM_NCCS_05
    Given initial XML nodoChiediCatalogoServizi
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediCatalogoServizi>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>sconosciuto</identificativoCanale>
                <password>pwdpwdpwd</password>
                <!--Optional:-->
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoChiediCatalogoServizi>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti 
    Then check faultCode is PPT_CANALE_SCONOSCIUTO of nodoChiediCatalogoServizi response