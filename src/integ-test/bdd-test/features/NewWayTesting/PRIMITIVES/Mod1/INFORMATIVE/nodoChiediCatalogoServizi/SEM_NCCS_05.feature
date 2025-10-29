Feature: Semantic checks KO for nodoChiediCatalogoServizi 219
    Background:
        Given systems up

    @ALL @FLOW @FLOW_FULL @NM1 @NM1INSEMNCCS @NM1INSEMNCCS_5
    Scenario: Check SEM_NCCS_05
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | sconosciuto          | #password# | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_CANALE_SCONOSCIUTO of nodoChiediCatalogoServizi response