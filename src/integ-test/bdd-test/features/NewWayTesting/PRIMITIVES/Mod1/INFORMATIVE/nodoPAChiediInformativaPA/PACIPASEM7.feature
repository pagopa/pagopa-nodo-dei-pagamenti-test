Feature: Semantic checks KO for nodoPAChiediInformativaPA 271
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_7
    Scenario Outline: Check PACIPASEM7
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_DISABILITATO of nodoPAChiediInformativaPA response
        And check faultString is Dominio disabilitato. of nodoPAChiediInformativaPA response
        Examples:
            | tag                   | tag_value   | SoapUI     |
            | identificativoDominio | NOT_ENABLED | PACIPASEM7 |