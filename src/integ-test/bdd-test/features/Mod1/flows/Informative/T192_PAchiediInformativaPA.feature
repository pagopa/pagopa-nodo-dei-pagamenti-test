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
                    <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#intermediarioPA#</identificativoDominio>
                </ws:nodoPAChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoPAChiediInformativaPA response