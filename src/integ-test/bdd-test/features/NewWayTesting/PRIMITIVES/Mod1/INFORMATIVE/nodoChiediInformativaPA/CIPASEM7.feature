Feature: Semantic checks KO for nodoChiediInformativaPA 252
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCIPAKO @MOD1SEMCIPAKO_7
    Scenario Outline: Check SCheck CIPASEM7
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTENTICAZIONE of nodoChiediInformativaPA response
        Examples:
            | elem     | value     | soapUI test |
            | password | passwordd | CIPASEM7    |