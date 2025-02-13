Feature: Syntax checks ok for nodoAttivaRPT 1410
    Background:
        Given systems up
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
                        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                        <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
                        <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
                        <codificaInfrastrutturaPSP>BARCODE-128-AIM</codificaInfrastrutturaPSP>
                        <codiceIdRPT><aim:aim128> <aim:CCPost>#ccPoste#</aim:CCPost> <aim:CodStazPA>01</aim:CodStazPA> <aim:AuxDigit>0</aim:AuxDigit>  <aim:CodIUV>010231780177500</aim:CodIUV></aim:aim128></codiceIdRPT>
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

@runnable
    Scenario Outline: Check esito OK invalid body element value
        Given <elem> with <value> in nodoAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoAttivaRPT response
        Examples:
            | elem                            | value                       | SoapUI    |                                                        
            | importoSingoloVersamento        | 0.00                        | ARPTSIN37 |                                         
            | ibanAppoggio                    | XX96R0123454321000000012345 | ARPTSIN43 |