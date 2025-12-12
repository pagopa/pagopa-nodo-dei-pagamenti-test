Feature: Semantic checks KO for nodoPAChiediInformativaPA 269
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_5
    Scenario Outline: Check PACIPASEM5
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTENTICAZIONE of nodoPAChiediInformativaPA response
        And check description is Password sconosciuta o errata of nodoPAChiediInformativaPA response
        Examples:
            | tag      | tag_value | SoapUI     |
            | password | passwordd | PACIPASEM5 |