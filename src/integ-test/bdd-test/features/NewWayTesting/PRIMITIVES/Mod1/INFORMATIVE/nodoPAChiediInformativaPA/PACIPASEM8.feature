Feature: Semantic checks KO for nodoPAChiediInformativaPA 272
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_8
    Scenario Outline: Check PACIPASEM8
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTORIZZAZIONE of nodoPAChiediInformativaPA response
        And check description is Configurazione pa-intermediario-stazione non corretta of nodoPAChiediInformativaPA response
        Examples:
            | tag                   | tag_value   | SoapUI     |
            | identificativoDominio | 90000000001 | PACIPASEM8 |