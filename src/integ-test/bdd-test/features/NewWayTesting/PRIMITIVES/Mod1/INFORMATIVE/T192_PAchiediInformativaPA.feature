Feature: process tests for nodoPAChiediInformativaPA 316

    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1CIPA @MOD1CIPA_1
    Scenario: Send nodoPAChiediInformativaPA
        Given from body with datatable horizontal nodoPAChiediInformativaPA_full initial XML nodoPAChiediInformativaPA
            | identificativoIntermediarioPA         | identificativoStazioneIntermediarioPA | password   | identificativoDominio                 |
            | #creditor_institution_code_secondary# | #id_station_secondary#                | #password# | #creditor_institution_code_secondary# |
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoPAChiediInformativaPA response
