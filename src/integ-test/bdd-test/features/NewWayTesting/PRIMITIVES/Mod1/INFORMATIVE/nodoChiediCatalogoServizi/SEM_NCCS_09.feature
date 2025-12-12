Feature: Semantic checks KO for nodoChiediCatalogoServizi 223
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMNCCSKO @MOD1SEMNCCSKO_9
    Scenario: Check SEM_NCCS_09
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio |
            | #psp#             | #psp#                          | #canale#             | #password# | sconosciuto           |
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoChiediCatalogoServizi response