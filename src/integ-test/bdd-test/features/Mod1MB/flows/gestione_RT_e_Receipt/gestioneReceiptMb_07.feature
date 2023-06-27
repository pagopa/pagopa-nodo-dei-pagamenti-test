Feature: gestioneReceiptMb_07

    Background:
        Given systems up

    Scenario: Execute nodoInviaCarrelloRPT (Phase 1)
        Given generate 1 notice number and iuv with aux digit 3, segregation code 02 and application code -
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
        And replace pa1 content with 90000000001 content
        And RPT1 generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$1carrello</pay_i:codiceContestoPagamento>
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
        And RPT2 generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>$pa1</pay_i:identificativoDominio>

            <pay_i:identificativoStazioneRichiedente>90000000001_01</pay_i:identificativoStazioneRichiedente>

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
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$1carrello</pay_i:codiceContestoPagamento>
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
        And RT1 generation
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_istitution_code#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:CodiceContestoPagamento>$1carrello</pay_i:CodiceContestoPagamento>
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
        And RT2 generation
            """
            <?xml version="1.0" encoding="UTF-8"?>
            <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>$pa1</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:CodiceContestoPagamento>$1carrello</pay_i:CodiceContestoPagamento>
            <pay_i:datiSingoloPagamento>
            <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
            <pay_i:esitoSingoloPagamento>ACCEPTED</pay_i:esitoSingoloPagamento>
            <pay_i:dataEsitoSingoloPagamento>2012-03-02</pay_i:dataEsitoSingoloPagamento>
            <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
            <pay_i:causaleVersamento>causale RT pull</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
            </pay_i:RT>
            """
        And initial XML nodoInviaCarrelloRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>$1carrello</identificativoCarrello>
            </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaCarrelloRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>

            <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>

            <listaRPT>
            <elementoListaRPT>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            <rpt>$rpt1Attachment</rpt>
            </elementoListaRPT>
            <elementoListaRPT>
            <identificativoDominio>$pa1</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            <rpt>$rpt2Attachment</rpt>
            </elementoListaRPT>
            </listaRPT>
            <requireLightPayment>01</requireLightPayment>
            <multiBeneficiario>1</multiBeneficiario>
            </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
        Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
        And retrieve session token from $nodoInviaCarrelloRPTResponse.url

        And replace pa content with #creditor_institution_code# content
        And execution query get_pa_id to get value on the table PA, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query get_pa_id retrieve param objId at position 0 and save it under the key objId
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition FK_PA = $objId under macro update_query on db nodo_cfg

        And replace pa content with $pa1 content
        And execution query get_pa_id to get value on the table PA, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query get_pa_id retrieve param objId at position 0 and save it under the key objId


        And replace station_id content with 90000000001_06 content

        And execution query by_station_id to get value on the table STAZIONI, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query by_station_id retrieve param stationID at position 0 and save it under the key stationID
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition FK_PA = $objId AND FK_STAZIONE = $stationID under macro update_query on db nodo_cfg

        And replace station_id content with irraggiungibile content
        And replace pa content with $pa1 content
        And execution query by_station_id to get value on the table STAZIONI, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query by_station_id retrieve param stationID at position 0 and save it under the key stationID
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'Y', with where condition FK_PA = $objId AND FK_STAZIONE = $stationID under macro update_query on db nodo_cfg


        And refresh job ALL triggered after 10 seconds
        And wait 5 seconds for expiration

    Scenario: Execute nodoChiediInformazioniPagamento (Phase 2)
        Given the Execute nodoInviaCarrelloRPT (Phase 1) scenario executed successfully
        When WISP sends REST GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of informazioniPagamento response is 200
        And check importo field exists in informazioniPagamento response
        And check email field exists in informazioniPagamento response
        And check ragioneSociale field exists in informazioniPagamento response
        And check oggettoPagamento field exists in informazioniPagamento response
        And check urlRedirectEC field exists in informazioniPagamento response

    Scenario: Execute nodoInoltroEsitoMod1 (Phase 3)
        Given the Execute nodoChiediInformazioniPagamento (Phase 2) scenario executed successfully
        And initial XML pspInviaCarrelloRPT
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
        And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPT
        When WISP sends REST POST inoltroEsito/mod1 to nodo-dei-pagamenti
            """
            {
                "idPagamento": "$sessionToken",
                "identificativoPsp": "#psp#",
                "tipoVersamento": "BP",
                "identificativoIntermediario": "#psp#",
                "identificativoCanale": "#canale#",
                "tipoOperazione": "web"
            }
            """
        Then verify the HTTP status code of inoltroEsito/mod1 response is 200
        And check esito is OK of inoltroEsito/mod1 response

@runnable
    Scenario: Execute nodoInviaRT (Phase 4)
        Given the Execute nodoInoltroEsitoMod1 (Phase 3) scenario executed successfully
        And initial XML nodoInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoInviaRT>
            <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale#</identificativoCanale>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#psp#</identificativoPSP>
            <identificativoDominio>$pa1</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            <tipoFirma></tipoFirma>
            <forzaControlloSegno>1</forzaControlloSegno>
            <rt>$rt2Attachment</rt>
            </ws:nodoInviaRT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response

        And replace noticeNumber content with $1noticeNumber content
        And replace pa content with #creditor_institution_code# content
        And replace psp content with #psp# content
        #extraction from POSITION_RECEIPT table
        And execution query by_notice_number_and_pa to get value on the table POSITION_RECEIPT, with the columns * under macro Mod1Mb with db name nodo_online
        And through the query by_notice_number_and_pa retrieve param receptID at position 1 and save it under the key receptID
        And through the query by_notice_number_and_pa retrieve param noticeID at position 2 and save it under the key noticeID
        And through the query by_notice_number_and_pa retrieve param fiscalCode at position 3 and save it under the key fiscalCode
        And through the query by_notice_number_and_pa retrieve param creditorReferenceId at position 4 and save it under the key creditorReferenceId
        And through the query by_notice_number_and_pa retrieve param paymentToken at position 5 and save it under the key paymentToken
        And through the query by_notice_number_and_pa retrieve param outcome at position 6 and save it under the key outcome
        And through the query by_notice_number_and_pa retrieve param amount at position 7 and save it under the key amount
        And through the query by_notice_number_and_pa retrieve param description at position 8 and save it under the key description
        And through the query by_notice_number_and_pa retrieve param company at position 9 and save it under the key company
        And through the query by_notice_number_and_pa retrieve param officeName at position 10 and save it under the key officeName
        And through the query by_notice_number_and_pa retrieve param debtorID at position 11 and save it under the key debtorID
        And through the query by_notice_number_and_pa retrieve param pspID at position 12 and save it under the key pspID
        And through the query by_notice_number_and_pa retrieve param pspFiscalCode at position 13 and save it under the key pspFiscalCode
        And through the query by_notice_number_and_pa retrieve param pspVatNumber at position 14 and save it under the key pspVatNumber
        And through the query by_notice_number_and_pa retrieve param pspCompany at position 15 and save it under the key pspCompany
        And through the query by_notice_number_and_pa retrieve param channelID at position 16 and save it under the key channelID
        And through the query by_notice_number_and_pa retrieve param channelDescription at position 17 and save it under the key channelDescription
        And through the query by_notice_number_and_pa retrieve param payerID at position 18 and save it under the key payerID
        And through the query by_notice_number_and_pa retrieve param paymentMethod at position 19 and save it under the key paymentMethod
        And through the query by_notice_number_and_pa retrieve param fee at position 20 and save it under the key fee
        And through the query by_notice_number_and_pa retrieve param paymentDatetime at position 21 and save it under the key paymentDateTime
        And through the query by_notice_number_and_pa retrieve param applicationDate at position 22 and save it under the key applicationDate
        And through the query by_notice_number_and_pa retrieve param transferDate at position 23 and save it under the key transferDate
        And through the query by_notice_number_and_pa retrieve param metadata at position 24 and save it under the key metadata
        And through the query by_notice_number_and_pa retrieve param rtID at position 25 and save it under the key rtID
        And through the query by_notice_number_and_pa retrieve param fkPositionPayment at position 26 and save it under the key fkPositionPayment
        #extraction from POSITION_PAYMENT table
        And execution query by_notice_number_and_pa to get value on the table POSITION_PAYMENT, with the columns * under macro Mod1Mb with db name nodo_online
        And through the query by_notice_number_and_pa retrieve param expFiscalCode at position 1 and save it under the key expFiscalCode
        And through the query by_notice_number_and_pa retrieve param expNoticeID at position 2 and save it under the key expNoticeID
        And through the query by_notice_number_and_pa retrieve param expCreditorReferenceID at position 3 and save it under the key expCreditorReferenceID
        And through the query by_notice_number_and_pa retrieve param expPaymentToken at position 4 and save it under the key expPaymentToken
        And through the query by_notice_number_and_pa retrieve param expBrokerPA at position 5 and save it under the key expBrokerPA
        And through the query by_notice_number_and_pa retrieve param expStationID at position 6 and save it under the key expStationID
        And through the query by_notice_number_and_pa retrieve param expChannelID at position 10 and save it under the key expChannelID
        And through the query by_notice_number_and_pa retrieve param expAmount at position 12 and save it under the key expAmount
        And through the query by_notice_number_and_pa retrieve param expFee at position 13 and save it under the key expFee
        And through the query by_notice_number_and_pa retrieve param expOutcome at position 14 and save it under the key expOutcome
        And through the query by_notice_number_and_pa retrieve param expPaymentMethod at position 15 and save it under the key expPaymentMethod
        And through the query by_notice_number_and_pa retrieve param expPaymentChannel at position 16 and save it under the key expPaymentChannel
        And through the query by_notice_number_and_pa retrieve param expTransferDate at position 17 and save it under the key expTransferDate
        And through the query by_notice_number_and_pa retrieve param expPayerID at position 18 and save it under the key expPayerID
        And through the query by_notice_number_and_pa retrieve param expApplicationDate at position 19 and save it under the key expApplicationDate
        #extraction from POSITION_SERVICE table
        And execution query by_notice_number_and_pa to get value on the table POSITION_SERVICE, with the columns * under macro Mod1Mb with db name nodo_online
        And through the query by_notice_number_and_pa retrieve param expDescription at position 3 and save it under the key expDescription
        And through the query by_notice_number_and_pa retrieve param expCompanyName at position 4 and save it under the key expCompanyName
        And through the query by_notice_number_and_pa retrieve param expOfficeName at position 5 and save it under the key expOfficeName
        And through the query by_notice_number_and_pa retrieve param expDebtorID at position 6 and save it under the key expDebtorID
        #extraction from PSP table
        And execution query by_psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, CODICE_FISCALE, VAT_NUMBER under macro Mod1Mb with db name nodo_cfg
        And through the query by_psp retrieve param ragioneSociale at position 0 and save it under the key ragioneSociale
        And through the query by_psp retrieve param codiceFiscale at position 1 and save it under the key codiceFiscale
        And through the query by_psp retrieve param vatNumber at position 2 and save it under the key vatNumber
        #checks
        And check value $receptID is equal to value $1iuv
        And check value $noticeID is equal to value $expNoticeID
        And check value $fiscalCode is equal to value $expFiscalCode
        And check value $creditorReferenceId is equal to value $expCreditorReferenceID
        And check value $paymentToken is equal to value $expPaymentToken
        And check value $outcome is equal to value $expOutcome
        And check value $amount is equal to value $expAmount
        And check value $description is equal to value $expDescription
        And check value $company is equal to value $expCompanyName
        And check value $officeName is equal to value $expOfficeName
        And check value $debtorID is equal to value $expDebtorID
        And check value $pspID is equal to value #psp#
        #And check value $pspCompany is equal to value $ragioneSociale
        And check value $pspFiscalCode is equal to value $codiceFiscale
        And check value $pspVatNumber is equal to value $vatNumber
        And check value $channelID is equal to value $expChannelID
        And check value $channelDescription is equal to value WISP
        And check value $payerID is equal to value $expPayerID
        And check value $paymentMethod is equal to value $expPaymentMethod
        And check value $fee is equal to value $expFee
        And check value $applicationDate is equal to value $expApplicationDate
        And check value $transferDate is equal to value $expTransferDate


        #extraction from POSITION_RECEIPT_RECIPIENT table
        And replace $paymentToken content with $1carrello content
        #row 1
        And execution query by_notice_number_and_payment_token to get value on the table POSITION_RECEIPT_RECIPIENT, with the columns * under macro Mod1Mb with db name nodo_online
        And through the query by_notice_number_and_payment_token retrieve param paFiscalCode1 at position 1 and save it under the key paFiscalCode1
        And through the query by_notice_number_and_payment_token retrieve param noticeID1 at position 2 and save it under the key noticeID1
        And through the query by_notice_number_and_payment_token retrieve param creditorReferenceId1 at position 3 and save it under the key creditorReferenceId1
        And through the query by_notice_number_and_payment_token retrieve param paymentToken1 at position 4 and save it under the key paymentToken1
        And through the query by_notice_number_and_payment_token retrieve param recipientPA1 at position 5 and save it under the key recipientPA1
        And through the query by_notice_number_and_payment_token retrieve param recipientBroker1 at position 6 and save it under the key recipientBroker1
        And through the query by_notice_number_and_payment_token retrieve param recipientStation1 at position 7 and save it under the key recipientStation1
        And through the query by_notice_number_and_payment_token retrieve param status1 at position 8 and save it under the key status1


        #checks
        And check value $paFiscalCode1 is equal to value $expFiscalCode
        And check value $noticeID1 is equal to value $expNoticeID
        And check value $creditorReferenceId1 is equal to value $expCreditorReferenceID
        And check value $paymentToken1 is equal to value $expPaymentToken
        And check value $recipientPA1 is equal to value $pa1
        And check value $recipientBroker1 is equal to value $pa1

        And check value $recipientStation1 is equal to value 90000000001_06

        #extraction from POSITION_RECEIPT_XML
        And execution query by_notice_number_and_payment_token to get value on the table POSITION_RECEIPT_XML, with the columns * under macro Mod1Mb with db name nodo_online
        #row 1
        And through the query by_notice_number_and_payment_token retrieve param paFiscalCode1 at position 1 and save it under the key paFiscalCode1
        And through the query by_notice_number_and_payment_token retrieve param noticeID1 at position 2 and save it under the key noticeID1
        And through the query by_notice_number_and_payment_token retrieve param creditorReferenceId1 at position 3 and save it under the key creditorReferenceId1
        And through the query by_notice_number_and_payment_token retrieve param paymentToken1 at position 4 and save it under the key paymentToken1
        And through the query by_notice_number_and_payment_token retrieve param recipientPA1 at position 8 and save it under the key recipientPA1
        And through the query by_notice_number_and_payment_token retrieve param recipientBroker1 at position 9 and save it under the key recipientBroker1
        And through the query by_notice_number_and_payment_token retrieve param recipientStation1 at position 10 and save it under the key recipientStation1
        # #checks

        And check value $paFiscalCode1 is equal to value $expFiscalCode
        And check value $noticeID1 is equal to value $expNoticeID
        And check value $creditorReferenceId1 is equal to value $expCreditorReferenceID
        And check value $paymentToken1 is equal to value $expPaymentToken
        And check value $recipientPA1 is equal to value $pa1
        And check value $recipientBroker1 is equal to value $pa1

        And check value $recipientStation1 is equal to value 90000000001_06

        And replace pa content with #creditor_institution_code# content
        And execution query get_pa_id to get value on the table PA, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query get_pa_id retrieve param objId at position 0 and save it under the key objId
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition FK_PA = $objId under macro update_query on db nodo_cfg

        And replace pa content with $pa1 content
        And execution query get_pa_id to get value on the table PA, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query get_pa_id retrieve param objId at position 0 and save it under the key objId


        And replace station_id content with 90000000001_06 content

        And execution query by_station_id to get value on the table STAZIONI, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query by_station_id retrieve param stationID at position 0 and save it under the key stationID
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition FK_PA = $objId AND FK_STAZIONE = $stationID under macro update_query on db nodo_cfg

        And replace station_id content with irraggiungibile content
        And replace pa content with $pa1 content
        And execution query by_station_id to get value on the table STAZIONI, with the columns OBJ_ID under macro costanti with db name nodo_cfg
        And through the query by_station_id retrieve param stationID at position 0 and save it under the key stationID
        And generic update through the query param_update_generic_where_condition of the table PA_STAZIONE_PA the parameter BROADCAST = 'N', with where condition FK_PA = $objId AND FK_STAZIONE = $stationID under macro update_query on db nodo_cfg




        And refresh job ALL triggered after 10 seconds
        And wait 5 seconds for expiration
