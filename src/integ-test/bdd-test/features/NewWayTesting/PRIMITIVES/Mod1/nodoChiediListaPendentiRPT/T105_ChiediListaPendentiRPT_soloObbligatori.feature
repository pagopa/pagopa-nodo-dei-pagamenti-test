Feature: T105_ChiediListaPendentiRPT_soloObbligatori 612
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SINCLPROK @MOD1SINCLPROK_2
    Scenario: Execute nodoChiediListaPendentiRPT request
        Given from body with datatable vertical nodoChiediListaPendentiRPT_full initial XML nodoChiediListaPendentiRPT
            | identificativoIntermediarioPA         | #creditor_institution_code# |
            | identificativoStazioneIntermediarioPA | #id_station#                |
            | password                              | #password#                  |
            | identificativoDominio                 | #creditor_institution_code# |
            | dimensioneLista                       | 5                           |
            | rangeDa                               | #yesterday_date#            |
            | rangeA                                | #tomorrow_date#             |
        And identificativoDominio with None in nodoChiediListaPendentiRPT
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        Then check totRestituiti field exists in nodoChiediListaPendentiRPT response
        And check listaRPTPendenti field exists in nodoChiediListaPendentiRPT response
        And check identificativoUnivocoVersamento field exists in nodoChiediListaPendentiRPT response