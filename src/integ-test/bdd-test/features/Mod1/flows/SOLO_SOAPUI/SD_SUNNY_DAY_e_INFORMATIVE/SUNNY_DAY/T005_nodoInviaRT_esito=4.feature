Feature: T005_nodoInviaRT_esito=4
    Background:
        Given systems up

    Scenario: RPT generation
        Given RPT1 generation
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>#IUV1#</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
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
        And RT1 generation
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <RT xmlns="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <versioneOggetto>6.0</versioneOggetto>
            <dominio>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoStazioneRichiedente>#id_station#</identificativoStazioneRichiedente>
            </dominio>
            <identificativoMessaggioRicevuta>IdentificativoMessaggioRicevuta</identificativoMessaggioRicevuta>
            <dataOraMessaggioRicevuta>#timedate#</dataOraMessaggioRicevuta>
            <riferimentoMessaggioRichiesta>RiferimentoMessaggioRichiesta</riferimentoMessaggioRichiesta>
            <riferimentoDataRichiesta>2001-01-01</riferimentoDataRichiesta>
            <istitutoAttestante>
            <identificativoUnivocoAttestante>
            <tipoIdentificativoUnivoco>G</tipoIdentificativoUnivoco>
            <codiceIdentificativoUnivoco>IDPSPFNZ</codiceIdentificativoUnivoco>
            </identificativoUnivocoAttestante>
            <denominazioneAttestante>DenominazioneAttestante</denominazioneAttestante>
            <codiceUnitOperAttestante>CodiceUnitOperAttestante</codiceUnitOperAttestante>
            <denomUnitOperAttestante>DenomUnitOperAttestante</denomUnitOperAttestante>
            <indirizzoAttestante>IndirizzoAttestante</indirizzoAttestante>
            <civicoAttestante>11</civicoAttestante>
            <capAttestante>11111</capAttestante>
            <localitaAttestante>LocalitaAttestante</localitaAttestante>
            <provinciaAttestante>ProvinciaAttestante</provinciaAttestante>
            <nazioneAttestante>IT</nazioneAttestante>
            </istitutoAttestante>
            <enteBeneficiario>
            <identificativoUnivocoBeneficiario>
            <tipoIdentificativoUnivoco>G</tipoIdentificativoUnivoco>
            <codiceIdentificativoUnivoco>11111111117</codiceIdentificativoUnivoco>
            </identificativoUnivocoBeneficiario>
            <denominazioneBeneficiario>AZIENDA XXX</denominazioneBeneficiario>
            <codiceUnitOperBeneficiario>123</codiceUnitOperBeneficiario>
            <denomUnitOperBeneficiario>XXX</denomUnitOperBeneficiario>
            <indirizzoBeneficiario>IndirizzoBeneficiario</indirizzoBeneficiario>
            <civicoBeneficiario>123</civicoBeneficiario>
            <capBeneficiario>22222</capBeneficiario>
            <localitaBeneficiario>Roma</localitaBeneficiario>
            <provinciaBeneficiario>RM</provinciaBeneficiario>
            <nazioneBeneficiario>IT</nazioneBeneficiario>
            </enteBeneficiario>
            <soggettoVersante>
            <identificativoUnivocoVersante>
            <tipoIdentificativoUnivoco>F</tipoIdentificativoUnivoco>
            <codiceIdentificativoUnivoco>RCCGLD09P09H502E</codiceIdentificativoUnivoco>
            </identificativoUnivocoVersante>
            <anagraficaVersante>Gesualdo;Riccitelli</anagraficaVersante>
            <indirizzoVersante>via del gesu</indirizzoVersante>
            <civicoVersante>11</civicoVersante>
            <capVersante>00186</capVersante>
            <localitaVersante>Roma</localitaVersante>
            <provinciaVersante>RM</provinciaVersante>
            <nazioneVersante>IT</nazioneVersante>
            <e-mailVersante>gesualdo.riccitelli@poste.it</e-mailVersante>
            </soggettoVersante>
            <soggettoPagatore>
            <identificativoUnivocoPagatore>
            <tipoIdentificativoUnivoco>F</tipoIdentificativoUnivoco>
            <codiceIdentificativoUnivoco>RCCGLD09P09H501E</codiceIdentificativoUnivoco>
            </identificativoUnivocoPagatore>
            <anagraficaPagatore>Gesualdo;Riccitelli</anagraficaPagatore>
            <indirizzoPagatore>via del gesu</indirizzoPagatore>
            <civicoPagatore>11</civicoPagatore>
            <capPagatore>00186</capPagatore>
            <localitaPagatore>Roma</localitaPagatore>
            <provinciaPagatore>RM</provinciaPagatore>
            <nazionePagatore>IT</nazionePagatore>
            <e-mailPagatore>gesualdo.riccitelli@poste.it</e-mailPagatore>
            </soggettoPagatore>
            <datiPagamento>
            <codiceEsitoPagamento>4</codiceEsitoPagamento>
            <importoTotalePagato>0.00</importoTotalePagato>
            <identificativoUnivocoVersamento>$1IUV</identificativoUnivocoVersamento>
            <CodiceContestoPagamento>CCD01</CodiceContestoPagamento>
            <datiSingoloPagamento>
            <singoloImportoPagato>0.00</singoloImportoPagato>
            <esitoSingoloPagamento>NON_PAGATO</esitoSingoloPagamento>
            <dataEsitoSingoloPagamento>#date#</dataEsitoSingoloPagamento>
            <identificativoUnivocoRiscossione>$1IUV</identificativoUnivocoRiscossione>
            <causaleVersamento>pagamento fotocopie pratica</causaleVersamento>
            <datiSpecificiRiscossione>1/abc</datiSpecificiRiscossione>
            <commissioniApplicatePSP>0.12</commissioniApplicatePSP>
            </datiSingoloPagamento>
            </datiPagamento>
            </RT>
            """

    Scenario: Execute nodoInviaRPT request
        Given the RPT generation scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#intermediarioPA#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$1IUV</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rpt1Attachment</rpt>
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
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    @ciao
    Scenario: Execute nodoInviaRT 
        Given the Execute nodoInviaRPT request scenario executed successfully
        And initial XML nodoInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoInviaRT>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canaleRtPush#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$1IUV</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
            <tipoFirma></tipoFirma>
            <forzaControlloSegno>1</forzaControlloSegno>
            <rt>$rt1Attachment</rt>
            </ws:nodoInviaRT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRT response
        And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response


