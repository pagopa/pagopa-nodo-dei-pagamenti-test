Feature: Semantic checks KO for nodoChiediInformativaPA 245
    Background:
        Given systems up
    
    @runnable
    Scenario: Check CIPASEM1 
    Given initial XML nodoChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediInformativaPA>
              <identificativoPSP>sconosciuto</identificativoPSP>
              <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
              <identificativoCanale>#canaleRtPush#</identificativoCanale>
              <password>pwdpwdpwd</password>
            </ws:nodoChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_PSP_SCONOSCIUTO of nodoChiediInformativaPA response