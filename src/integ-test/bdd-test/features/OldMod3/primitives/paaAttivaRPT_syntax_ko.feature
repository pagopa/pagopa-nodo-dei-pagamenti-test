Feature: Syntax check KO for paaAttivaRPT
    Background:
        Given systems up
        And initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoAttivaRPT>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#id_broker#</identificativoIntermediarioPSP>
                    <identificativoCanale>${canale}</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <codiceContestoPagamentoCCD01</codiceContestoPagamento>
                    <identificativoIntermediarioPSPPagamento>#id_broker#</identificativoIntermediarioPSPPagamento>
                    <identificativoCanalePagamento>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanalePagamento>
                    <codificaInfrastrutturaPSP>BARCODE-GS1-128</codificaInfrastrutturaPSP>
                    <codiceIdRPT><bc:BarCode>  <bc:Gln>9000000000001</bc:Gln>  <!--<bc:CodStazPA>11</bc:CodStazPA>-->  <bc:AuxDigit>3</bc:AuxDigit>  <bc:CodIUV>${#TestCase#iuv}</bc:CodIUV> </bc:BarCode> </codiceIdRPT>
                    <datiPagamentoPSP>
                        <importoSingoloVersamento>10.00</importoSingoloVersamento>
                        <!--Optional:-->
                        <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
                        <!--Optional:-->
                        <bicAppoggio>CCRTIT2TXXX</bicAppoggio>
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

    # Scenario Outline: Check faultCode PPT_SINTASSI_EXTRAXSD error on .....
    #     Given <attribute> set <value> for <elem> in paaAttivaRPT
    #     When nodo-dei-pagamenti sends SOAP paaAttivaRPT to EC
    #     Then check faultCode is PPT_SINTASSI_EXTRAXSD of paaAttivaRPT response
    #     Examples:
    #         | elem             | attribute     | value                                     | soapUI test |
    #         | soapenv:Envelope | xmlns:soapenv | http://schemas.xmlsoap.org/ciao/envelope/ | VRPTSIN1    |
