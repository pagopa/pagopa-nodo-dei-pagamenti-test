Feature: Semantic checks KO for nodoChiediInformativaPA 258
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMCTIP @NM1INSEMCTIP_3
    Scenario Outline: Check CTIPSPSEM3
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_INTERMEDIARIO_PSP_SCONOSCIUTO of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem                           | value       | soapUI test |
            | identificativoIntermediarioPSP | sconosciuto | CTIPSPSEM3  |