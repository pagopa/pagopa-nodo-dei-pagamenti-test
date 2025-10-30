Feature: Semantic checks KO for nodoChiediCatalogoServizi 220
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMNCCS @NM1INSEMNCCS_6
    Scenario: Check SEM_NCCS_06
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | CANALE_NOT_ENABLED   | #password# | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_CANALE_DISABILITATO of nodoChiediCatalogoServizi response