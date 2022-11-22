Feature: T115_ChiediInformativaPSP_soloObbligatori

    Background:
        Given systems up
@midRunnable
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