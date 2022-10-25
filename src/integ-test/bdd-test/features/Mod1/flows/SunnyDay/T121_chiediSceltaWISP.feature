Feature: process test for nodoChiediSceltaWISP

    Background:
        Given systems up
<<<<<<< HEAD

=======
@runnable
>>>>>>> origin/feature/gherkin-with-behavetag
    Scenario: send nodoChiediSceltaWISP
        Given initial XML nodoChiediSceltaWISP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediSceltaWISP>
<<<<<<< HEAD
                    <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>44444444444</identificativoDominio>
=======
                    <identificativoIntermediarioPA>66666666666</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>66666666666_01</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>66666666666</identificativoDominio>
>>>>>>> origin/feature/gherkin-with-behavetag
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