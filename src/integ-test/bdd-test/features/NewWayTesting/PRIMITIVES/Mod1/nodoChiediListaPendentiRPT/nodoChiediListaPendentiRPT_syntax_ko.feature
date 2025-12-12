Feature: Syntax checks for nodoChiediListaPendentiRPT - KO 1429

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SINCLPRKO @MOD1SINCLPRKO_1
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediListaPendentiRPT primitive [CLPRPTSIN1]
        Given from body with datatable vertical nodoChiediListaPendentiRPT initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444444    |
            | dimensioneLista                       | 10             |
        And <attribute> set <value> for <elem> in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediListaPendentiRPT response
        Examples:
            | elem             | attribute | value                                       | soapUI test |
            | soapenv:Envelope | xmlns:ws  | http://ws.pagamenti.telematici.gov/wsshead/ | CLPRPTSIN1  |


    @ALL @PRIMITIVE @MOD1 @MOD1SINCLPRKO @MOD1SINCLPRKO_2
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error for nodoChiediListaPendentiRPT primitive
        Given from body with datatable vertical nodoChiediListaPendentiRPT initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444444    |
            | dimensioneLista                       | 10             |
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
            | identificativoDominio                 | Empty                                | CLPRPTSIN16 |
            | identificativoDominio                 | aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa | CLPRPTSIN17 |
            | rangeDa                               | Empty                                | CLPRPTSIN18 |
            | rangeDa                               | 2021:12:12                           | CLPRPTSIN19 |
            | rangeDa                               | 12-12-2021                           | CLPRPTSIN19 |
            | rangeDa                               | 2021-12-12T13:04:21:00               | CLPRPTSIN19 |
            | rangeA                                | Empty                                | CLPRPTSIN20 |
            | rangeA                                | 2021:12:12                           | CLPRPTSIN21 |
            | rangeA                                | 12-12-2021                           | CLPRPTSIN21 |
            | rangeA                                | 2021-12-12T13:04:21:00               | CLPRPTSIN21 |
            | dimensioneLista                       | Empty                                | CLPRPTSIN22 |
            | dimensioneLista                       | A                                    | CLPRPTSIN23 |
            | dimensioneLista                       | 2.51                                 | CLPRPTSIN24 |
            | dimensioneLista                       | -11                                  | CLPRPTSIN25 |
            | dimensioneLista                       | 0                                    | CLPRPTSIN26 |