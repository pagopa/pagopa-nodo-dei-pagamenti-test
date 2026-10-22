Feature: Syntax check OK for nodoVerificaRPT 1412
    Background:
        Given systems up


    @ALL @PRIMITIVE @OM3 @OM3NOVERPSNTKO @OM3NOVERPSNTKO_1
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128              |
            | Gln                            | 1234567890122                |
            | CodStazPA                      | 01                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 123456789012345              |
        And <attribute> set <value> for <elem> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | elem             | attribute     | value                                     | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | VRPTSIN1    |
            | soapenv:Body     | xmlns:ws      | <wss:></wss>                              | VRPTSIN2    |



    @ALL @PRIMITIVE @OM3 @OM3NOVERPSNTKO @OM3NOVERPSNTKO_2
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on missing or empty body elements
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128              |
            | Gln                            | 1234567890122                |
            | CodStazPA                      | 01                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 123456789012345              |
        And <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field                          | value                                | soapUI test |
            | soapenv:Body                   | None                                 | VRPTSIN3    |
            | soapenv:Body                   | Empty                                | VRPTSIN4    |
            | ws:nodoVerificaRPT             | Empty                                | VRPTSIN5    |
            | identificativoPSP              | None                                 | VRPTSIN6    |
            | identificativoPSP              | Empty                                | VRPTSIN7    |
            | identificativoPSP              | QuestiSono36CaratteriAlfaNumericiTT1 | VRPTSIN8    |
            | identificativoIntermediarioPSP | None                                 | VRPTSIN9    |
            | identificativoIntermediarioPSP | Empty                                | VRPTSIN10   |
            | identificativoIntermediarioPSP | QuestiSono36CaratteriAlfaNumericiTT1 | VRPTSIN11   |
            | identificativoCanale           | None                                 | VRPTSIN12   |
            | identificativoCanale           | Empty                                | VRPTSIN13   |
            | identificativoCanale           | QuestiSono36CaratteriAlfaNumericiTT1 | VRPTSIN14   |
            | password                       | None                                 | VRPTSIN15   |
            | password                       | Empty                                | VRPTSIN16   |
            | password                       | Alpha_7                              | VRPTSIN17   |
            | password                       | Alpha_16_Num_123                     | VRPTSIN18   |
            | codiceContestoPagamento        | None                                 | VRPTSIN19   |
            | codificaInfrastrutturaPSP      | None                                 | VRPTSIN22   |


    @ALL @PRIMITIVE @OM3 @OM3NOVERPSNTKO @OM3NOVERPSNTKO_3
    Scenario: check faultCode PPT_CODIFICA_PSP_SCONOSCIUTA on empty field codificaInfrastrutturaPSP [VRPTSIN23]
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128              |
            | Gln                            | 1234567890122                |
            | CodStazPA                      | 01                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 123456789012345              |
        And codificaInfrastrutturaPSP with Empty in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_CODIFICA_PSP_SCONOSCIUTA of nodoVerificaRPT response



    @ALL @PRIMITIVE @OM3 @OM3NOVERPSNTKO @OM3NOVERPSNTKO_4
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on missing or empty body elements
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128              |
            | Gln                            | 1234567890122                |
            | CodStazPA                      | 01                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 123456789012345              |
        And <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field       | value | soapUI test |
            | codiceIdRPT | None  | VRPTSIN24   |
            | codiceIdRPT | Empty | VRPTSIN25   |


    @ALL @PRIMITIVE @OM3 @OM3NOVERPSNTKO @OM3NOVERPSNTKO_5
    Scenario Outline: Check faultCode PPT_SINTASSI_XSD error on missing or empty body elements
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128              |
            | Gln                            | 1234567890122                |
            | CodStazPA                      | 01                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 123456789012345              |
        And <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_XSD of nodoVerificaRPT response
        Examples:
            | field       | value              | soapUI test |
            | bc:BarCode  | RemoveParent       | VRPTSIN26   |
            | bc:Gln      | None               | VRPTSIN27   |
            | bc:AuxDigit | 8                  | VRPTSIN28   |
            | bc:AuxDigit | Empty              | VRPTSIN29   |
            | bc:AuxDigit | 03                 | VRPTSIN30   |
            | bc:CodIUV   | Empty              | VRPTSIN31   |
            | bc:CodIUV   | 123456789012345678 | VRPTSIN32   |


    @ALL @PRIMITIVE @OM3 @OM3NOVERPSNTKO @OM3NOVERPSNTKO_6
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on missing or empty body elements
        Given from body with datatable vertical nodoVerificaRPT_namespace_bc initial XML nodoVerificaRPT
            | identificativoPSP              | #psp#                        |
            | identificativoIntermediarioPSP | #psp#                        |
            | identificativoCanale           | #canale_ATTIVATO_PRESSO_PSP# |
            | codiceContestoPagamento        | CCD01                        |
            | codificaInfrastrutturaPSP      | BARCODE-GS1-128              |
            | Gln                            | 1234567890122                |
            | CodStazPA                      | 01                           |
            | AuxDigit                       | 0                            |
            | CodIUV                         | 123456789012345              |
        And <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field                   | value                                | soapUI test |
            | codiceContestoPagamento | None                                 | VRPTSIN20   |
            | codiceContestoPagamento | QuestiSono36CaratteriAlfaNumericiTT1 | VRPTSIN21   |