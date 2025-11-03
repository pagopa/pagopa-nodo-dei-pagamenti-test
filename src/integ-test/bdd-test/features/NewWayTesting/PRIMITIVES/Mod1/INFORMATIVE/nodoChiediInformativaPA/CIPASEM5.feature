Feature: Semantic checks KO for nodoChiediInformativaPA 250
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMCIPAKO_5
    Scenario Outline: Check SCheck CIPASEM5
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canaleRtPush#       | #password# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_CANALE_SCONOSCIUTO of nodoChiediInformativaPA response
        Examples:
            | elem                 | value       | soapUI test |
            | identificativoCanale | sconosciuto | CIPASEM5    |