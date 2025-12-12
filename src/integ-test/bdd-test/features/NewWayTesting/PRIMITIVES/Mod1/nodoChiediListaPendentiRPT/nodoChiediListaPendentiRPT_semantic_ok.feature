Feature: Semantic checks for nodoChiediListaPendentiRPT - OK 1428

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCLPROK @MOD1SEMNCLPROK_1
    Scenario Outline: Check semantic errors for nodoChiediListaPendentiRPT primitive
        Given from body with datatable vertical nodoChiediListaPendentiRPT initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444444    |
            | dimensioneLista                       | 10             |
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