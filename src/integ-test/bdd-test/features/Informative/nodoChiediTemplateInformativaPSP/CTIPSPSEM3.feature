Feature: Semantic checks KO for nodoChiediInformativaPA 258
    Background:
        Given systems up
    
    @runnable
    Scenario: Check CTIPSPSEM3
    Given initial XML nodoChiediTemplateInformativaPSP
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>sconosciuto</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti 
    Then check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of nodoChiediTemplateInformativaPSP response