Feature: process test for nodoChiediSceltaWISP

    Background:
        Given systems up

    Scenario: send nodoChiediSceltaWISP
        Given initial XML nodoChiediSceltaWISP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediSceltaWISP>
                    <identificativoIntermediarioPA>${intermediarioPA}</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>${stazione}</identificativoStazioneIntermediarioPA>
                    <password>${password}</password>
                    <identificativoDominio>${pa}</identificativoDominio>
                    <keyPA>1307201616361259051cb66f9ac190df6ec</keyPA>
                    <keyWISP>5cc7f140475743938a65021deb74c66b18062923</keyWISP>
                </ws:nodoChiediSceltaWISP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoChiediSceltaWISP to nodo-dei-pagamenti