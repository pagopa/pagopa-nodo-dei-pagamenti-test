Feature: Semantic checks KO for nodoChiediInformativaPA 262
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCTIPKO @MOD1SEMCTIPKO_7
    Scenario Outline: Check CTIPSPSEM7
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTENTICAZIONE of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem     | value     | soapUI test |
            | password | passwordd | CTIPSPSEM7  |