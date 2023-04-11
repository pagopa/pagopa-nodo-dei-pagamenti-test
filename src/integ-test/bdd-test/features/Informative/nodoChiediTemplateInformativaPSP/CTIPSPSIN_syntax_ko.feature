Feature: Syntax checks KO for nodoChiediTemplateInformativaPSP
    Background:
        Given systems up

    @runnable
    Scenario Outline: Check error for nodoChiediTemplateInformativaPSP primitive
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediTemplateInformativaPSP>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem                                | value                                | SoapUI      |
            | soapenv:Body                        | Empty                                | CTIPSPSIN2  |
            | ws:nodoChiediTemplateInformativaPSP | Empty                                | CTIPSPSIN4  |
            | identificativoPSP                   | None                                 | CTIPSPSIN6  |
            | identificativoPSP                   | Empty                                | CTIPSPSIN7  |
            | identificativoPSP                   | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN8  |
            | identificativoIntermediarioPSP      | None                                 | CTIPSPSIN9  |
            | identificativoIntermediarioPSP      | Empty                                | CTIPSPSIN10 |
            | identificativoIntermediarioPSP      | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN11 |
            | identificativoCanale                | None                                 | CTIPSPSIN12 |
            | identificativoCanale                | Empty                                | CTIPSPSIN13 |
            | identificativoCanale                | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN14 |
            | password                            | None                                 | CTIPSPSIN15 |
            | password                            | Empty                                | CTIPSPSIN16 |
            | password                            | s7fhr2                               | CTIPSPSIN17 |
            | password                            | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN18 |

    @runnable
    Scenario: Check error for nodoChiediTemplateInformativaPSP primitive-[CTIPSPSIN1]
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:nodoChiediTemplateInformativaPSP>ciao</ppt:nodoChiediTemplateInformativaPSP>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoChiediTemplateInformativaPSP>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response

    @runnable
    Scenario: Check error for nodoChiediTemplateInformativaPSP primitive-[CTIPSPSIN3]
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
            <soapenv:Header/>
            <!--<soapenv:Body>
            <ws:nodoChiediTemplateInformativaPSP>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </ws:nodoChiediTemplateInformativaPSP>
            </soapenv:Body>-->
            </soapenv:Envelope>
            """
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response

    @runnable
    Scenario: Check error for nodoChiediTemplateInformativaPSP primitive-[CTIPSPSIN5]
        Given initial XML nodoChiediTemplateInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response
