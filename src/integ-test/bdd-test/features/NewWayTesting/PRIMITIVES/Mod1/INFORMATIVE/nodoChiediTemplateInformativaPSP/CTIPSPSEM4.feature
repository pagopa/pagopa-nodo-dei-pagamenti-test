Feature: Semantic checks KO for nodoChiediInformativaPA 259
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCTIPKO @MOD1SEMCTIPKO_4
    Scenario Outline: Check CTIPSPSEM4
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PSP_DISABILITATO of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem                           | value           | soapUI test |
            | identificativoIntermediarioPSP | INT_NOT_ENABLED | CTIPSPSEM4  |