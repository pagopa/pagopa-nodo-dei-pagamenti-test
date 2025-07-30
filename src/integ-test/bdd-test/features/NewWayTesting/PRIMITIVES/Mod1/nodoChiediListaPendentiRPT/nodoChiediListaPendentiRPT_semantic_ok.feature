Feature: Semantic checks for nodoChiediListaPendentiRPT - OK 1428

    Background:
        Given systems up

@runnable
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
                        <rangeDa>2020-08-01T12:00:00</rangeDa>
                        <rangeA>2020-08-01T12:00:00</rangeA>
                        <dimensioneLista>10</dimensioneLista>
                    </ws:nodoChiediListaPendentiRPT>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And rangeDa with <rangeDa_value> in nodoChiediListaPendentiRPT
        And rangeA with <rangeA_value> in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediListaPendentiRPT response
        Examples:
            | rangeDa_value       | rangeA_value        | soapUI test |
            | 2100-01-01T12:00:00 | 2300-01-01T12:00:00 | CLPRPTSEM9  |
            | 2100-01-01T12:00:00 | 2300-01-01T12:00:00 | CLPRPTSEM10 |
            | 1999-12-31T12:00:00 | 2001-01-31T12:00:00 | CLPRPTSEM11 |
            | 2001-12-31T12:00:00 | 2017-06-30T12:00:00 | CLPRPTSEM12 |