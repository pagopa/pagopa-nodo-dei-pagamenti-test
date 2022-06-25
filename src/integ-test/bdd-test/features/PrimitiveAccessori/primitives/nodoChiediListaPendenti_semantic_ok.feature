Feature: Semantic checks for nodoChiediListaPendentiRPT - OK

    Background:
        Given systems up

    Scenario Outline: Check semantic errors for nodoChiediListaPendentiRPT primitive
        Given initial XML nodoChiediListaPendentiRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header />
                <soapenv:Body>
                    <ws:nodoChiediListaPendentiRPT>
                        <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                        <password>pwdpwdpwd</password>
                        <identificativoDominio>44444444444</identificativoDominio>
                        <rangeDa>2001-02-02T12:00:00</rangeDa>
                        <rangeA>2500-12-12T12:00:00</rangeA>
                        <dimensioneLista>10</dimensioneLista>
                    </ws:nodoChiediListaPendentiRPT>
                </soapenv:Body>
            </soapenv:Envelope>
            """