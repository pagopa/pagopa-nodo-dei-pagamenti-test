Feature: Semantic checks KO for nodoChiediInformativaPA
    Background:
        Given systems up
    
    @midRunnable
    Scenario: Check CIPASEM10
    Given initial XML nodoChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediInformativaPA>
              <identificativoPSP>#psp#</identificativoPSP>
              <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
              <identificativoCanale>97735020584_03</identificativoCanale>
              <password>pwdpwdpwd</password>
              <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_AUTORIZZAZIONE of nodoChiediInformativaPA response