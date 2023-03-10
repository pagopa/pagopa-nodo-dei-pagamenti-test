Feature: T116_ChiediNumeroAvviso_targa_tipo=1

    Background:
        Given systems up

@fix @testdev
    Scenario: Execute nodoChiediNumeroAvviso
        Given initial XML nodoChiediNumeroAvviso
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
                <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+MTIzNDU2Nzg8L3RhOnZlaWNvbG9UYXJnYT4NCiAgPC90YTp2ZWljb2xvQ29uVGFyZ2E+DQo8L3RhOnRhc3NhQXV0bz4=</datiSpecificiServizio>
            </ws:nodoChiediNumeroAvviso>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is OK of nodoChiediNumeroAvviso response
        And check numeroAvviso field exists in nodoChiediNumeroAvviso response
        And check datiPagamentoPA field exists in nodoChiediNumeroAvviso response
        And verify the HTTP status code of nodoChiediNumeroAvviso response is 200