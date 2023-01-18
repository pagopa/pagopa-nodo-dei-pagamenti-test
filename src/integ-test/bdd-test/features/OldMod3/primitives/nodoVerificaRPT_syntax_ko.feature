Feature: Syntax check OK for nodoVerificaRPT
    Background:
        Given systems up
        And initial XML nodoVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoVerificaRPT>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>BARCODE-GS1-128</codificaInfrastrutturaPSP>
            <codiceIdRPT>
                <bc:BarCode>
                    <bc:Gln>1234567890122</bc:Gln>
                    <bc:CodStazPA>01</bc:CodStazPA>
                    <bc:AuxDigit>0</bc:AuxDigit>
                    <bc:CodIUV>123456789012345</bc:CodIUV>
                </bc:BarCode>
            </codiceIdRPT>
            </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

@midRunnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given <attribute> set <value> for <elem> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | elem             | attribute     | value                                     | soapUI test |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | VRPTSIN1    |
            | soapenv:Body     | xmlns:ws      | <wss:></wss>                              | VRPTSIN2    |

@midRunnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on missing or empty body elements
        Given <field> with <value> in nodoVerificaRPT
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

@midRunnable
    Scenario: check faultCode PPT_CODIFICA_PSP_SCONOSCIUTA on empty field codificaInfrastrutturaPSP [VRPTSIN23]
        Given codificaInfrastrutturaPSP with Empty in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_CODIFICA_PSP_SCONOSCIUTA of nodoVerificaRPT response

@midRunnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on missing or empty body elements
        Given <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field       | value              | soapUI test |
            | codiceIdRPT | None               | VRPTSIN24   |
            | codiceIdRPT | Empty              | VRPTSIN25   |

@midRunnable
    Scenario Outline: Check faultCode PPT_SINTASSI_XSD error on missing or empty body elements
        Given <field> with <value> in nodoVerificaRPT
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

@midRunnable
    Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on missing or empty body elements
        Given <field> with <value> in nodoVerificaRPT
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoVerificaRPT response
        Examples:
            | field                  | value                                              | soapUI test |
            | codiceContestoPagamento| None                                               | VRPTSIN20   |
            | codiceContestoPagamento| QuestiSono36CaratteriAlfaNumericiTT1               | VRPTSIN21   |
