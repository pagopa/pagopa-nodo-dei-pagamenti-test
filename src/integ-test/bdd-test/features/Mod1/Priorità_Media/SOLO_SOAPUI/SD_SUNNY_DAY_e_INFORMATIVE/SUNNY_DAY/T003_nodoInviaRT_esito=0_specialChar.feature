Feature: T003_nodoInviaRT_esito=0_specialChar

    Background:
        Given systems up

    Scenario: Execute nodoInviaRPT
        Given RPT generation
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>Quì 16 càrattèri</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRichiesta>35 càrattérì spec!@li va# °u£ me$§;</pay_i:identificativoMessaggioRichiesta>
            <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
            <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>va# °u£ me$§;</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>Quì 16 càrattèri</pay_i:civicoVersante>
            <pay_i:capVersante>Quì 16 càrattèri</pay_i:capVersante>
            <pay_i:localitaVersante>35 càrattérì spec!@li va# °u£ me$§;</pay_i:localitaVersante>
            <pay_i:provinciaVersante>35 càrattérì spec!@li va# °u£ me$§;</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
            <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>càrattér1 spec!@</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoPagatore>
            <pay_i:anagraficaPagatore>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:anagraficaPagatore>
            <pay_i:indirizzoPagatore>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:indirizzoPagatore>
            <pay_i:civicoPagatore>Quì 16 càrattèri</pay_i:civicoPagatore>
            <pay_i:capPagatore>Quì 16 càrattèri</pay_i:capPagatore>
            <pay_i:localitaPagatore>35 càrattérì spec!@li va# °u£ me$§;</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>35 càrattérì spec!@li va# °u£ me$§;</pay_i:provinciaPagatore>
            <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:enteBeneficiario>
            <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>spec!@li va#</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>35 càrattérì spec!@li va# °u£ me$§;</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>Quì 16 càrattèri</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>Quì 16 càrattèri</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>35 càrattérì spec!@li va# °u£ me$§;</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>35 càrattérì spec!@li va# °u£ me$§;</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:datiVersamento>
            <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>#IUVspecial#</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>#IUVspecial#</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>35 càrattérì spec!@li va# °u£ me$§;</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """
        And RT generation
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>Quì 16 càrattèri</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRicevuta>35 càrattérì spec!@li va# °u£ me$§;</pay_i:identificativoMessaggioRicevuta>
            <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
            <pay_i:riferimentoMessaggioRichiesta>35 càrattérì spec!@li va# °u£ me$§;</pay_i:riferimentoMessaggioRichiesta>
            <pay_i:riferimentoDataRichiesta>2001-01-01</pay_i:riferimentoDataRichiesta>
            <pay_i:istitutoAttestante>
            <pay_i:identificativoUnivocoAttestante>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>va# °u£ me$§;</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoAttestante>
            <pay_i:denominazioneAttestante>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:denominazioneAttestante>
            <pay_i:codiceUnitOperAttestante>35 càrattérì spec!@li va# °u£ me$§;</pay_i:codiceUnitOperAttestante>
            <pay_i:denomUnitOperAttestante>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:denomUnitOperAttestante>
            <pay_i:indirizzoAttestante>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:indirizzoAttestante>
            <pay_i:civicoAttestante>Quì 16 càrattèri</pay_i:civicoAttestante>
            <pay_i:capAttestante>Quì 16 càrattèri</pay_i:capAttestante>
            <pay_i:localitaAttestante>35 càrattérì spec!@li va# °u£ me$§;</pay_i:localitaAttestante>
            <pay_i:provinciaAttestante>35 càrattérì spec!@li va# °u£ me$§;</pay_i:provinciaAttestante>
            <pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante>
            </pay_i:istitutoAttestante>
            <pay_i:enteBeneficiario>
            <pay_i:identificativoUnivocoBeneficiario>
            <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>càrattér1 spec!@</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoBeneficiario>
            <pay_i:denominazioneBeneficiario>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:denominazioneBeneficiario>
            <pay_i:codiceUnitOperBeneficiario>35 càrattérì spec!@li va# °u£ me$§;</pay_i:codiceUnitOperBeneficiario>
            <pay_i:denomUnitOperBeneficiario>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:denomUnitOperBeneficiario>
            <pay_i:indirizzoBeneficiario>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:indirizzoBeneficiario>
            <pay_i:civicoBeneficiario>Quì 16 càrattèri</pay_i:civicoBeneficiario>
            <pay_i:capBeneficiario>Quì 16 càrattèri</pay_i:capBeneficiario>
            <pay_i:localitaBeneficiario>35 càrattérì spec!@li va# °u£ me$§;</pay_i:localitaBeneficiario>
            <pay_i:provinciaBeneficiario>35 càrattérì spec!@li va# °u£ me$§;</pay_i:provinciaBeneficiario>
            <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
            </pay_i:enteBeneficiario>
            <pay_i:soggettoVersante>
            <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>spec!@li va#</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoVersante>
            <pay_i:anagraficaVersante>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:anagraficaVersante>
            <pay_i:indirizzoVersante>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:indirizzoVersante>
            <pay_i:civicoVersante>Quì 16 càrattèri</pay_i:civicoVersante>
            <pay_i:capVersante>Quì 16 càrattèri</pay_i:capVersante>
            <pay_i:localitaVersante>35 càrattérì spec!@li va# °u£ me$§;</pay_i:localitaVersante>
            <pay_i:provinciaVersante>35 càrattérì spec!@li va# °u£ me$§;</pay_i:provinciaVersante>
            <pay_i:nazioneVersante>IT</pay_i:nazioneVersante>
            <pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante>
            </pay_i:soggettoVersante>
            <pay_i:soggettoPagatore>
            <pay_i:identificativoUnivocoPagatore>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>!@li va# °u£</pay_i:codiceIdentificativoUnivoco>
            </pay_i:identificativoUnivocoPagatore>
            <pay_i:anagraficaPagatore>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:anagraficaPagatore>
            <pay_i:indirizzoPagatore>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:indirizzoPagatore>
            <pay_i:civicoPagatore>Quì 16 càrattèri</pay_i:civicoPagatore>
            <pay_i:capPagatore>Quì 16 càrattèri</pay_i:capPagatore>
            <pay_i:localitaPagatore>35 càrattérì spec!@li va# °u£ me$§;</pay_i:localitaPagatore>
            <pay_i:provinciaPagatore>35 càrattérì spec!@li va# °u£ me$§;</pay_i:provinciaPagatore>
            <pay_i:nazionePagatore>IT</pay_i:nazionePagatore>
            <pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore>
            </pay_i:soggettoPagatore>
            <pay_i:datiPagamento>
            <pay_i:codiceEsitoPagamento>0</pay_i:codiceEsitoPagamento>
            <pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato>
            <pay_i:identificativoUnivocoVersamento>#IUVspecial#</pay_i:identificativoUnivocoVersamento>
            <pay_i:CodiceContestoPagamento>#IUVspecial#</pay_i:CodiceContestoPagamento>
            <pay_i:datiSingoloPagamento>
            <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
            <pay_i:esitoSingoloPagamento>35 càrattérì spec!@li va# °u£ me$§;</pay_i:esitoSingoloPagamento>
            <pay_i:dataEsitoSingoloPagamento>#date#</pay_i:dataEsitoSingoloPagamento>
            <pay_i:identificativoUnivocoRiscossione>#IUVspecial#</pay_i:identificativoUnivocoRiscossione>
            <pay_i:causaleVersamento>Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?Mèttiamocì 70 caratteri stràni che Dév@no e$§ere accet+ati #*[]!, ora?</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            <pay_i:commissioniApplicatePSP>0.12</pay_i:commissioniApplicatePSP>
            </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
            </pay_i:RT>
            """
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$IUVspecial</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$IUVspecial</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
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
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    Scenario: Execute nodoInviaRT
        Given the Execute nodoInviaRPT scenario executed successfully
        And initial XML nodoInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoInviaRT>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$IUVspecial</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$IUVspecial</codiceContestoPagamento>
            <tipoFirma></tipoFirma>
            <forzaControlloSegno>1</forzaControlloSegno>
            <rt>$rtAttachment</rt>
            </ws:nodoInviaRT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response


