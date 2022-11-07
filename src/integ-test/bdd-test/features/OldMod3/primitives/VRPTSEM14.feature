Feature: Semantic checks KO for nodoVerificaRPT
    Background:
        Given systems up

@runnable
     Scenario: Check faultCode error PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE [VRPTSEM14 ]
        Given initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoVerificaRPT>
                <identificativoPSP>40000000001</identificativoPSP>
                <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                <identificativoCanale>40000000001_01</identificativoCanale>
                <password>pwdpwdpwd</password>
                <codiceContestoPagamento>irraggiungibile</codiceContestoPagamento>
                <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                <codiceIdRPT><aim:aim128> <aim:CCPost>444444444444</aim:CCPost> <aim:CodStazPA>02</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>016101258167700</aim:CodIUV></aim:aim128></codiceIdRPT>
            </ws:nodoVerificaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_STAZIONE_INT_PA_IRRAGGIUNGIBILE of nodoVerificaRPT response