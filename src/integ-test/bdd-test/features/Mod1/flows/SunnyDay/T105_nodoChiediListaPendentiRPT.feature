Feature: process tests for nodoChiediListaPendentiRPT
    Background:
        Given systems up
    Scenario: Execute nodoChiediListaPendentiRPT request
        Given initial XML nodoChiediListaPendentiRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediListaPendentiRPT>
                <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>44444444444</identificativoDominio>
                <rangeDa>#yesterday_date#</rangeDa>
                <rangeA>#timedate#</rangeA>
                <dimensioneLista>5</dimensioneLista>
            </ws:nodoChiediListaPendentiRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediListaPendentiRPT response
        And check listaRPTPendenti field exists in nodoChiediListaPendentiRPT response
        And check identificativoUnivocoVersamento field exists in nodoChiediListaPendentiRPT response