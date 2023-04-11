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
                    <identificativoIntermediarioPA>#creditor_institution_code_secondary#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station_secondary#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code_secondary#</identificativoDominio>
                </ws:nodoPAChiediInformativaPA>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoPAChiediInformativaPA to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoPAChiediInformativaPA response