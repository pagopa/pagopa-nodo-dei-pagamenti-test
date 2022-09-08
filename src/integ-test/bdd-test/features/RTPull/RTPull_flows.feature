Feature: RTPull flows

    Background:
        Given systems up
        And RPT generation
        """
        <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
        <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
        <pay_i:dominio>
        <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
        <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
        </pay_i:dominio>
        <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
        <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
        <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
        <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
        <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
        <pay_i:identificativoUnivocoVersamento>#iuv#</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>#ccp#</pay_i:codiceContestoPagamento>
        <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
        <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
        <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
        <pay_i:datiSingoloVersamento>
        <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
        <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
        <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
        <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
        <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
        <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
        <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
        <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
        <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
        </pay_i:datiSingoloVersamento>
        </pay_i:datiVersamento>
        </pay_i:RPT>
        """
        And RT generation
        """
        <?xml version="1.0" encoding="UTF-8"?>
        <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
        <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
        <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
        </pay_i:dominio>
        <pay_i:identificativoMessaggioRicevuta>TR0001_20120302-10:37:52.0264-F098</pay_i:identificativoMessaggioRicevuta>
        <pay_i:dataOraMessaggioRicevuta>2012-03-02T10:37:52</pay_i:dataOraMessaggioRicevuta>
        <pay_i:riferimentoMessaggioRichiesta>TR0001_20120302-10:37:52.0264-F098</pay_i:riferimentoMessaggioRichiesta>
        <pay_i:riferimentoDataRichiesta>2012-01-26</pay_i:riferimentoDataRichiesta>
        <pay_i:istitutoAttestante>
            <pay_i:identificativoUnivocoAttestante>
                <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                <pay_i:codiceIdentificativoUnivoco>CodiceIdentific</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoAttestante>
            <pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante>
            <pay_i:codiceUnitOperAttestante>CodiceUOA</pay_i:codiceUnitOperAttestante>
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
            <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
        </pay_i:enteBeneficiario>
        <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
                <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
                <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501F</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>11</pay_i:civicoVersante>
            <pay_i:capVersante>00186</pay_i:capVersante>
            <pay_i:localitaVersante>Roma</pay_i:localitaVersante>
            <pay_i:provinciaVersante>RM</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
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
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:CodiceContestoPagamento>$ccp</pay_i:CodiceContestoPagamento>
            <pay_i:datiSingoloPagamento>
                <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                <pay_i:esitoSingoloPagamento>ACCEPTED</pay_i:esitoSingoloPagamento>
                <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
                <pay_i:identificativoUnivocoRiscossione>IUV_2021-11-15_13:55:13.038</pay_i:identificativoUnivocoRiscossione>
                <pay_i:causaleVersamento>causale RT pull</pay_i:causaleVersamento>
                <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloPagamento>
        </pay_i:datiPagamento>
        </pay_i:RT>
        """
        And initial XML nodoInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
                <ppt:intestazionePPT>
                    <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
                    <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
                    <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>$ccp</codiceContestoPagamento>
                </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
                <ws:nodoInviaRPT>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>40000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>40000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>40000000001_06</identificativoCanale>
                    <tipoFirma></tipoFirma>
                    <rpt>$rptAttachment</rpt>
                </ws:nodoInviaRPT>
            </soapenv:Body>
        </soapenv:Envelope>           
        """
        And initial XML pspInviaRPT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:pspInviaRPTResponse>
                    <pspInviaRPTResponse>
                        <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                        <identificativoCarrello>$nodoInviaRPT.identificativoUnivocoVersamento</identificativoCarrello>
                        <parametriPagamentoImmediato>idBruciatura=$nodoInviaRPT.identificativoUnivocoVersamento</parametriPagamentoImmediato>
                    </pspInviaRPTResponse>
                </ws:pspInviaRPTResponse>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML pspChiediListaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:pspChiediListaRTResponse>
                <pspChiediListaRTResponse>
            <elementoListaRTResponse>
                        <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$ccp</codiceContestoPagamento>
                    </elementoListaRTResponse>
                </pspChiediListaRTResponse>
            </ws:pspChiediListaRTResponse>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML pspChiediRT
        """
        <soapenv:Envelope
        xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspChiediRTResponse>
                <pspChiediRTResponse>
                    <rt>$rtAttachment</rt>
                </pspChiediRTResponse>
            </ws:pspChiediRTResponse>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML pspInviaAckRT
        """
        <soapenv:Envelope
            xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
            xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:pspInviaAckRTResponse>
                    <pspInviaAckRTResponse>
                        <esito>OK</esito>
                    </pspInviaAckRTResponse>
                </ws:pspInviaAckRTResponse>
            </soapenv:Body>
        </soapenv:Envelope>
        """
        And initial XML paaInviaRT
        """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:paaInviaRTRisposta>
                <paaInviaRTRisposta>
                    <esito>OK</esito>
                </paaInviaRTRisposta>
            </ws:paaInviaRTRisposta>
        </soapenv:Body>
        </soapenv:Envelope>
        """
    @ok
    Scenario: Execute nodoInviaRPT - RT_ACCETTATA_PA [T001]
        Given PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        When EC sends soap nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        And job paInviaRt triggered after 50 seconds
        And wait 50 seconds for expiration
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_ACCETTATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull

    @failed
    Scenario: Execute nodoInviaRPT - RT_RIFIUTATA_PA [T002]
        Given esito with None in pspInviaAckRT
        And esito with KO in paaInviaRT
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        And PSP replies to nodo-dei-pagamenti with the pspInviaAckRT
        And EC replies to nodo-dei-pagamenti with the paaInviaRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        And job paInviaRt triggered after 50 seconds
        And wait 50 seconds for expiration
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_ACCETTATA_NODO, RT_INVIATA_PA, RT_RIFIUTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RT_RIFIUTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull
    
    
    Scenario: Execute nodoInviaRPT - RT_RIFIUTATA_NODO (pspChiediRT_KO_RT_errata) [T003]
        Given rt with InvalidFormat in pspChiediRT
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        And wait 100 seconds for expiration
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_RIFIUTATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull

    @test
    Scenario: Execute nodoInviaRPT - RT_RIFIUTATA_NODO (pspChiediRT_ KO_TAG_RT_errato) [T004]
        Given replace rt tag in pspChiediRT with tagErrato
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        And wait 100 seconds for expiration
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_RIFIUTATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull

    Scenario: Execute nodoInviaRPT - RT_RIFIUTATA_NODO (pspChiediRT_Response_KO) [T005]
        Given initial XML pspChiediRT
        """
        <soapenv:Envelope
        xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/"
        xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspChiediRTResponse>
                <pspChiediRTResponse>
                    <responseMalformata>$rtAttachment</responseMalformata>
                </pspChiediRTResponse>
            </ws:pspChiediRTResponse>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        And PSP replies to nodo-dei-pagamenti with the pspChiediListaRT
        And PSP replies to nodo-dei-pagamenti with the pspChiediRT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        And job pspChiediListaAndChiediRt triggered after 5 seconds
        And wait 100 seconds for expiration
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_RIFIUTATA_NODO, RT_INVIATA_PA, RT_RIFIUTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RPT_ACCETTATA_PSP of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull

    Scenario: Execute nodoInviaRPT - RT_ESITO_SCONOSCIUTO_PA [T006]
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_ACCETTATA_NODO, RT_INVIATA_PA, RT_ESITO_SCONOSCIUTO_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RT_ESITO_SCONOSCIUTO_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value NotNone of the record at column RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull
    
    Scenario: Execute nodoInviaRPT - RPT-RT Marca da bollo [T008]
        Given RT generation
        """
        """
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_ACCETTATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull
    
    Scenario: Execute nodoInviaRPT - RT_ERRORE_INVIO_A_PA [T009]
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_ACCETATA_NODO, RT_INVIATA_PA, RT_ERRORE_INVIO_A_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RT_ERRORE_INVIO_A_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 1 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value NotNone of the record at column RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull
    
    Scenario: Execute nodoInviaRPT - MOD2 [T0XX]
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_INVIATA_A_PSP, RPT_ACCETTATA_PSP, RT_RICEVUTA_NODO, RT_ACCETATA_NODO, RT_INVIATA_PA, RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query rpt_stati on db nodo_online under macro RTPull
        And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query rpt_stati on db nodo_online under macro RTPull

    Scenario: Execute nodoInviaRPT - Retry ack timeout
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        #TODO: check DB

    Scenario: Execute nodoInviaRPT - Retry ack system error
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        #TODO: check DB

    Scenario: Execute nodoInviaRPT - Retry ack errore response
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        #TODO: CHECK DB

    Scenario: Execute nodoInviaRPT - Retry ack response KO
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        #TODO: CHECK DB

    