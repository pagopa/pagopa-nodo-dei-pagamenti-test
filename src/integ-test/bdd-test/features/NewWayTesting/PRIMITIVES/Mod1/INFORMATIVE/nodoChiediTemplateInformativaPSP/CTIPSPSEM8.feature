Feature: Semantic checks KO for nodoChiediInformativaPA 263
    Background:
        Given systems up


    @ALL @PRIMITIVE @MOD1 @MOD1SEMCTIPKO @MOD1SEMCTIPKO_8
    Scenario Outline: Check CTIPSPSEM8
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_AUTORIZZAZIONE of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem                 | value          | soapUI test |
            | identificativoCanale | 91000000001_03 | CTIPSPSEM8  |