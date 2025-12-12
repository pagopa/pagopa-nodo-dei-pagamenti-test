Feature: T106_ChiediInformativaPA_soloObbligatori 484

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1CIPA @MOD1CIPA_3
    Scenario: Send nodoChiediInformativaPA
        Given from body with datatable horizontal nodoChiediInformativaPA_full initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        When PSP sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoChiediInformativaPA response
        And check ppt:nodoChiediInformativaPARisposta field exists in nodoChiediInformativaPA response
        And check fault field not exists in nodoChiediInformativaPA response


    @ALL @PRIMITIVE @MOD1 @MOD1CIPA @MOD1CIPA_4
    Scenario: Send nodoChiediInformativaPA senza identificativoDominio
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And identificativoPSP with None in nodoChiediInformativaPA
        When PSP sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoChiediInformativaPA response
        And check ppt:nodoChiediInformativaPARisposta field exists in nodoChiediInformativaPA response
        And check fault field not exists in nodoChiediInformativaPA response