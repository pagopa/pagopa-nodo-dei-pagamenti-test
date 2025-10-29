Feature: Semantic checks KO for nodoChiediCatalogoServizi 217
    Background:
        Given systems up

    @ALL @FLOW @FLOW_FULL @NM1 @NM1INSEMNCCS @NM1INSEMNCCS_3
    Scenario: Check SEM_NCCS_03
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | sconosciuto                    | #canale#             | #password# | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of nodoChiediCatalogoServizi response