Feature: T212_verifica_attiva_PortaleRTServizioPOF

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
                    <codiceContestoPagamento>#ccp#</codiceContestoPagamento>
                    <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                    <codiceIdRPT><qrc:QrCode>  <qrc:CF>90000000001</qrc:CF> <qrc:CodStazPA>#cod_segr#</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>$1iuv</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
                </ws:nodoVerificaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoVerificaRPT response
        
    @midRunnable
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
                    <codiceContestoPagamento>112691872013312</codiceContestoPagamento>
                    <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
                    <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
                    <codificaInfrastrutturaPSP>QR-CODE</codificaInfrastrutturaPSP>
                    <codiceIdRPT><qrc:QrCode>  <qrc:CF>90000000001</qrc:CF> <qrc:CodStazPA>#cod_segr#</qrc:CodStazPA> <qrc:AuxDigit>0</qrc:AuxDigit>  <qrc:CodIUV>$1iuv</qrc:CodIUV> </qrc:QrCode></codiceIdRPT>
                    <datiPagamentoPSP>
                        <importoSingoloVersamento>10.00</importoSingoloVersamento>
                        <!--Optional:-->
                        <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
                        <!--Optional:-->
                        <bicAppoggio>CCRTIT5TXXX</bicAppoggio>
                        <!--Optional:-->
                        <soggettoVersante>
                        <pag:identificativoUnivocoVersante>
                            <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
                            <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
                        </pag:identificativoUnivocoVersante>
                        <pag:anagraficaVersante>Franco Rossi</pag:anagraficaVersante>
                        <!--Optional:-->
                        <pag:indirizzoVersante>viale Monza</pag:indirizzoVersante>
                        <!--Optional:-->
                        <pag:civicoVersante>1</pag:civicoVersante>
                        <!--Optional:-->
                        <pag:capVersante>20125</pag:capVersante>
                        <!--Optional:-->
                        <pag:localitaVersante>Milano</pag:localitaVersante>
                        <!--Optional:-->
                        <pag:provinciaVersante>MI</pag:provinciaVersante>
                        <!--Optional:-->
                        <pag:nazioneVersante>IT</pag:nazioneVersante>
                        <!--Optional:-->
                        <pag:e-mailVersante>mail@mail.it</pag:e-mailVersante>
                        </soggettoVersante>
                        <!--Optional:-->
                        <ibanAddebito>IT96R0123454321000000012346</ibanAddebito>
                        <!--Optional:-->
                        <bicAddebito>CCRTIT2TXXX</bicAddebito>
                        <!--Optional:-->
                        <soggettoPagatore>
                        <pag:identificativoUnivocoPagatore>
                            <pag:tipoIdentificativoUnivoco>F</pag:tipoIdentificativoUnivoco>
                            <pag:codiceIdentificativoUnivoco>RSSFNC50S01L781H</pag:codiceIdentificativoUnivoco>
                        </pag:identificativoUnivocoPagatore>
                        <pag:anagraficaPagatore>Franco Rossi</pag:anagraficaPagatore>
                        <!--Optional:-->
                        <pag:indirizzoPagatore>viale Monza</pag:indirizzoPagatore>
                        <!--Optional:-->
                        <pag:civicoPagatore>1</pag:civicoPagatore>
                        <!--Optional:-->
                        <pag:capPagatore>20125</pag:capPagatore>
                        <!--Optional:-->
                        <pag:localitaPagatore>Milano</pag:localitaPagatore>
                        <!--Optional:-->
                        <pag:provinciaPagatore>MI</pag:provinciaPagatore>
                        <!--Optional:-->
                        <pag:nazionePagatore>IT</pag:nazionePagatore>
                        <!--Optional:-->
                        <pag:e-mailPagatore>mail@mail.it</pag:e-mailPagatore>
                        </soggettoPagatore>
                    </datiPagamentoPSP>
                </ws:nodoAttivaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti 
        Then check esito is OK of nodoAttivaRPT response
        And check importoSingoloVersamento field exists in nodoAttivaRPT response
        And check ibanAccredito field exists in nodoAttivaRPT response