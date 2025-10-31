Feature: Semantic checks KO for nodoChiediInformativaPA 251
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMCIPA @NM1INSEMCIPA_6
    Scenario Outline: Check SCheck CIPASEM6
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canaleRtPush#       | #password# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_CANALE_DISABILITATO of nodoChiediInformativaPA response
        Examples:
            | elem                 | value              | soapUI test |
            | identificativoCanale | CANALE_NOT_ENABLED | CIPASEM6    |