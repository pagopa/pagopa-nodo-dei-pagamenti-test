Feature: Semantic checks KO for nodoChiediCatalogoServizi 221
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMNCCS @NM1INSEMNCCS_7
    Scenario: Check SEM_NCCS_07
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password | identificativoDominio       |
            | #psp#             | #psp#                          | #canale#             | password | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTENTICAZIONE of nodoChiediCatalogoServizi response