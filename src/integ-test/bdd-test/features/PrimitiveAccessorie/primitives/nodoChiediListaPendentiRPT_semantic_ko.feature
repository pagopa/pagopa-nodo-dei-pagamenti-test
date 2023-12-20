Feature: Semantic checks for nodoChiediListaPendentiRPT - KO

    Background:
        Given systems up
        And initial XML nodoChiediListaPendentiRPT
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
                        <rangeA>2001-12-12T12:00:00</rangeA>
                        <dimensioneLista>10</dimensioneLista>
                    </ws:nodoChiediListaPendentiRPT>
                </soapenv:Body>
            </soapenv:Envelope>
            """
@runnable @pippoalf
    Scenario Outline: Check semantic errors for nodoChiediListaPendentiRPT primitive
        Given <tag> with <tag_value> in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check faultCode is <error> of nodoChiediListaPendentiRPT response
        Examples:
            | tag                                   | tag_value            | error                             | soapUI test |
            | identificativoIntermediarioPA         | 12345678901          | PPT_INTERMEDIARIO_PA_SCONOSCIUTO  | CLPRPTSEM1  |
            | identificativoIntermediarioPA         | INT_NOT_ENABLED      | PPT_INTERMEDIARIO_PA_DISABILITATO | CLPRPTSEM2  |
            | identificativoStazioneIntermediarioPA | unknownStation       | PPT_STAZIONE_INT_PA_SCONOSCIUTA   | CLPRPTSEM3  |
            | identificativoStazioneIntermediarioPA | STAZIONE_NOT_ENABLED | PPT_STAZIONE_INT_PA_DISABILITATA  | CLPRPTSEM4  |
            | password                              | wrongPassword        | PPT_AUTENTICAZIONE                | CLPRPTSEM5  |
            | identificativoDominio                 | 12345678922          | PPT_DOMINIO_SCONOSCIUTO           | CLPRPTSEM6  |
            | identificativoDominio                 | NOT_ENABLED          | PPT_DOMINIO_DISABILITATO          | CLPRPTSEM7  |
            | identificativoIntermediarioPA         | 77777777777          | PPT_AUTORIZZAZIONE                | CLPRPTSEM13 |
@runnable
    # [CLPRPTSEM8]
    Scenario: Check semantic errors for nodoChiediListaPendentiRPT primitive
        Given rangeDa with 2005-01-01T12:00:00 in nodoChiediListaPendentiRPT
        And rangeA with 2004-01-01T12:00:00 in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SEMANTICA of nodoChiediListaPendentiRPT response