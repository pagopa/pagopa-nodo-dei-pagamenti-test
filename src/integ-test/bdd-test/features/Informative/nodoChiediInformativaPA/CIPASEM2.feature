Feature: Semantic checks KO for nodoChiediInformativaPA
    Background:
        Given systems up
    
    @midRunnable
    Scenario: Check CIPASEM2 
    Given initial XML nodoChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediInformativaPA>
              <identificativoPSP>NOT_ENABLED</identificativoPSP>
              <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
              <identificativoCanale>#canaleRtPush#</identificativoCanale>
              <password>pwdpwdpwd</password>
            </ws:nodoChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_PSP_DISABILITATO of nodoChiediInformativaPA response