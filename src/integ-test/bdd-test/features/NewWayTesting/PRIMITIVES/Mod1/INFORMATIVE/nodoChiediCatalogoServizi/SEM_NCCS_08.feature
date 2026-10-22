Feature: Semantic checks KO for nodoChiediCatalogoServizi 222
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCCSKO @MOD1SEMNCCSKO_8
    Scenario: Check SEM_NCCS_08
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | 80000000001                    | #canale#             | #password# | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTORIZZAZIONE of nodoChiediCatalogoServizi response