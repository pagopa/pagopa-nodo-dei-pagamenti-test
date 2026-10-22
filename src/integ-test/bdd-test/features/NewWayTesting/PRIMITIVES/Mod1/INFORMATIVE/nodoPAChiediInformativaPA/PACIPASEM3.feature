Feature: Semantic checks KO for nodoPAChiediInformativaPA 267
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMPACIPAKO_3
    Scenario Outline: Check PACIPASEM3
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA | identificativoStazioneIntermediarioPA | password   | identificativoDominio       |
            | #intermediarioPA#             | #id_station#                          | #password# | #creditor_institution_code# |
        And <tag> with <tag_value> in nodoPAChiediInformativaPA
        When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoPAChiediInformativaPA response
        And check faultString is IdentificativoStazioneRichiedente sconosciuto. of nodoPAChiediInformativaPA response
        Examples:
            | tag                                   | tag_value   | SoapUI     |
            | identificativoStazioneIntermediarioPA | sconosciuta | PACIPASEM3 |