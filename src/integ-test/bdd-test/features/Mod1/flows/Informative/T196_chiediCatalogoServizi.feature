Feature: process tests for nodoChiediCatalogoServizi

    Background:
        Given systems up
@runnable @independent
    Scenario: Send nodoChiediCatalogoServizi
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediCatalogoServizi>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <!-- questo campo manda in eccezione il Nodo3 ma non il 4 -->
                    <identificativoDominio>00493410583</identificativoDominio>
                </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response
        And check xmlCatalogoServizi is PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIiA/PjxsaXN0YUNhdGFsb2dvU2Vydml6aSB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4bWxuczpjcz0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L0NhdGFsb2dvU2Vydml6aSIgeG1sbnM9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9DYXRhbG9nb1NlcnZpemkiPjxjYXRhbG9nb1NlcnZpemk+PGlkU2Vydml6aW8+MDAwMDE8L2lkU2Vydml6aW8+PGRlc2NyaXppb25lU2Vydml6aW8+VGFzc2EgYXV0b21vYmlsaXN0aWNhPC9kZXNjcml6aW9uZVNlcnZpemlvPjxlbGVuY29Tb2dnZXR0aUVyb2dhbnRpPjxzb2dnZXR0b0Vyb2dhbnRlPjxpZERvbWluaW8+MDA0OTM0MTA1ODM8L2lkRG9taW5pbz48ZGVub21pbmF6aW9uZUVudGVDcmVkaXRvcmU+QXV0b21vYmlsZSBDbHViIGQnSXRhbGlhPC9kZW5vbWluYXppb25lRW50ZUNyZWRpdG9yZT48ZGF0YUluaXppb1ZhbGlkaXRhPjIwMTctMDQtMjk8L2RhdGFJbml6aW9WYWxpZGl0YT48L3NvZ2dldHRvRXJvZ2FudGU+PC9lbGVuY29Tb2dnZXR0aUVyb2dhbnRpPjx4c2RSaWZlcmltZW50bz5UYXNzYUF1dG9tb2JpbGlzdGljYV8xXzFfMC54c2Q8L3hzZFJpZmVyaW1lbnRvPjwvY2F0YWxvZ29TZXJ2aXppPjwvbGlzdGFDYXRhbG9nb1NlcnZpemk+ of nodoChiediCatalogoServizi response

@runnable @independent
        Scenario: Send second nodoChiediCatalogoServizi
        Given initial XML nodoChiediCatalogoServizi
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediCatalogoServizi>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
                </ws:nodoChiediCatalogoServizi>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti
        Then check xmlCatalogoServizi field exists in nodoChiediCatalogoServizi response
        And check nodoChiediNumeroAvvisoRisposta field exists in nodoChiediCatalogoServizi response
        And check fault field not exists in nodoChiediCatalogoServizi response
        And check xmlCatalogoServizi is PD94bWwgdmVyc2lvbj0iMS4wIiBlbmNvZGluZz0iVVRGLTgiIHN0YW5kYWxvbmU9Im5vIiA/PjxsaXN0YUNhdGFsb2dvU2Vydml6aSB4bWxuczp4c2k9Imh0dHA6Ly93d3cudzMub3JnLzIwMDEvWE1MU2NoZW1hLWluc3RhbmNlIiB4bWxuczpjcz0iaHR0cDovL1B1bnRvQWNjZXNzb1BTUC5zcGNvb3AuZ292Lml0L0NhdGFsb2dvU2Vydml6aSIgeG1sbnM9Imh0dHA6Ly9QdW50b0FjY2Vzc29QU1Auc3Bjb29wLmdvdi5pdC9DYXRhbG9nb1NlcnZpemkiLz4= of nodoChiediCatalogoServizi response