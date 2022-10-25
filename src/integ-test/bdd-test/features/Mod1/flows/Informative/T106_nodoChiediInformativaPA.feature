Feature: process tests for nodoChiediInformativaPA

    Background:
        Given systems up
<<<<<<< HEAD

=======
@runnable
>>>>>>> origin/feature/gherkin-with-behavetag
    Scenario: Send nodoChiediInformativaPA
        Given initial XML nodoChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediInformativaPA>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_03</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>90000000001</identificativoDominio>
                </ws:nodoChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoChiediInformativaPA response
        And check ppt:nodoChiediInformativaPARisposta field exists in nodoChiediInformativaPA response
        And check fault field not exists in nodoChiediInformativaPA response