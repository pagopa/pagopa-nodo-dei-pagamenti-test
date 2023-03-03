Feature: T116_A_ChiediNumeroAvviso_targa_tipo=1_ErroreEmessoDaPA

    Background:
        Given systems up

@fix
    Scenario: Execute nodoChiediNumeroAvviso (Phase 1)
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
                <idServizio>00010</idServizio>
                <idDominioErogatoreServizio>#creditor_institution_code_old#</idDominioErogatoreServizio>
                <datiSpecificiServizio>PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiPz4NCjx0YTp0YXNzYUF1dG8geG1sbnM6dGE9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9UYXNzYUF1dG8iIHhtbG5zOnhzaT0iaHR0cDovL3d3dy53My5vcmcvMjAwMS9YTUxTY2hlbWEtaW5zdGFuY2UiIHhzaTpzY2hlbWFMb2NhdGlvbj0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L1Rhc3NhQXV0byBUYXNzYUF1dG9tb2JpbGlzdGljYV8xXzBfMC54c2QgIj4NCiAgPHRhOnZlaWNvbG9Db25UYXJnYT4NCiAgICA8dGE6dGlwb1ZlaWNvbG9UYXJnYT4xPC90YTp0aXBvVmVpY29sb1RhcmdhPg0KICAgIDx0YTp2ZWljb2xvVGFyZ2E+QUIzNDVDRDwvdGE6dmVpY29sb1RhcmdhPg0KICA8L3RhOnZlaWNvbG9Db25UYXJnYT4NCjwvdGE6dGFzc2FBdXRvPg==</datiSpecificiServizio>
            </ws:nodoChiediNumeroAvviso>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML paaChiediNumeroAvviso
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaChiediNumeroAvvisoRisposta>
            <paaChiediNumeroAvvisoRisposta>
            <fault>
            <faultCode>ciao</faultCode>
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
        And EC replies to nodo-dei-pagamenti with the paaChiediNumeroAvviso
        When PSP sends SOAP nodoChiediNumeroAvviso to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediNumeroAvviso response
        And check faultCode field exists in nodoChiediNumeroAvviso response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of nodoChiediNumeroAvviso response