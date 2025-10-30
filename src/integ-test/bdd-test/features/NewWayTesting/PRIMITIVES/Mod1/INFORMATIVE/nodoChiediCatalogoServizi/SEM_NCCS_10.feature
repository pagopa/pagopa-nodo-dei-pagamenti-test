Feature: Semantic checks KO for nodoChiediCatalogoServizi 224
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1INSEMNCCS @NM1INSEMNCCS_10
    Scenario: Check SEM_NCCS_10
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio |
            | #psp#             | #psp#                          | #canale#             | #password# | NOT_ENABLED           |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_DISABILITATO of nodoChiediCatalogoServizi response