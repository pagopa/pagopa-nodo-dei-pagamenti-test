Feature: process tests for pspInviaCarrelloRPT

    Background:
        Given systems up
        And initial XML nodoChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediNumeroAvviso>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <idServizio>00001</idServizio>
            <idDominioErogatoreServizio>00493410583</idDominioErogatoreServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+QUIzNDVDRDwvdGE6dmVpY29sb1RhcmdhPg0KICA8L3RhOnZlaWNvbG9Db25UYXJnYT4NCjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </ws:nodoChiediNumeroAvviso>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    @ciao
    Scenario: Execute nodoChiediNumeroAvviso [CNARES1]
        Given initial XML paaChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/ciao/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaChiediNumeroAvvisoRisposta>
            <paaChiediNumeroAvvisoRisposta>
            <esito>OK</esito>
            <numeroAvviso>
            <auxDigit>1</auxDigit>
            <IUV>00567890123456700</IUV>
            </numeroAvviso>
            <datiPagamentoPA>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            <ibanAccredito>IT96R0123454321000000012345</ibanAccredito>
            <causaleVersamento>#id_station_old#</causaleVersamento>
            </datiPagamentoPA>
            </paaChiediNumeroAvvisoRisposta>
            </ws:paaChiediNumeroAvvisoRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of nodoChiediNumeroAvviso response

    @ciao
    Scenario: Execute nodoChiediNumeroAvviso [CNARES2]
        Given initial XML paaChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/ciao/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header>
            <test>#psp#</test>
            </soapenv:Header>
            <soapenv:Body>
            <ws:paaChiediNumeroAvvisoRisposta>
            <paaChiediNumeroAvvisoRisposta>
            <esito>OK</esito>
            <numeroAvviso>
            <auxDigit>1</auxDigit>
            <IUV>00567890123456700</IUV>
            </numeroAvviso>
            <datiPagamentoPA>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            <ibanAccredito>IT96R0123454321000000012345</ibanAccredito>
            <causaleVersamento>#id_station_old#</causaleVersamento>
            </datiPagamentoPA>
            </paaChiediNumeroAvvisoRisposta>
            </ws:paaChiediNumeroAvvisoRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of nodoChiediNumeroAvviso response

    @ciao
    Scenario Outline: Execute nodoChiediNumeroAvviso - outline
        Given initial XML paaChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaChiediNumeroAvvisoRisposta>
            <paaChiediNumeroAvvisoRisposta>
            <fault>
            <faultCode>PAA_SEMANTICA</faultCode>
            <faultString>errore semantico PA</faultString>
            <id>#creditor_institution_code#</id>
            <description>Errore semantico emesso dalla PA</description>
            </fault>
            <esito>KO</esito>
            </paaChiediNumeroAvvisoRisposta>
            </ws:paaChiediNumeroAvvisoRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <tag_value> in paaChiediNumeroAvviso
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is <error> of nodoChiediNumeroAvviso response
        Examples:
            | tag                              | tag_value | error                               | soapUI test |
            | paaChiediNumeroAvvisoRisposta    | Empty     | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES3     |
            | soapenv:Body                     | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES4     |
            | ws:paaChiediNumeroAvvisoRisposta | Empty     | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES5     |
            | fault                            | Empty     | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES6     |
            | faultCode                        | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES7     |
            | faultCode                        | ciao      | PPT_ERRORE_EMESSO_DA_PAA            | CNARES8     |
            | faultString                      | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES9     |
            | id                               | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES10    |
            | esito                            | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES11    |
            | esito                            | OK        | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES13    |
            | esito                            | CIAO      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES14    |

    @ciao
    Scenario: Execute nodoChiediNumeroAvviso [CNARES12]
        Given initial XML paaChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/ciao/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header>
            <test>#psp#</test>
            </soapenv:Header>
            <soapenv:Body>
            <ws:paaChiediNumeroAvvisoRisposta>
            <paaChiediNumeroAvvisoRisposta>
            <esito>KO</esito>
            </paaChiediNumeroAvvisoRisposta>
            </ws:paaChiediNumeroAvvisoRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of nodoChiediNumeroAvviso response

    @ciao
    Scenario Outline: Execute nodoChiediNumeroAvviso - 2outline
        Given initial XML paaChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/ciao/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header>
            <test>#psp#</test>
            </soapenv:Header>
            <soapenv:Body>
            <ws:paaChiediNumeroAvvisoRisposta>
            <paaChiediNumeroAvvisoRisposta>
            <esito>OK</esito>
            <numeroAvviso>
            <auxDigit>1</auxDigit>
            <IUV>00567890123456700</IUV>
            </numeroAvviso>
            <datiPagamentoPA>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            <ibanAccredito>IT96R0123454321000000012345</ibanAccredito>
            <causaleVersamento>#id_station_old#</causaleVersamento>
            </datiPagamentoPA>
            </paaChiediNumeroAvvisoRisposta>
            </ws:paaChiediNumeroAvvisoRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And <tag> with <tag_value> in paaChiediNumeroAvviso
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is <error> of nodoChiediNumeroAvviso response
        Examples:
            | tag                      | tag_value | error                               | soapUI test |
            | auxDigit                 | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES15    |
            | IUV                      | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES16    |
            | importoSingoloVersamento | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES17    |
            | ibanAccredito            | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES18    |
            | causaleVersamento        | None      | PPT_STAZIONE_INT_PA_ERRORE_RESPONSE | CNARES19    |

