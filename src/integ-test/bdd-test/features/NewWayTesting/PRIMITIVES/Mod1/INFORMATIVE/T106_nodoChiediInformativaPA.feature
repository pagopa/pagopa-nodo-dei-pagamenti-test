Feature: process tests for nodoChiediInformativaPA 315

    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1CIPAKO @MOD1CIPAKO_1
    Scenario: Send nodoChiediInformativaPA
        Given from body with datatable horizontal nodoChiediInformativaPA_full initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio                 |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code_secondary# |
        When PSP sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoChiediInformativaPA response
        And check ppt:nodoChiediInformativaPARisposta field exists in nodoChiediInformativaPA response
        And check fault field not exists in nodoChiediInformativaPA response