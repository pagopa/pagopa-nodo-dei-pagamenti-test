Feature: Syntax checks for nodoChiediInformativaPA - KO 255
    Background:
        Given systems up

    @ALL @PRIMITIVE @NM1 @NM1INSINCIPAKO @NM1INSINCIPAKO_1
    Scenario Outline: Check error for nodoChiediInformativaPA primitive
        Given from body with datatable horizontal nodoChiediInformativaPA_full initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   | identificativoDominio       |
            | #psp#             | #psp#                          | #canale_ATTIVATO_PRESSO_PSP# | #password# | #creditor_institution_code# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediInformativaPA response
        And check faultString is Errore di sintassi extra XSD. of nodoChiediInformativaPA response
        Examples:
            | elem                           | value                                | SoapUI    |
            | soapenv:Body                   | Empty                                | CIPASIN2  |
            | ws:nodoChiediInformativaPA     | Empty                                | CIPASIN4  |
            | identificativoPSP              | Empty                                | CIPASIN5  |
            | identificativoPSP              | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN6  |
            | identificativoIntermediarioPSP | None                                 | CIPASIN7  |
            | identificativoIntermediarioPSP | Empty                                | CIPASIN8  |
            | identificativoIntermediarioPSP | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN9  |
            | identificativoCanale           | None                                 | CIPASIN10 |
            | identificativoCanale           | Empty                                | CIPASIN11 |
            | identificativoCanale           | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN12 |
            | password                       | None                                 | CIPASIN13 |
            | password                       | Empty                                | CIPASIN14 |
            | password                       | ertg5d3                              | CIPASIN15 |
            | password                       | d45ti85ght9retv4                     | CIPASIN16 |
            | identificativoDominio          | Empty                                | CIPASIN17 |
            | identificativoDominio          | qertyuop234dcvgtresd567yhbvfrteesd56 | CIPASIN18 |


    @ALL @PRIMITIVE @NM1 @NM1INSINCIPAKO @NM1INSINCIPAKO_2
    Scenario Outline: Check error for nodoChiediInformativaPA primitive-[CIPASIN1]
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   |
            | #psp#             | #psp#                          | #canale_ATTIVATO_PRESSO_PSP# | #password# |
        And <elem1> with <value1> in nodoChiediInformativaPA
        And <elem2> with <value2> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediInformativaPA response
        And check faultString is Errore di sintassi extra XSD. of nodoChiediInformativaPA response
        Examples:
            | elem1             | value1 | elem2                      | value2       | soapUI test |
            | identificativoPSP | None   | ws:nodoChiediInformativaPA | RemoveParent | CIPASIN1    |


    @ALL @PRIMITIVE @NM1 @NM1INSINCIPAKO @NM1INSINCIPAKO_3
    Scenario Outline: Check error for nodoChiediInformativaPA primitive-[CIPASIN3]
        Given from body with datatable horizontal nodoChiediInformativaPA initial XML nodoChiediInformativaPA
            | identificativoPSP | identificativoIntermediarioPSP | identificativoCanale         | password   |
            | #psp#             | #psp#                          | #canale_ATTIVATO_PRESSO_PSP# | #password# |
        And <elem> with <value> in nodoChiediInformativaPA
        When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediInformativaPA response
        And check faultString is Errore di sintassi extra XSD. of nodoChiediInformativaPA response
        Examples:
            | elem         | value | soapUI test |
            | soapenv:Body | None  | CIPASIN3    |


