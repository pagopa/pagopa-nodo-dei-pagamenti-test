Feature: T042_verifica_attiva_QRcode_aux=0_gestioneKO_PDD_egov 559

    Background:
        Given systems up

    Scenario: Execute nodoVerificaRPT
        Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr#
        And initial XML nodoVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoVerificaRPT>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>checkFaultPDDegov</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT>
            <qrc:QrCode>
            <qrc:CF>90000000001</qrc:CF>
            <qrc:CodStazPA>#cod_segr#</qrc:CodStazPA>
            <qrc:AuxDigit>0</qrc:AuxDigit>
            <qrc:CodIUV>$1iuv</qrc:CodIUV>
            </qrc:QrCode></codiceIdRPT>
            </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paaVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
            <soapenv:Body>
            <soapenv:Fault>
            <faultcode>soapenv:EGOV_IT_105</faultcode>
            <faultstring>SPC/PortaEquivalenteEngPayTest ha rilevato le seguenti eccezioni:Servizio</faultstring>
            <faultactor>OpenSPCoop</faultactor>
            <detail>
            <eGov_IT_Ecc:MessaggioDiErroreApplicativo xmlns:eGov_IT_Ecc="http://www.cnipa.it/schemas/2003/eGovIT/Exception1_0/">
            <eGov_IT_Ecc:OraRegistrazione>2019-06-17T11:49:22.641</eGov_IT_Ecc:OraRegistrazione>
            <eGov_IT_Ecc:IdentificativoPorta>PortaEquivalenteTestSPCoopIT</eGov_IT_Ecc:IdentificativoPorta>
            <eGov_IT_Ecc:IdentificativoFunzione>SbustamentoRisposte</eGov_IT_Ecc:IdentificativoFunzione>
            <eGov_IT_Ecc:Eccezione>
            <eGov_IT_Ecc:EccezioneBusta codiceEccezione="EGOV_IT_105"
            descrizioneEccezione="SPC/PortaEquivalenteEngPayTest ha rilevato le seguenti eccezioni:&#xa;Servizio"/>
            </eGov_IT_Ecc:Eccezione>
            </eGov_IT_Ecc:MessaggioDiErroreApplicativo>
            </detail>
            </soapenv:Fault>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When EC sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoVerificaRPT response
        And check faultCode is PPT_STAZIONE_INT_PA_SERVIZIO_NONATTIVO of nodoVerificaRPT response

    @runnable
    Scenario: Execute nodoAttivaRPT
        Given the Execute nodoVerificaRPT scenario executed successfully
        And initial XML nodoAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoAttivaRPT>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <codiceContestoPagamento>checkFaultPDDegov</codiceContestoPagamento>
            <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
            <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT>
            <qrc:QrCode>
            <qrc:CF>90000000001</qrc:CF>
            <qrc:CodStazPA>#cod_segr#</qrc:CodStazPA>
            <qrc:AuxDigit>0</qrc:AuxDigit>
            <qrc:CodIUV>$1iuv</qrc:CodIUV>
            </qrc:QrCode></codiceIdRPT>
            <datiPagamentoPSP>
            <importoSingoloVersamento>10.00</importoSingoloVersamento>
            </datiPagamentoPSP>
            </ws:nodoAttivaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoAttivaRPT response
        And check faultCode is PPT_STAZIONE_INT_PA_SERVIZIO_NONATTIVO of nodoAttivaRPT response