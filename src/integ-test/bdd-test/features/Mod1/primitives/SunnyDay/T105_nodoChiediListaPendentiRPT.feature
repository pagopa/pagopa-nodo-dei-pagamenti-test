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
                <rangeDa>#yesterday#</rangeDa>
                <rangeA>#timedate#</rangeA>
                <dimensioneLista>5</dimensioneLista>
            </ws:nodoChiediListaPendentiRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoChiediListaPendentiRPT response