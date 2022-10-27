Feature: Semantic checks KO for nodoChiediInformativaPA
    Background:
        Given systems up
    
    Scenario: Check CTIPSPSEM8
    Given initial XML nodoChiediTemplateInformativaPSP
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>91000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti 
    Then check faultCode is PPT_AUTORIZZAZIONE of nodoChiediTemplateInformativaPSP response