Feature: process tests for nodoChiediListaPendentiRPT 803
    Background:
        Given systems up

 @runnable
    Scenario: Execute nodoChiediListaPendentiRPT request
        Given initial XML nodoChiediListaPendentiRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediListaPendentiRPT>
                <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                <rangeDa>#yesterday_date#</rangeDa>
                <dimensioneLista>5</dimensioneLista>
            </ws:nodoChiediListaPendentiRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When EC sends SOAP nodoChiediListaPendentiRPT to nodo-dei-pagamenti
        #Then check totRestituiti field exists in nodoChiediListaPendentiRPT response
        Then check listaRPTPendenti field exists in nodoChiediListaPendentiRPT response
        And check identificativoUnivocoVersamento field exists in nodoChiediListaPendentiRPT response