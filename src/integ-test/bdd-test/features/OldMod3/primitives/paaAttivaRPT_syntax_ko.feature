Feature: Syntax checks KO for nodoAttivaRPT 1413
    Background:
        Given systems up
        #And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
        And initial XML nodoAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoAttivaRPT>
                    <identificativoPSP>#psp#</identificativoPSP>
                    <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                    <identificativoCanale>#canale#</identificativoCanale>
                    <password>pwd</password>
                    <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                    <identificativoIntermediarioPSPPagamento>#psp#</identificativoIntermediarioPSPPagamento>
                    <identificativoCanalePagamento>#canale#</identificativoCanalePagamento>
                    <codificaInfrastrutturaPSP>BARCODE-GS1-128</codificaInfrastrutturaPSP>
                    <codiceIdRPT><bc:BarCode>  <bc:Gln>#creditor_institution_code_secondary#</bc:Gln>  <!--<bc:CodStazPA>11</bc:CodStazPA>-->  <bc:AuxDigit>3</bc:AuxDigit>  <bc:CodIUV>11102281035412050</bc:CodIUV> </bc:BarCode> </codiceIdRPT>
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
@runnable 
    Scenario: Execute nodoAttivaRPT [ARPTRES1]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>KO</esito>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoAttivaRPT response
        And check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable
    Scenario: Execute nodoAttivaRPT [ARPTRES2]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <fault>
                    <faultCode>PAA_SEMANTICA</faultCode>
                    <faultString>Firma non disponibile</faultString>
                    <id>#creditor_institution_code_secondary#</id>
                    </fault>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>100.00</importoSingoloVersamento>
                    <causaleVersamento>/RFB/IUV1908/10.0/TXT/pagamento fotocopie pratica</causaleVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable
    Scenario: Execute nodoAttivaRPT [ARPTRES3]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <causaleVersamento>/RFB/IUV1908/10.0/TXT/pagamento fotocopie pratica</causaleVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable
    Scenario: Execute nodoAttivaRPT [ARPTRES4]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>100.00</importoSingoloVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable
    Scenario: Execute nodoAttivaRPT [ARPTRES5]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>100.00</importoSingoloVersamento>
                    <causaleVersamento>Fotocopie</causaleVersamento>
                    <spezzoniCausaleVersamento>
                        <!--You have a CHOICE of the next 2 items at this level-->
                        <spezzoneCausaleVersamento>/RFB/IUV1908/10.0/TXT/pagamento fotocopie pratica</spezzoneCausaleVersamento>
                    </spezzoniCausaleVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable
    Scenario: Execute nodoAttivaRPT [ARPTRES6]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>100.00</importoSingoloVersamento>
                    <spezzoniCausaleVersamento>
                        <!--You have a CHOICE of the next 2 items at this level-->
                        <spezzoneCausaleVersamento>/RFB/IUV1908/10.0/TXT/pagamento fotocopie pratica</spezzoneCausaleVersamento>
                        <spezzoneStrutturatoCausaleVersamento>
                            <causaleSpezzone>/RFB/IUV1908/10.0/TXT/pagamento fotocopie pratica1</causaleSpezzone>
                            <importoSpezzone>10.00</importoSpezzone>
                        </spezzoneStrutturatoCausaleVersamento>
                    </spezzoniCausaleVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable    
    Scenario: Execute nodoAttivaRPT [ARPTRES7]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>100.0</importoSingoloVersamento>
                    <causaleVersamento>/RFB/IUV1908/10.0/TXT/pagamento fotocopie pratica</causaleVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response

@runnable    
    Scenario: Execute nodoAttivaRPT [ARPTRES8]
        Given initial XML paaAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
                <paaAttivaRPTRisposta>
                    <esito>OK</esito>
                    <datiPagamentoPA>
                    <importoSingoloVersamento>100</importoSingoloVersamento>
                    <causaleVersamento>/RFB/IUV1908/10.0/TXT/pagamento fotocopie pratica</causaleVersamento>
                    </datiPagamentoPA>
                </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When PSP sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check faultCode is PPT_SINTASSI_EXTRAXSD of nodoAttivaRPT response