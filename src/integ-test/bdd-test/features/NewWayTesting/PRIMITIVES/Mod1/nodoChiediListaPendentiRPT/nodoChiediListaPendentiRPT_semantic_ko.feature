Feature: Semantic checks for nodoChiediListaPendentiRPT - KO 1427

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCLPRKO @MOD1SEMNCLPRKO_1
    Scenario Outline: Check semantic errors for nodoChiediListaPendentiRPT primitive
        Given from body with datatable vertical nodoChiediListaPendentiRPT initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444444    |
            | dimensioneLista                       | 10             |
        And <tag> with <tag_value> in nodoChiediListaPendentiRPT
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



    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCLPRKO @MOD1SEMNCLPRKO_2
    Scenario: Check semantic errors for nodoChiediListaPendentiRPT primitive [CLPRPTSEM8]
        Given from body with datatable vertical nodoChiediListaPendentiRPT initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444444    |
            | dimensioneLista                       | 10             |
        And rangeDa with 2005-01-01T12:00:00 in nodoChiediListaPendentiRPT
        And rangeA with 2004-01-01T12:00:00 in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SEMANTICA of nodoChiediListaPendentiRPT response