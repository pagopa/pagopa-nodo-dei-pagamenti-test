Feature: Semantic checks KO for nodoPAChiediInformativaPA 266
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_2
    Scenario Outline: Check PACIPASEM2
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoPAChiediInformativaPA response
        And check faultString is Intermediario dominio disabilitato. of nodoPAChiediInformativaPA response
        Examples:
            | tag                           | tag_value       | SoapUI     |
            | identificativoIntermediarioPA | INT_NOT_ENABLED | PACIPASEM2 |