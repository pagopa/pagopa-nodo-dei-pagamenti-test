Feature: Semantic checks KO for nodoVerificaRPT
    Background:
        Given systems up

     Scenario: Check faultCode error PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE [VRPTSEM22 ]
        Given initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoVerificaRPT>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#id_broker#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>BARCODE-GS1-128</codificaInfrastrutturaPSP>
            <codiceIdRPT>
                <bc:BarCode>
                    <bc:Gln>1234567890122</bc:Gln>
                    <bc:CodStazPA>01</bc:CodStazPA>
                    <bc:AuxDigit>2</bc:AuxDigit>
                    <bc:CodIUV>123456789012345</bc:CodIUV>
                </bc:BarCode>
            </codiceIdRPT>
            </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_SERVIZIO_NONATTIVO of nodoVerificaRPT response