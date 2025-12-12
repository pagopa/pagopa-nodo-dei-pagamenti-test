Feature: Semantic checks KO for nodoChiediInformativaPA 257
    Background:
        Given systems up

    @ALL @PRIMITIVE @MOD1 @MOD1SEMCTIPKO @MOD1SEMCTIPKO_2
    Scenario Outline: Check CTIPSPSEM2
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_PSP_DISABILITATO of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem              | value       | soapUI test |
            | identificativoPSP | NOT_ENABLED | CTIPSPSEM2  |