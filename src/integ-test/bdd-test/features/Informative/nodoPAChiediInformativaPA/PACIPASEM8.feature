Feature: Semantic checks KO for nodoPAChiediInformativaPA
    Background:
        Given systems up
    
    @midRunnable
    Scenario: Check PACIPASEM8
    Given initial XML nodoPAChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoPAChiediInformativaPA>
                <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>90000000001</identificativoDominio>
            </ws:nodoPAChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_AUTORIZZAZIONE of nodoPAChiediInformativaPA response
    And check description is Configurazione pa-intermediario-stazione non corretta of nodoPAChiediInformativaPA response