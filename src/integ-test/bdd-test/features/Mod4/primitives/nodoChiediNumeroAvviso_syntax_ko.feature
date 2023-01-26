Feature: syntax checks for nodoChiediNumeroAvviso - KO

    Background:
        Given systems up

    Scenario: nodoChiediNumeroAvviso
        Given initial XML nodoChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediNumeroAvviso>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#id_broker_psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>#password#</password>
            <idServizio>00001</idServizio>
            <idDominioErogatoreServizio>#creditor_institution_code#</idDominioErogatoreServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+S08xMjNQQTwvdGE6dmVpY29sb1RhcmdhPg0KICA8L3RhOnZlaWNvbG9Db25UYXJnYT4NCjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </ws:nodoChiediNumeroAvviso>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: nodoChiediNumeroAvviso with two occurrences of idServizio
        Given initial XML nodoChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediNumeroAvviso>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#id_broker_psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>#password#</password>
            <idServizio>00001</idServizio>
            <idServizio>00001</idServizio>
            <idDominioErogatoreServizio>#creditor_institution_code#</idDominioErogatoreServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+S08xMjNQQTwvdGE6dmVpY29sb1RhcmdhPg0KICA8L3RhOnZlaWNvbG9Db25UYXJnYT4NCjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </ws:nodoChiediNumeroAvviso>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: nodoChiediNumeroAvviso with two occurrences of datiSpecificiServizio
        Given initial XML nodoChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediNumeroAvviso>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#id_broker_psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>#password#</password>
            <idServizio>00001</idServizio>
            <idDominioErogatoreServizio>#creditor_institution_code#</idDominioErogatoreServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+S08xMjNQQTwvdGE6dmVpY29sb1RhcmdhPg0KICA8L3RhOnZlaWNvbG9Db25UYXJnYT4NCjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+S08xMjNQQTwvdGE6dmVpY29sb1RhcmdhPg0KICA8L3RhOnZlaWNvbG9Db25UYXJnYT4NCjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </ws:nodoChiediNumeroAvviso>
            </soapenv:Body>
            </soapenv:Envelope>
            """
    @runnable
    # attribute value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid wsdl namespace
        Given the nodoChiediNumeroAvviso scenario executed successfully
        And <attribute> set <value> for <elem> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediNumeroAvviso response
        Examples:
            | elem             | attribute     | value                                     |
            | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ |
    @runnable
    # element value check
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid body element value
        Given the nodoChiediNumeroAvviso scenario executed successfully
        And <elem> with <value> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediNumeroAvviso response
        Examples:
            | elem                           | value                                |
            | soapenv:Body                   | None                                 |
            | soapenv:Body                   | Empty                                |
            | ws:nodoChiediNumeroAvviso      | Empty                                |
            | identificativoPSP              | None                                 |
            | identificativoPSP              | Empty                                |
            | identificativoPSP              | 123456789012345678901234567890123456 |
            | identificativoIntermediarioPSP | None                                 |
            | identificativoIntermediarioPSP | Empty                                |
            | identificativoIntermediarioPSP | 123456789012345678901234567890123456 |
            | identificativoCanale           | None                                 |
            | identificativoCanale           | Empty                                |
            | identificativoCanale           | 123456789012345678901234567890123456 |
            | password                       | None                                 |
            | password                       | Empty                                |
            | password                       | 1234567                              |
            | password                       | 123456789012345678901234567890123456 |
            | idDominioErogatoreServizio     | None                                 |
            | idDominioErogatoreServizio     | Empty                                |
            | idDominioErogatoreServizio     | 123456789012345678901234567890123456 |
            | idServizio                     | None                                 |
            | idServizio                     | Empty                                |
            | idServizio                     | 123456                               |
            | idServizio                     | 1234                                 |
            | datiSpecificiServizio          | None                                 |
            | datiSpecificiServizio          | Empty                                |
            | datiSpecificiServizio          | cia                                  |
            | datiSpecificiServizio          | cia$                                 |
    @runnable
    Scenario Outline: Check PPT_SINTASSI_EXTRAXSD error on invalid nodoChiediNumeroAvviso
        Given the nodoChiediNumeroAvviso with two occurrences of <value> scenario executed successfully
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediNumeroAvviso response
        Examples:
            | value                 |
            | idServizio            |
            | datiSpecificiServizio |