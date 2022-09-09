Feature: process tests for nodoChiediTemplateInformativaPSP

    Background:
        Given systems up

    Scenario: Send nodoChiediTemplateInformativaPSP
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>idPsp1</identificativoPSP>
                    <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check xmlTemplateInformativa field exists in nodoChiediTemplateInformativaPSP response
        And check ppt:nodoChiediTemplateInformativaPSPRisposta field exists in nodoChiediTemplateInformativaPSP response

        Scenario: Send second nodoChiediTemplateInformativaPSP
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediTemplateInformativaPSP>
                    <identificativoPSP>IDPSPFNZ</identificativoPSP>
                    <identificativoIntermediarioPSP>91000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>91000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check xmlTemplateInformativa field exists in nodoChiediTemplateInformativaPSP response
        And check ppt:nodoChiediTemplateInformativaPSPRisposta field exists in nodoChiediTemplateInformativaPSP response
        And check fault field not exists in nodoChiediTemplateInformativaPSP response