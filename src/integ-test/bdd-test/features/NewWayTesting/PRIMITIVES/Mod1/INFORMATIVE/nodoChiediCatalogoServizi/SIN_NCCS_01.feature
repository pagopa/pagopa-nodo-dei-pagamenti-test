Feature: Semantic checks KO for nodoChiediCatalogoServizi 226
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SINCCSKO @MOD1SINCCSKO_1
    Scenario Outline: Check SIN_NCCS_01
        Given from body with datatable horizontal nodoChiediCatalogoServizi_full initial XML nodoChiediCatalogoServizi
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        And <attribute> set <value> for <elem> in nodoChiediCatalogoServizi
        When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCatalogoServizi response
        Examples:
            | elem             | attribute     | value                                     | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | SIN_NCCS_01 |


