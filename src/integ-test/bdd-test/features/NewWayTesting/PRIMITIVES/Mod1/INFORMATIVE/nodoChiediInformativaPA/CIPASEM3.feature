Feature: Semantic checks KO for nodoChiediInformativaPA 248
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMCIPA @NM1INSEMCIPA_3
    Scenario Outline: Check SCheck CIPASEM3
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canaleRtPush#       | #password# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of nodoChiediInformativaPA response
        Examples:
            | elem                           | value       | soapUI test |
            | identificativoIntermediarioPSP | sconosciuto | CIPASEM3    |