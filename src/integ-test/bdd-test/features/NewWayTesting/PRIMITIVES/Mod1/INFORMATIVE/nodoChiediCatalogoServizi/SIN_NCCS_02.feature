Feature: Semantic checks KO for nodoChiediCatalogoServizi 227
    Background:
        Given systems up

    @ALL @PRIMITIVE @NM1 @NM1INSINCCS @NM1INSINCCS_2
    Scenario Outline: Check SIN_NCCS_02
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        And <elem1> with <value1> in nodoChiediCatalogoServizi
        And <elem2> with <value2> in nodoChiediCatalogoServizi
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCatalogoServizi response
        Examples:
            | elem1                        | value1 | elem2        | value2 | soapUI test |
            | ws:nodoChiediCatalogoServizi | None   | soapenv:Body | None   | SIN_NCCS_02 |