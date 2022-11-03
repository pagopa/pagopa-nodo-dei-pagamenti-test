Feature: process tests for nodoInviaRT
    Background:
        Given systems up
 
    Scenario: RPT generation
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>66666666666</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>66666666666_01</pay_i:identificativoStazioneRichiedente>
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
                <pay_i:identificativoUnivocoVersamento>#IUV#</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>#ccp1#</pay_i:codiceContestoPagamento>
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

    Scenario: RT generation
        Given the RPT generation scenario executed successfully
        And RT generation
            """
            <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>66666666666</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>66666666666_01</pay_i:identificativoStazioneRichiedente>
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
                <pay_i:CodiceContestoPagamento>$1ccp</pay_i:CodiceContestoPagamento>
                <pay_i:datiSingoloPagamento>
                    <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
                    <pay_i:esitoSingoloPagamento>ACCEPTED</pay_i:esitoSingoloPagamento>
                    <pay_i:dataEsitoSingoloPagamento>2001-01-01</pay_i:dataEsitoSingoloPagamento>
                    <pay_i:identificativoUnivocoRiscossione>$IUV</pay_i:identificativoUnivocoRiscossione>
                    <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
                    <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
                </pay_i:datiSingoloPagamento>
            </pay_i:datiPagamento>
            </pay_i:RT>
            """

    Scenario: RR generation
        Given the RT generation scenario executed successfully
        And RR generation 
            """
            <pay_i:RR xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/Revoche/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/Revoche/ RR_ER_6_0_1.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>66666666666</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>66666666666_01</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioRevoca>1</pay_i:identificativoMessaggioRevoca>
            <pay_i:dataOraMessaggioRevoca>#timedate#</pay_i:dataOraMessaggioRevoca>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoMittente>
                    <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>IDPSPFNZ</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoMittente>
                <pay_i:denominazioneMittente>DenominazioneAttestante</pay_i:denominazioneMittente>
                <pay_i:codiceUnitOperMittente>CodiceUnitOperAttestante</pay_i:codiceUnitOperMittente>
                <pay_i:denomUnitOperMittente>DenomUnitOperAttestante</pay_i:denomUnitOperMittente>
                <pay_i:indirizzoMittente>IndirizzoAttestante</pay_i:indirizzoMittente>
                <pay_i:civicoMittente>11</pay_i:civicoMittente>
                <pay_i:capMittente>11111</pay_i:capMittente>
                <pay_i:localitaMittente>LocalitaAttestante</pay_i:localitaMittente>
                <pay_i:provinciaMittente>ProvinciaAttestante</pay_i:provinciaMittente>
                <pay_i:nazioneMittente>IT</pay_i:nazioneMittente>
            </pay_i:istitutoAttestante>
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
            <pay_i:datiRevoca>
                <pay_i:importoTotaleRevocato>10.00</pay_i:importoTotaleRevocato>
                <pay_i:identificativoUnivocoVersamento>$IUV</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>$1ccp</pay_i:codiceContestoPagamento>
                <pay_i:tipoRevoca>1</pay_i:tipoRevoca>
                <pay_i:datiSingolaRevoca>
                    <pay_i:singoloImportoRevocato>10.00</pay_i:singoloImportoRevocato>
                    <pay_i:identificativoUnivocoRiscossione>$IUV</pay_i:identificativoUnivocoRiscossione>
                    <pay_i:causaleRevoca>revoca fotocopie pratica</pay_i:causaleRevoca>
                    <pay_i:datiAggiuntiviRevoca>datiAggiuntiviRevoca</pay_i:datiAggiuntiviRevoca>
                </pay_i:datiSingolaRevoca>
            </pay_i:datiRevoca>
            </pay_i:RR>
            """
         
  # controllare <pay_i:identificativoUnivocoRiscossione>idRiscossioneRR</pay_i:identificativoUnivocoRiscossione> con Mascia
    Scenario: ER generation
        Given the RR generation scenario executed successfully
        And ER generation
            """
            <pay_i:ER xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/Revoche/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/Revoche/ RR_ER_6_0_1.xsd ">
            <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
            <pay_i:dominio>
                <pay_i:identificativoDominio>66666666666</pay_i:identificativoDominio>
                <pay_i:identificativoStazioneRichiedente>66666666666_01</pay_i:identificativoStazioneRichiedente>
            </pay_i:dominio>
            <pay_i:identificativoMessaggioEsito>1</pay_i:identificativoMessaggioEsito>
            <pay_i:dataOraMessaggioEsito>#timedate#</pay_i:dataOraMessaggioEsito>
            <pay_i:riferimentoMessaggioRevoca>1</pay_i:riferimentoMessaggioRevoca>
            <pay_i:riferimentoDataRevoca>2017-09-12</pay_i:riferimentoDataRevoca>
            <pay_i:istitutoAttestante>
                <pay_i:identificativoUnivocoMittente>
                    <pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco>
                    <pay_i:codiceIdentificativoUnivoco>IDPSPFNZ</pay_i:codiceIdentificativoUnivoco>
                </pay_i:identificativoUnivocoMittente>
                <pay_i:denominazioneMittente>DenominazioneAttestante</pay_i:denominazioneMittente>
                <pay_i:codiceUnitOperMittente>CodiceUnitOperAttestante</pay_i:codiceUnitOperMittente>
                <pay_i:denomUnitOperMittente>DenomUnitOperAttestante</pay_i:denomUnitOperMittente>
                <pay_i:indirizzoMittente>IndirizzoAttestante</pay_i:indirizzoMittente>
                <pay_i:civicoMittente>11</pay_i:civicoMittente>
                <pay_i:capMittente>11111</pay_i:capMittente>
                <pay_i:localitaMittente>LocalitaAttestante</pay_i:localitaMittente>
                <pay_i:provinciaMittente>ProvinciaAttestante</pay_i:provinciaMittente>
                <pay_i:nazioneMittente>IT</pay_i:nazioneMittente>
            </pay_i:istitutoAttestante>
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
            <pay_i:datiRevoca>
                <pay_i:importoTotaleRevocato>10.00</pay_i:importoTotaleRevocato>
                <pay_i:identificativoUnivocoVersamento>$IUV</pay_i:identificativoUnivocoVersamento>
                <pay_i:codiceContestoPagamento>$1ccp</pay_i:codiceContestoPagamento>
                <pay_i:datiSingolaRevoca>
                    <pay_i:singoloImportoRevocato>10.00</pay_i:singoloImportoRevocato>
                    <pay_i:identificativoUnivocoRiscossione>$IUV</pay_i:identificativoUnivocoRiscossione>
                    <pay_i:causaleEsito>esito revoca fotocopie pratica</pay_i:causaleEsito>
                    <pay_i:datiAggiuntiviEsito>datiAggiuntiviEsito</pay_i:datiAggiuntiviEsito>
                </pay_i:datiSingolaRevoca>
            </pay_i:datiRevoca>
            </pay_i:ER>
            """

    Scenario: Execute nodoInviaRPT request
        Given the ER generation scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoPSP>60000000001</identificativoPSP>
            <identificativoIntermediarioPSP>60000000001</identificativoIntermediarioPSP>
            <identificativoCanale>60000000001_07</identificativoCanale>
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
        And check redirect is 1 of nodoInviaRPT response

    Scenario: Execute nodoInviaRT request
        Given the Execute nodoInviaRPT request scenario executed successfully
        And initial XML nodoInviaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoInviaRT>
                    <identificativoIntermediarioPSP>60000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>60000000001_07</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <identificativoPSP>60000000001</identificativoPSP>
                    <identificativoDominio>66666666666</identificativoDominio>
                    <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
                    <tipoFirma></tipoFirma>
                    <forzaControlloSegno>1</forzaControlloSegno>
                    <rt>$rtAttachment</rt>
                </ws:nodoInviaRT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRT response

 
    Scenario: Execute nodoInviaRR request
        Given the Execute nodoInviaRT request scenario executed successfully
        And initial XML nodoInviaRichiestaRevoca
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoInviaRichiestaRevoca>
                    <identificativoPSP>60000000001</identificativoPSP>
                    <identificativoIntermediarioPSP>60000000001</identificativoIntermediarioPSP>
                    <identificativoCanale>60000000001_07</identificativoCanale>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>66666666666</identificativoDominio>
                    <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
                    <rr>$rrAttachment</rr>
                </ws:nodoInviaRichiestaRevoca>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRichiestaRevoca to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRichiestaRevoca response

@runnable
    Scenario: Execute nodoInviaER request
        Given the Execute nodoInviaRR request scenario executed successfully
        And initial XML nodoInviaRispostaRevoca
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
                <ws:nodoInviaRispostaRevoca>
                    <identificativoIntermediarioPA>66666666666</identificativoIntermediarioPA>
                    <identificativoStazioneIntermediarioPA>66666666666_01</identificativoStazioneIntermediarioPA>
                    <password>pwdpwdpwd</password>
                    <identificativoDominio>66666666666</identificativoDominio>
                    <identificativoUnivocoVersamento>$IUV</identificativoUnivocoVersamento>
                    <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
                    <er>$erAttachment</er>
                </ws:nodoInviaRispostaRevoca>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRispostaRevoca to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRispostaRevoca response

    