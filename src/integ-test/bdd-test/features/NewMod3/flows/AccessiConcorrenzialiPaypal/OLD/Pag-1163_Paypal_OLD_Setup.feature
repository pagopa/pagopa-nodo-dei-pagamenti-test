Feature: DB checks for nodoInoltraEsitoPagamentoPaypal on old PA

    Background:
        Given systems up
        And initial XML nodoVerificaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified" xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
           <soapenv:Header/>
           <soapenv:Body>
              <ws:nodoVerificaRPT>
                 <identificativoPSP>${pspCD}</identificativoPSP>
                 <identificativoIntermediarioPSP>${intermediarioPSPCD}</identificativoIntermediarioPSP>
                 <identificativoCanale>${canaleCD}</identificativoCanale>
                 <password>${password}</password>
                 <codiceContestoPagamento>$ccp</codiceContestoPagamento>
                 <codificaInfrastrutturaPSP>$codifica</codificaInfrastrutturaPSP>
                 <codiceIdRPT>$barcode</codiceIdRPT>
              </ws:nodoVerificaRPT>
           </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML nodoAttivaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:bc="http://PuntoAccessoPSP.spcoop.gov.it/BarCode_GS1_128_Modified"  xmlns:aim="http://PuntoAccessoPSP.spcoop.gov.it/Code_128_AIM_USS-128_tipo_C" xmlns:qrc="http://PuntoAccessoPSP.spcoop.gov.it/QrCode">
           <soapenv:Header/>
           <soapenv:Body>
              <ws:nodoAttivaRPT>
                 <identificativoPSP>${pspCD}</identificativoPSP>
                 <identificativoIntermediarioPSP>${intermediarioPSPCD}</identificativoIntermediarioPSP>
                 <identificativoCanale>${canaleCD}</identificativoCanale>
                 <password>${password}</password>
                 <codiceContestoPagamento>$ccp</codiceContestoPagamento>
                 <identificativoIntermediarioPSPPagamento>${intermediarioPSPAgid}</identificativoIntermediarioPSPPagamento>
                 <identificativoCanalePagamento>${canaleAgID}</identificativoCanalePagamento>
                 <codificaInfrastrutturaPSP>$codifica</codificaInfrastrutturaPSP>
                 <codiceIdRPT>$barcode</codiceIdRPT>
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
        And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
           <soapenv:Header>
              <ppt:intestazionePPT>
                 <identificativoIntermediarioPA>${intermediarioPA}</identificativoIntermediarioPA>
                 <identificativoStazioneIntermediarioPA>${stazioneAux03}</identificativoStazioneIntermediarioPA>
                 <identificativoDominio>${pa}</identificativoDominio>
                 <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                 <codiceContestoPagamento>$ccp</codiceContestoPagamento>
              </ppt:intestazionePPT>
           </soapenv:Header>
           <soapenv:Body>
              <ws:nodoInviaRPT>
                 <password>${password}</password>
                 <identificativoPSP>${pspAgid}</identificativoPSP>
                 <identificativoIntermediarioPSP>${intermediarioPSPAgid}</identificativoIntermediarioPSP>
                 <identificativoCanale>97735020584_02</identificativoCanale>
                 <tipoFirma></tipoFirma>
                 <rpt>$rptAttachment</rpt>
              </ws:nodoInviaRPT>
           </soapenv:Body>
        </soapenv:Envelope>
        """
        When psp sends SOAP nodoVerificaRPT to nodo-dei-pagamenti
        Then check outcome is OK of nodoVerificaRPT response

    Scenario: send nodoAttivaRPT
        When psp sends SOAP nodoAttivaRPT to nodo-dei-pagamenti
        Then check outcome is OK of nodoAttivaRPT response

    Scenario: send nodoInviaRPT
        Given the send nodoAttivaRPT scenario executed successfully
        When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check outcome is OK of nodoInviaRPT response

    Scenario: Execute nodoChiediInformazioniPagamento request
        Given the send nodoInviaRPT scenario executed successfully
        When EC sends rest GET /informazioniPagamento?idPagamento=$nodoInviaRPTResponse.idPagamento to nodo-dei-pagamenti
        Then check importo field exists in /informazioniPagamento response
        And check ragioneSociale field exists in /informazioniPagamento response
        And check oggettoPagamento field exists in /informazioniPagamento response
        And check redirect is redirectEC in /informazioniPagamento response
        And check false field exists in /informazioniPagamento response
        And check dettagli field exists in /informazioniPagamento response
        And check iuv field exists in /informazioniPagamento response
        And check ccp field exists in /informazioniPagamento response
        And check pa field exists in /informazioniPagamento response
        And check enteBeneficiario is AZIENDA XXX in /informazioniPagamento response
        And execution query pa_dbcheck_json to get value on the table PA, with the columns ragione_sociale under macro NewMod3 with db name nodo_cfg
        And through the query pa_dbcheck_json retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
        And check $ragione_sociale is ragioneSociale in /informazioniPagamento response