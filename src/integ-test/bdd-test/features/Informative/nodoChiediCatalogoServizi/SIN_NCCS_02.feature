Feature: Semantic checks KO for nodoChiediCatalogoServizi
    Background:
        Given systems up
    
    @midRunnable
    Scenario: Check SIN_NCCS_02
    Given initial XML nodoChiediCatalogoServizi
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        </soapenv:Envelope>
        """
    When psp sends SOAP nodoChiediCatalogoServizi to nodo-dei-pagamenti 
    Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoChiediCatalogoServizi response