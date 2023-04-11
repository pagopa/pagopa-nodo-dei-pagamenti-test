Feature: Semantic checks KO for nodoChiediInformativaPA
    Background:
        Given systems up
    
    @runnable
    Scenario: Check CIPASEM8
    Given initial XML nodoChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediInformativaPA>
              <identificativoPSP>#psp#</identificativoPSP>
              <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
              <identificativoCanale>#canale#</identificativoCanale>
              <password>pwdpwdpwd</password>
              <identificativoDominio>sconosciuto</identificativoDominio>
            </ws:nodoChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoChiediInformativaPA response