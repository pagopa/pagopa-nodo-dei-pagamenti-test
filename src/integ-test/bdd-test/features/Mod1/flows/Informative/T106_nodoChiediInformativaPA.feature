Feature: process tests for nodoChiediInformativaPA

    Background:
        Given systems up
@runnable @independent
    Scenario: Send nodoChiediInformativaPA
        Given initial XML nodoChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediInformativaPA>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code_secondary#</identificativoDominio>
                </ws:nodoChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoChiediInformativaPA response
        And check ppt:nodoChiediInformativaPARisposta field exists in nodoChiediInformativaPA response
        And check fault field not exists in nodoChiediInformativaPA response