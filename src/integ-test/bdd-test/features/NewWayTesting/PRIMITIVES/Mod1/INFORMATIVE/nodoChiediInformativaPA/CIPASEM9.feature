Feature: Semantic checks KO for nodoChiediInformativaPA 254
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMCIPA @NM1INSEMCIPA_9
    Scenario Outline: Check SCheck CIPASEM9
        Given from body with datatable horizontal nodoChiediInformativaPA_full initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   | identificativoDominio       |
            | #psp#             | #psp#                          | #canale#             | #password# | #creditor_institution_code# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_DOMINIO_DISABILITATO of nodoChiediInformativaPA response
        Examples:
            | elem                  | value       | soapUI test |
            | identificativoDominio | NOT_ENABLED | CIPASEM9    |