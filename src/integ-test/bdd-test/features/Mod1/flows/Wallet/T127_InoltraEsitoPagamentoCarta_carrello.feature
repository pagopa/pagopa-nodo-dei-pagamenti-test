Feature: process tests for chiediInformazioniPagamento

    Background:
        Given systems up

    Scenario: RPT generation
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>44444444444</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>44444444444_01</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                    <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
                <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                    <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                    <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
                <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
                <pay_i:importoTotaleDaVersare>6.20</pay_i:importoTotaleDaVersare>
                <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
                <pay_i:identificativoUnivocoVersamento>#IUV#</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
                <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
                <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
                <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
                <pay_i:datiSingoloVersamento>
                    <pay_i:importoSingoloVersamento>6.20</pay_i:importoSingoloVersamento>
                    <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
                    <pay_i:ibanAccredito>IT45R0760103200000000001016</pay_i:ibanAccredito>
                    <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
                    <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
                    <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
                    <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
                    <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                    <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """
    
    Scenario: RT generation
        Given the RPT generation scenario executed successfully
        And RT generation
            """"
            <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>44444444444</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>44444444444_01</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>IdentificativoMessaggioRicevuta</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>RiferimentoMessaggioRichiesta</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2001-01-01</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                    <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>IDPSPFNZ</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUnitOperAttestante</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                    <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                    <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
                <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                    <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>$IUV</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                    <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                    <pay_i:esitoSingoloPagamento>REJECT</pay_i:esitoSingoloPagamento>
                    <pay_i:dataEsitoSingoloPagamento>2001-01-01</pay_i:dataEsitoSingoloPagamento>
                    <pay_i:identificativoUnivocoRiscossione>$IUV</pay_i:identificativoUnivocoRiscossione>
                    <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                    <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
            </pay_i:RT>
            """

    Scenario: RT2 generation
        Given the RT generation scenario executed successfully
        And RT2 generation
            """
            <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>44444444444</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>44444444444_01</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>IdentificativoMessaggioRicevuta</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>RiferimentoMessaggioRichiesta</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2001-01-01</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoAttestante>
                    <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>IDPSPFNZ</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoAttestante>
                <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
                <pay_i:codiceUnitOperAttestante>CodiceUnitOperAttestante</pay_i:codiceUnitOperAttestante>
                <pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante>
                <pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante>
                <pay_i:civicoAttestante>11</pay_i:civicoAttestante>
                <pay_i:capAttestante>11111</pay_i:capAttestante>
                <pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante>
                <pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante>
                <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
                <pay_i:identificativoUnivocoBeneficiario>
                    <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoBeneficiario>
                <pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario>
                <pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario>
                <pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario>
                <pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario>
                <pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario>
                <pay_i:capBeneficiario>22222</pay_i:capBeneficiario>
                <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
                <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
                <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
                <pay_i:identificativoUnivocoVersante>
                    <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoVersante>
                <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
                <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
                <pay_i:civicoVersante>11</pay_i:civicoVersante>
                <pay_i:capVersante>00186</pay_i:capVersante>
                <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
                <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
                <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
                <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
                <pay_i:identificativoUnivocoPagatore>
                    <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoPagatore>
                <pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore>
                <pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore>
                <pay_i:civicoPagatore>11</pay_i:civicoPagatore>
                <pay_i:capPagatore>00186</pay_i:capPagatore>
                <pay_i:localitaPagatore>Roma</pay_i:localitaPagatore>
                <pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore>
                <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
                <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
                <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
                <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
                <pay_i:identificativoUnivocoVersamento>#IUV2#</pay_i:identificativoUnivocoVersamento>
                <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                    <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                    <pay_i:esitoSingoloPagamento>REJECT</pay_i:esitoSingoloPagamento>
                    <pay_i:dataEsitoSingoloPagamento>2001-01-01</pay_i:dataEsitoSingoloPagamento>
                    <pay_i:identificativoUnivocoRiscossione>$IUV</pay_i:identificativoUnivocoRiscossione>
                    <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
                    <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
            </pay_i:RT>
            """

    Scenario: Execute nodoInviaCarrelloRPT request
        Given the RT2 generation scenario executed successfully
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
                <ppt:intestazioneCarrelloPPT>
                    <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                    <identificativoCarrello>#carrelloMills#</identificativoCarrello>
                </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaCarrelloRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_03</identificativoCanale>
                    <listaRPT>
                        <elementoListaRPT>
                        <identificativoDominio>44444444444</identificativoDominio>
                        <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                        <!--tipoFirma></tipoFirma-->
                        <rpt>$rptAttachment</rpt>
                        </elementoListaRPT>
                    </listaRPT>
                </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaCarrelloRPT response
        And check url contains acardste of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url

    Scenario: Execution idPagamento
        Given the Execute nodoInviaRPT request scenario executed successfully
        When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check email field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check urlRedirectEC field exists in informazioniPagamento response

    Scenario: Execution Esito Carta
        Given the Execution idPagamento scenario executed successfully
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT 
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaCarrelloRPTResponse>
            <pspInviaCarrelloRPTResponse>
            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
            <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
            <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
            </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti

            """
            {
            "idPagamento": "$sessionToken",
            "RRN":10026669,
            "identificativoPsp": "#psp_AGID#",
            "tipoVersamento": "CP",
            "identificativoIntermediario": "97735020584",
            "identificativoCanale": "97735020584_02",
            "esitoTransazioneCarta": "123456", 
            "importoTotalePagato": 11.11,
            "timestampOperazione": "2012-04-23T18:25:43.001Z",
            "codiceAutorizzativo": "123212"
            }
             """
        Then verify the HTTP status code of inoltroEsito/carta response is 200
        And check esito is OK of inoltroEsito/carta response

    Scenario: Execute nodoChiediStatoRPT request
        Given the Execution Esito Carta scenario executed successfully
        And initial XML nodoChiediStatoRPT

        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:nodoChiediStatoRPT>
                <identificativoIntermediarioPA>44444444444</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>44444444444_01</identificativoStazioneIntermediarioPA>
                <password>pwdpwdpwd</password>
                <identificativoDominio>44444444444</identificativoDominio>
                <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
                <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            </ws:nodoChiediStatoRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """

        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_PSP of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response

    Scenario: Execute nodoChiediAvanzamentoPagamento
        Given the Execute nodoChiediStatoRPT request scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento is 200
    
    Scenario: Execution second rest Esito Carta
        Given the Execute nodoChiediAvanzamentoPagamento scenario executed successfully
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT 
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspInviaCarrelloRPTResponse>
            <pspInviaCarrelloRPTResponse>
            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
            <identificativoCarrello>$nodoInviaCarrelloRPT.identificativoCarrello</identificativoCarrello>
            <parametriPagamentoImmediato>idBruciatura=$nodoInviaCarrelloRPT.identificativoCarrello</parametriPagamentoImmediato>
            </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTResponse>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti

            """
            {
            "idPagamento": "$sessionToken",
            "RRN":10026669,
            "identificativoPsp": "#psp_AGID#",
            "tipoVersamento": "CP",
            "identificativoIntermediario": "97735020584",
            "identificativoCanale": "97735020584_02",
            "esitoTransazioneCarta": "123456", 
            "importoTotalePagato": 11.11,
            "timestampOperazione": "2012-04-23T18:25:43.001Z",
            "codiceAutorizzativo": "123212"
            }
             """
        Then verify the HTTP status code of inoltroEsito/carta response is 200
        And check esito is OK of inoltroEsito/carta response
        And check url field not exists in inoltroEsito/carta response

    Scenario: Execute nodoInviaRT request
        Given the Execution second rest Esito Carta scenario executed successfully
        And initial XML nodoInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoInviaRT>
            <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
            <identificativoCanale>40000000001_03</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoPSP>40000000001</identificativoPSP>
            <identificativoDominio>44444444444</identificativoDominio>
            <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <tipoFirma></tipoFirma>
            <forzaControlloSegno>1</forzaControlloSegno>
            <rt>$rtAttachment</rt>
            </ws:nodoInviaRT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response

    Scenario: Execute nodoInviaRT2 request
        Given the Execute nodoInviaRT request scenario executed successfully
        And rt with $rt2Attachment in nodoInviaRT
        And identificativoUnivocoVersamento with $2IUV in nodoInviaRT
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response