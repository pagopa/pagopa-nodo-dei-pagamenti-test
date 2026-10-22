Feature: Semantic checks KO for nodoPAChiediInformativaPA 265
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_1
    Scenario Outline: Check PACIPASEM1
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PA_SCONOSCIUTO of nodoPAChiediInformativaPA response
        And check faultString is Identificativo intermediario dominio sconosciuto. of nodoPAChiediInformativaPA response
        Examples:
            | tag                           | tag_value   | SoapUI     |
            | identificativoIntermediarioPA | sconosciuto | PACIPASEM1 |