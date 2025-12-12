Feature: process tests for nodoChiediCatalogoServizi 318

    Background:
        Given systems up


    @ALL @PRIMITIVE @MD1 @MOD1CICSE @MOD1CICSE_1
    Scenario: Send nodoChiediCatalogoServizi
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio |
            | #psp#             | #psp#                          | #canale#             | #password# | 00493410583           |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response


    @ALL @PRIMITIVE @MOD1 @MOD1CICSE @MOD1CICSE_2
    Scenario: Send second nodoChiediCatalogoServizi
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio           |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code_old# |
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response