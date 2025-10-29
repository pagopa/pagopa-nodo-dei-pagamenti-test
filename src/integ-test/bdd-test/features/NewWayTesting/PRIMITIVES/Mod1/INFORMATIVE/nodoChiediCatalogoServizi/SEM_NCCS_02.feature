Feature: Semantic checks KO for nodoChiediCatalogoServizi 216
    Background:
        Given systems up

    @ALL @FLOW @FLOW_FULL @NM1 @NM1INSEMNCCS @NM1INSEMNCCS_2
    Scenario: Check SEM_NCCS_02
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | NOT_ENABLED       | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_PSP_DISABILITATO of nodoChiediCatalogoServizi response