Feature: Semantic checks KO for nodoChiediCatalogoServizi 219
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCCSKO @MOD1SEMNCCSKO_5
    Scenario: Check SEM_NCCS_05
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | sconosciuto          | #password# | #creditor_institution_code# |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_CANALE_SCONOSCIUTO of nodoChiediCatalogoServizi response

        