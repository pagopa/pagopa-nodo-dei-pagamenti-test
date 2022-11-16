Feature: T215_nodoChiediSceltaWisp - TASK_491 - CLOSED

    Background:
        Given systems up
@runnable
    Scenario: send nodoChiediSceltaWISP
        Given initial XML nodoChiediSceltaWISP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediSceltaWISP>
                    <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                    <keyPA>1307201616361259051cb66f9ac190df6ec</keyPA>
                    <keyWISP>5cc7f140475743938a65021deb74c66b18062923</keyWISP>
                </ws:nodoChiediSceltaWISP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediSceltaWISP to nodo-dei-pagamenti
        Then check effettuazioneScelta is SI of nodoChiediSceltaWISP response
        And check identificativoPSP is AGID_01 of nodoChiediSceltaWISP response
        And check identificativoIntermediarioPSP is 97735020584 of nodoChiediSceltaWISP response
        And check identificativoCanale is 97735020584_02 of nodoChiediSceltaWISP response
        And check tipoVersamento is BBT of nodoChiediSceltaWISP response