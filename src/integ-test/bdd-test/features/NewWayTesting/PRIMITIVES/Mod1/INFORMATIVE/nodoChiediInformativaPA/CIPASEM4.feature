Feature: Semantic checks KO for nodoChiediInformativaPA 249
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMCIPA @NM1INSEMCIPA_4
    Scenario Outline: Check SCheck CIPASEM4
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canaleRtPush#       | #password# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of nodoChiediInformativaPA response
        Examples:
            | elem                           | value           | soapUI test |
            | identificativoIntermediarioPSP | INT_NOT_ENABLED | CIPASEM4    |