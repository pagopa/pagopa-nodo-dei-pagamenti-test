Feature: T117_ChiediNumeroAvviso_targa_tipo=2

    Background:
        Given systems up

@runnable
    Scenario: Execute nodoChiediNumeroAvviso
        Given initial XML nodoChiediNumeroAvviso
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediNumeroAvviso>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale#</identificativoCanale>
                <password>pwdpwdpwd</password>
                <idServizio>00200</idServizio>
                <idDominioErogatoreServizio>#creditor_institution_code#</idDominioErogatoreServizio>
                <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4KPHRhOnRhc3NhQXV0bwogICAgeG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iCiAgICB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4c2k6c2NoZW1hTG9jYXRpb249Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8gVGFzc2FBdXRvbW9iaWxpc3RpY2FfMV8wXzAueHNkICI+CiAgICA8dGE6dmVpY29sb0NvblRhcmdhPgogICAgICAgIDx0YTp0aXBvVmVpY29sb1RhcmdhPjI8L3RhOnRpcG9WZWljb2xvVGFyZ2E+CiAgICAgICAgPHRhOnZlaWNvbG9UYXJnYT5BQjM0NUNEPC90YTp2ZWljb2xvVGFyZ2E+CiAgICA8L3RhOnZlaWNvbG9Db25UYXJnYT4KPC90YTp0YXNzYUF1dG8+Cg==</datiSpecificiServizio>
            </ws:nodoChiediNumeroAvviso>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is OK of nodoChiediNumeroAvviso response
        And check numeroAvviso field exists in nodoChiediNumeroAvviso response
        And check datiPagamentoPA field exists in nodoChiediNumeroAvviso response
        And verify the HTTP status code of nodoChiediNumeroAvviso response is 200