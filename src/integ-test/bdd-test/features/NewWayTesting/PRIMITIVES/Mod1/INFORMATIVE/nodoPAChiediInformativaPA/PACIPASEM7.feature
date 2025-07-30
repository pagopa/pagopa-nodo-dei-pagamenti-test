Feature: Semantic checks KO for nodoPAChiediInformativaPA 271
    Background:
        Given systems up
    
    @runnable
    Scenario: Check PACIPASEM7
    Given initial XML nodoPAChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoPAChiediInformativaPA>
                <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>NOT_ENABLED</identificativoDominio>
            </ws:nodoPAChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_DOMINIO_DISABILITATO of nodoPAChiediInformativaPA response
    And check faultString is Dominio disabilitato. of nodoPAChiediInformativaPA response