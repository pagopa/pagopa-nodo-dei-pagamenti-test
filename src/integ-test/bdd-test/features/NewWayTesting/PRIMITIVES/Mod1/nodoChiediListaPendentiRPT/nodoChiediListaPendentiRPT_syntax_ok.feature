Feature: Syntax checks for nodoChiediListaPendentiRPT - OK 1430

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SINCLPROK @MOD1SINCLPROK_1
    Scenario: Check valid response for nodoChiediListaPendenti primitive [CLPRPTSIN15]
        Given from body with datatable vertical nodoChiediListaPendentiRPT initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | 44444444444    |
            | identificativoStazioneIntermediarioPA | 44444444444_01 |
            | password                              | #password#     |
            | identificativoDominio                 | 44444444444    |
            | dimensioneLista                       | 10             |
        And identificativoDominio with None in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediListaPendentiRPT response