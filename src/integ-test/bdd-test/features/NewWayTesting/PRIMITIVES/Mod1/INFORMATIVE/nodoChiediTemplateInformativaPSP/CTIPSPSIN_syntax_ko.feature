Feature: Syntax checks KO for nodoChiediTemplateInformativaPSP 264
    Background:
        Given systems up


    @ALL @PRIMITIVE @NM1 @NM1INSEMCTIP @NM1INSINCTIPKO_1
    Scenario Outline: Check error for nodoChiediTemplateInformativaPSP primitive
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem                                | value                                | SoapUI      |
            | soapenv:Body                        | Empty                                | CTIPSPSIN2  |
            | ws:nodoChiediTemplateInformativaPSP | Empty                                | CTIPSPSIN4  |
            | identificativoPSP                   | None                                 | CTIPSPSIN6  |
            | identificativoPSP                   | Empty                                | CTIPSPSIN7  |
            | identificativoPSP                   | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN8  |
            | identificativoIntermediarioPSP      | None                                 | CTIPSPSIN9  |
            | identificativoIntermediarioPSP      | Empty                                | CTIPSPSIN10 |
            | identificativoIntermediarioPSP      | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN11 |
            | identificativoCanale                | None                                 | CTIPSPSIN12 |
            | identificativoCanale                | Empty                                | CTIPSPSIN13 |
            | identificativoCanale                | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN14 |
            | password                            | None                                 | CTIPSPSIN15 |
            | password                            | Empty                                | CTIPSPSIN16 |
            | password                            | s7fhr2                               | CTIPSPSIN17 |
            | password                            | qertyuop234dcvgtresd567yhbvfrteesd56 | CTIPSPSIN18 |


    @ALL @PRIMITIVE @NM1 @NM1INSEMCTIP @NM1INSINCTIPKO_2
    Scenario: Check error for nodoChiediTemplateInformativaPSP primitive-[CTIPSPSIN1]
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP_malformed initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response


    @ALL @PRIMITIVE @NM1 @NM1INSEMCTIP @NM1INSINCTIPKO_3
    Scenario Outline: Check error for nodoChiediTemplateInformativaPSP primitive-[CTIPSPSIN3]
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem         | value | SoapUI     |
            | soapenv:Body | None  | CTIPSPSIN3 |


    @ALL @PRIMITIVE @NM1 @NM1INSEMCTIP @NM1INSINCTIPKO_4
    Scenario Outline: Check error for nodoChiediTemplateInformativaPSP primitive-[CTIPSPSIN5]
        Given from body with datatable horizontal nodoChiediTemplateInformativaPSP initial XML nodoChiediTemplateInformativaPSP
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale | password   |
            | #psp#             | #psp#                          | #canale#             | #password# |
        And <elem> with <value> in nodoChiediTemplateInformativaPSP
        When psp sends SOAP nodoChiediTemplateInformativaPSP to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediTemplateInformativaPSP response
        Examples:
            | elem                                | value        | SoapUI     |
            | ws:nodoChiediTemplateInformativaPSP | RemoveParent | CTIPSPSIN5 |
