Feature: Syntax checks for nodoChiediInformativaPA - KO 255
    Background:
        Given systems up

    @runnable
    Scenario Outline: Check error for nodoChiediInformativaPA primitive
        Given initial XML nodoChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediInformativaPA>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediInformativaPA response
        And check faultString is Errore di sintassi extra XSD. of nodoChiediInformativaPA response
        Examples:
            | elem                           | value                                | SoapUI    |
            | soapenv:Body                   | Empty                                | CIPASIN2  |
            | ws:nodoChiediInformativaPA     | Empty                                | CIPASIN4  |
            | identificativoPSP              | Empty                                | CIPASIN5  |
            | identificativoPSP              | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN6  |
            | identificativoIntermediarioPSP | None                                 | CIPASIN7  |
            | identificativoIntermediarioPSP | Empty                                | CIPASIN8  |
            | identificativoIntermediarioPSP | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN9  |
            | identificativoCanale           | None                                 | CIPASIN10 |
            | identificativoCanale           | Empty                                | CIPASIN11 |
            | identificativoCanale           | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN12 |
            | password                       | None                                 | CIPASIN13 |
            | password                       | Empty                                | CIPASIN14 |
            | password                       | ertg5d3                              | CIPASIN15 |
            | password                       | d45ti85ght9retv4                     | CIPASIN16 |
            | identificativoDominio          | Empty                                | CIPASIN17 |
            | identificativoDominio          | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN18 |

    @runnable
    Scenario: Check error for nodoChiediInformativaPA primitive-[CIPASIN1]
        Given initial XML nodoChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediInformativaPA response
        And check faultString is Errore di sintassi extra XSD. of nodoChiediInformativaPA response

    @runnable
    Scenario: Check error for nodoChiediInformativaPA primitive-[CIPASIN3]
        Given initial XML nodoChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
            <soapenv:Header/>
            <!--<soapenv:Body>
            <ws:nodoChiediInformativaPA>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            </ws:nodoChiediInformativaPA>
            </soapenv:Body>-->
            </soapenv:Envelope>
            """
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediInformativaPA response
        And check faultString is Errore di sintassi extra XSD. of nodoChiediInformativaPA response


