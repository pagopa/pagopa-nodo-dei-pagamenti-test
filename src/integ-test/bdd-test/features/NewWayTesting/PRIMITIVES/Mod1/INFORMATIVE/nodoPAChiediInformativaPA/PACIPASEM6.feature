Feature: Semantic checks KO for nodoPAChiediInformativaPA 270
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_6
    Scenario Outline: Check PACIPASEM6
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoPAChiediInformativaPA response
        And check faultString is Identificativo Dominio sconosciuto. of nodoPAChiediInformativaPA response
        Examples:
            | tag                   | tag_value   | SoapUI     |
            | identificativoDominio | sconosciuto | PACIPASEM6 |