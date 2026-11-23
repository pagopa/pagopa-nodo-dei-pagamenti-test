Feature: Semantic checks KO for nodoChiediCatalogoServizi 232
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SINCCSKO @MOD1SINCCSKO_7
    Scenario Outline: Check SIN_NCCS_07
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        And <elem> with <value> in nodoChiediCatalogoServizi
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCatalogoServizi response
        Examples:
            | elem                           | value | soapUI test |
            | identificativoIntermediarioPSP | None  | SIN_NCCS_07 |