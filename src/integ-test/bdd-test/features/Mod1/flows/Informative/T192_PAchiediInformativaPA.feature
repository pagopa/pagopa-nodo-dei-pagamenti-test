Feature: process tests for nodoPAChiediInformativaPA

    Background:
        Given systems up
@runnable
    Scenario: Send nodoPAChiediInformativaPA
        Given initial XML nodoPAChiediInformativaPA
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoPAChiediInformativaPA>
                    <identificativoIntermediarioPA>90000000001</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>90000000001_01</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>90000000001</identificativoDominio>
                </ws:nodoPAChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoPAChiediInformativaPA response