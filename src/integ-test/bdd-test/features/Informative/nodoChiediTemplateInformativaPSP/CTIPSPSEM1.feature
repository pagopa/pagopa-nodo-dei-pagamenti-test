Feature: Semantic checks KO for nodoChiediInformativaPA
    Background:
        Given systems up
    
    @runnable
    Scenario: Check CTIPSPSEM1 
    Given initial XML nodoChiediTemplateInformativaPSP
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>sconosciuto</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti 
    Then check faultCode is PPT_PSP_SCONOSCIUTO of nodoChiediTemplateInformativaPSP response