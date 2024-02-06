Feature: Semantic checks KO for nodoPAChiediInformativaPA 268
    Background:
        Given systems up
    
    @runnable
    Scenario: Check PACIPASEM4
    Given initial XML nodoPAChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoPAChiediInformativaPA>
                <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>11111122222_01</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoPAChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoPAChiediInformativaPA response
    And check faultString is Stazione disabilitata. of nodoPAChiediInformativaPA response