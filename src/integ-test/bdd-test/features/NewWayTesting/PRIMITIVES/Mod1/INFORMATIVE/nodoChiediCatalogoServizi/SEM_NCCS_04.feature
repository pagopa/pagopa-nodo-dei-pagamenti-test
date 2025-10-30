Feature: Semantic checks KO for nodoChiediCatalogoServizi 218
    Background:
        Given systems up

    @ALL @PRIMITIVE @NM1 @NM1INSEMNCCS @NM1INSEMNCCS_4
    Scenario: Check SEM_NCCS_04
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | INT_NOT_ENABLED                | #canale#             | #password# | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of nodoChiediCatalogoServizi response