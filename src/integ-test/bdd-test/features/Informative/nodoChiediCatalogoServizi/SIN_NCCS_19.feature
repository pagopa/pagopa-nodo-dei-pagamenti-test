Feature: Semantic checks KO for nodoChiediCatalogoServizi
    Background:
        Given systems up
    
    Scenario: Check SIN_NCCS_19
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
                <!--Optional:-->
                <identificativoDominio>aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa</identificativoDominio>
            </ws:nodoChiediCatalogoServizi>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti 
    Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCatalogoServizi response