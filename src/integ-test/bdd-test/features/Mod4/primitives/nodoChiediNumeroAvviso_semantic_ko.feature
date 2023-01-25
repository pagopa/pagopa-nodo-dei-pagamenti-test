Feature: semantic checks

    Background:
        Given systems up
        And initial XML nodoChiediNumeroAvviso
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

    Scenario Outline: KO with description
        Given <tag> with <value> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is <faultCode> of nodoChiediNumeroAvviso response
        And check description is <description> of nodoChiediNumeroAvviso response
        Examples:
            | tag                            | value       | faultCode                | description                                      |
            | idServizio                     | 99999       | PPT_SERVIZIO_SCONOSCIUTO | Servizio inesistente sul sistema pagoPA          |
            | idServizio                     | 00200       | PPT_VERSIONE_SERVIZIO    | Versione servizio incompatibile con la chiamata  |
            | identificativoIntermediarioPSP | 91000000001 | PPT_AUTORIZZAZIONE       | Configurazione intermediario-canale non corretta |

    Scenario Outline: KO
        Given <tag> with <value> in nodoChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode is <faultCode> of nodoChiediNumeroAvviso response
        Examples:
            | tag                            | value              | faultCode                          |
            | identificativoPSP              | 1230984759         | PPT_PSP_SCONOSCIUTO                |
            | identificativoPSP              | NOT_ENABLED        | PPT_PSP_DISABILITATO               |
            | identificativoIntermediarioPSP | 1230984759         | PPT_INTERMEDIARIO_PSP_SCONOSCIUTO  |
            | identificativoIntermediarioPSP | INT_NOT_ENABLED    | PPT_INTERMEDIARIO_PSP_DISABILITATO |
            | identificativoCanale           | 1230984759         | PPT_CANALE_SCONOSCIUTO             |
            | identificativoCanale           | CANALE_NOT_ENABLED | PPT_CANALE_DISABILITATO            |
            | password                       | password           | PPT_AUTENTICAZIONE                 |