Feature: Syntax check KO for nodoChiediListaPendentiRPT

    Background:
        Given systems up

    Scenario: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediListaPendentiRPT primitive
        Given initial XML nodoChiediListaPendentiRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:wss="http://ws.pagamenti.telematici.gov/wsshead/">
                <soapenv:Header />
                <soapenv:Body>
                    <wss:nodoChiediListaPendentiRPT>
                        <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                        <password>pwdpwdpwd</password>
                        <dimensioneLista>10</dimensioneLista>
                    </wss:nodoChiediListaPendentiRPT>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediListaPendentiRPT response

    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediListaPendentiRPT primitive
        Given initial XML nodoChiediListaPendentiRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
                <soapenv:Header />
                <soapenv:Body>
                    <ws:nodoChiediListaPendentiRPT>
                        <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                        <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                        <password>pwd</password>
                        <dimensioneLista>10</dimensioneLista>
                    </ws:nodoChiediListaPendentiRPT>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <tag_value> in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediListaPendentiRPT response
        Examples:
            | tag                                   | tag_value                            | soapUI test |
            | soapenv:Body                          | Empty                                | CLPRPTSIN2  |
            | soapenv:Body                          | None                                 | CLPRPTSIN3  |
            | ws:nodoChiediListaPendentiRPT         | Empty                                | CLPRPTSIN4  |
            | identificativoIntermediarioPA         | None                                 | CLPRPTSIN5  |
            | identificativoIntermediarioPA         | Empty                                | CLPRPTSIN6  |
            | identificativoIntermediarioPA         | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CLPRPTSIN7  |
            | identificativoStazioneIntermediarioPA | None                                 | CLPRPTSIN8  |
            | identificativoStazioneIntermediarioPA | Empty                                | CLPRPTSIN9  |
            | identificativoStazioneIntermediarioPA | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CLPRPTSIN10 |
            | password                              | None                                 | CLPRPTSIN11 |
            | password                              | Empty                                | CLPRPTSIN12 |
            | password                              | aaaaaaa                              | CLPRPTSIN13 |
            | password                              | aaaaaaaaaaaaaaaa                     | CLPRPTSIN14 |
            # CHANGE IN OK | identificativoDominio                 | None                                 | CLPRPTSIN15 |
            | identificativoDominio                 | Empty                                | CLPRPTSIN16 |
            | identificativoDominio                 | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CLPRPTSIN17 |
            | rangeDA                               | Empty                                | CLPRPTSIN18 |
            | rangeDA                               | 2021:12:12                           | CLPRPTSIN19 |
            | rangeDA                               | 12-12-2021                           | CLPRPTSIN19 |
            | rangeDA                               | 2021-12-12T13:04:21                  | CLPRPTSIN19 |
            | rangeA                                | Empty                                | CLPRPTSIN20 |
            | rangeA                                | 2021:12:12                           | CLPRPTSIN21 |
            | rangeA                                | 12-12-2021                           | CLPRPTSIN21 |
            | rangeA                                | 2021-12-12T13:04:21                  | CLPRPTSIN21 |
            | dimensioneLista                       | Empty                                | CLPRPTSIN22 |
            | dimensioneLista                       | A                                    | CLPRPTSIN23 |
            | dimensioneLista                       | 2.51                                 | CLPRPTSIN24 |
            | dimensioneLista                       | -11                                  | CLPRPTSIN25 |
            | dimensioneLista                       | 0                                    | CLPRPTSIN26 |

