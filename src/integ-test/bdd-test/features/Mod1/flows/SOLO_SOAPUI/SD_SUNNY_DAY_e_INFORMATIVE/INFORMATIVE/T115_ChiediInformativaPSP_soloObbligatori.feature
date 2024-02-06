Feature: T115_ChiediInformativaPSP_soloObbligatori 486

    Background:
        Given systems up

#test rimosso dall'automazione: primitiva deprecata
    Scenario: Send nodoChiediInformativaPSP
        Given initial XML nodoChiediInformativaPSP
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoChiediInformativaPSP>
                    <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <!--identificativoDominio>#creditor_institution_code#</identificativoDominio-->
                    <!--identificativoPSP>#psp#</identificativoPSP-->
                </ws:nodoChiediInformativaPSP>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoChiediInformativaPSP to nodo-dei-pagamenti
        Then check xmlInformativa field exists in nodoChiediInformativaPSP response
        And check ppt:nodoChiediInformativaPSPRisposta field exists in nodoChiediInformativaPSP response
        And check fault field not exists in nodoChiediInformativaPSP response