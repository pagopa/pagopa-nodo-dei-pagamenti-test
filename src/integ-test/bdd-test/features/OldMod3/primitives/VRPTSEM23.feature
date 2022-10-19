Feature: Semantic checks KO for nodoVerificaRPT
    Background:
        Given systems up

    Scenario: Check PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE error on unreachable station[VRPTSEM23]
        Given initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoVerificaRPT>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>91000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_01</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <codiceContestoPagamento>153041492411187</codiceContestoPagamento>
                    <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                    <codiceIdRPT><qrc:QrCode>  <qrc:CF>44444444444</qrc:CF> <qrc:CodStazPA>02</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>013601115164900</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
                </ws:nodoVerificaRPT>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoVerificaRPT response