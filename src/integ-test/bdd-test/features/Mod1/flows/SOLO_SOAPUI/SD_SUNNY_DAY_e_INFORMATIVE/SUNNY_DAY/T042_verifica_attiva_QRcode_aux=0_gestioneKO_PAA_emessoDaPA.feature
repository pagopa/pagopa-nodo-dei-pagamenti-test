Feature: T042_verifica_attiva_QRcode_aux=0_gestioneKO_PAA_emessoDaPA 558

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
            <codiceContestoPagamento>KOdaPA</codiceContestoPagamento>
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT>
            <qrc:QrCode>
            <qrc:CF>#creditor_institution_code#</qrc:CF>
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
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/"   xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
                <soapenv:Header/>
                <soapenv:Body>
                    <ws:paaVerificaRPTRisposta>
                        <paaVerificaRPTRisposta>
                            <fault>
                            <faultCode>PAA_SEMANTICA</faultCode>
                            <faultString>chiamata da rifiutare</faultString>
                            <id>#creditor_institution_code#</id>
                            </fault>
                            <esito>KO</esito>
                        </paaVerificaRPTRisposta>
                    </ws:paaVerificaRPTRisposta>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When EC sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoVerificaRPT response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of nodoVerificaRPT response

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
            <codiceContestoPagamento>KOdaPA</codiceContestoPagamento>
            <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
            <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
            <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
            <codiceIdRPT>
            <qrc:QrCode>
            <qrc:CF>#creditor_institution_code#</qrc:CF>
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
        And initial XML paaAttivaRPT
            """
                <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
                <soapenv:Header/>
                <soapenv:Body>
                <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                <fault>
                <faultCode>PAA_SEMANTICA</faultCode>
                <faultString>chiamata da rifiutare</faultString>
                <id>#creditor_institution_code#</id>
                <description>servizio sconosciuto</description>
                </fault>
                <esito>KO</esito>
                </paaAttivaRPTRisposta>
                </ws:paaAttivaRPTRisposta>
                </soapenv:Body>
                </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When EC sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoAttivaRPT response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of nodoAttivaRPT response
