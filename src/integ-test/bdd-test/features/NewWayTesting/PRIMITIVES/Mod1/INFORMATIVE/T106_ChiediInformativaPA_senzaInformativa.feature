Feature: T106_ChiediInformativaPA_senzaInformativa 483

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPA @MOD1SEMCIPA_2
    Scenario: Send nodoChiediInformativaPA
        Given from body with datatable horizontal nodoChiediInformativaPA_full initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio |
            | #psp#             | #psp#                          | #canale#             | #password# | 00000000000           |
        When PSP sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoChiediInformativaPA response
        And check ppt:nodoChiediInformativaPARisposta field exists in nodoChiediInformativaPA response
        And check fault field not exists in nodoChiediInformativaPA response