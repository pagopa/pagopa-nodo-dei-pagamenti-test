Feature: Semantic checks KO for nodoChiediInformativaPA 253
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMCIPAKO_8
    Scenario Outline: Check SCheck CIPASEM8
        Given from body with datatable horizontal nodoChiediInformativaPA_full initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoChiediInformativaPA response
        Examples:
            | elem                  | value       | soapUI test |
            | identificativoDominio | sconosciuto | CIPASEM8    |