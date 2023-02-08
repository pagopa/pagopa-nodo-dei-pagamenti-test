Feature: Semantic checks KO for nodoPAChiediInformativaPA
    Background:
        Given systems up
    
    @runnable
    Scenario: Check PACIPASEM5
    Given initial XML nodoPAChiediInformativaPA
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoPAChiediInformativaPA>
                <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <password>passwordd</password>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            </ws:nodoPAChiediInformativaPA>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti 
    Then check faultCode is PPT_AUTENTICAZIONE of nodoPAChiediInformativaPA response
    And check description is Password sconosciuta o errata of nodoPAChiediInformativaPA response