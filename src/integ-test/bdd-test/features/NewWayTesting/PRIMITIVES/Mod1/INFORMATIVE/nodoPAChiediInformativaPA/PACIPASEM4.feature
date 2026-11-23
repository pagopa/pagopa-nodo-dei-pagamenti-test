Feature: Semantic checks KO for nodoPAChiediInformativaPA 268
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_4
    Scenario Outline: Check PACIPASEM4
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoPAChiediInformativaPA response
        And check faultString is Stazione disabilitata. of nodoPAChiediInformativaPA response
        Examples:
            | tag                                   | tag_value      | SoapUI     |
            | identificativoStazioneIntermediarioPA | 11111122222_01 | PACIPASEM4 |