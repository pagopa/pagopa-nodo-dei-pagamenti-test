Feature: Semantic checks KO for nodoChiediInformativaPA 247
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMCIPAKO_2
    Scenario Outline: Check SCheck CIPASEM2
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canaleRtPush#       | #password# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_PSP_DISABILITATO of nodoChiediInformativaPA response
        Examples:
            | elem              | value       | soapUI test |
            | identificativoPSP | NOT_ENABLED | CIPASEM2    |