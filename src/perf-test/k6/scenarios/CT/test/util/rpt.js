import encoding from 'k6/encoding';

export function getRpt(p1,p2,p3,p4,p5,p6,importoTotaleDaVersare) {
   
return `<pay_i:RPT xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd " xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 	<pay_i:versioneOggetto>1.0</pay_i:versioneOggetto> 	<pay_i:dominio> 		<pay_i:identificativoDominio>${p1}</pay_i:identificativoDominio> 		<pay_i:identificativoStazioneRichiedente>${p2}</pay_i:identificativoStazioneRichiedente> 	</pay_i:dominio> 	<pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta> 	<pay_i:dataOraMessaggioRichiesta>${p3}</pay_i:dataOraMessaggioRichiesta> 	<pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto> 	<pay_i:soggettoVersante> 		<pay_i:identificativoUnivocoVersante> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoVersante> 		<pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante> 		<pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante> 		<pay_i:civicoVersante>11</pay_i:civicoVersante> 		<pay_i:capVersante>00186</pay_i:capVersante> 		<pay_i:localitaVersante>Roma</pay_i:localitaVersante> 		<pay_i:provinciaVersante>RM</pay_i:provinciaVersante> 		<pay_i:nazioneVersante>IT</pay_i:nazioneVersante> 		<pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante> 	</pay_i:soggettoVersante> 	<pay_i:soggettoPagatore> 		<pay_i:identificativoUnivocoPagatore> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoPagatore> 		<pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore> 		<pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore> 		<pay_i:civicoPagatore>11</pay_i:civicoPagatore> 		<pay_i:capPagatore>00186</pay_i:capPagatore> 		<pay_i:localitaPagatore>Roma</pay_i:localitaPagatore> 		<pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore> 		<pay_i:nazionePagatore>IT</pay_i:nazionePagatore> 		<pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore> 	</pay_i:soggettoPagatore> 	<pay_i:enteBeneficiario> 		<pay_i:identificativoUnivocoBeneficiario> 			<pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoBeneficiario> 		<pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario> 		<pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario> 		<pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario> 		<pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario> 		<pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario> 		<pay_i:capBeneficiario>22222</pay_i:capBeneficiario> 		<pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario> 		<pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario> 		<pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario> 	</pay_i:enteBeneficiario> 	<pay_i:datiVersamento> 		<pay_i:dataEsecuzionePagamento>${p4}</pay_i:dataEsecuzionePagamento> 		<pay_i:importoTotaleDaVersare>${importoTotaleDaVersare}</pay_i:importoTotaleDaVersare> 		<pay_i:tipoVersamento>PO</pay_i:tipoVersamento> 		<pay_i:identificativoUnivocoVersamento>${p5}</pay_i:identificativoUnivocoVersamento> 		<pay_i:codiceContestoPagamento>${p6}</pay_i:codiceContestoPagamento> 		<pay_i:ibanAddebito>IT00R0000000000000000000000</pay_i:ibanAddebito> 		<pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito> 		<pay_i:firmaRicevuta>0</pay_i:firmaRicevuta> 		<pay_i:datiSingoloVersamento> 			<pay_i:importoSingoloVersamento>${importoTotaleDaVersare}</pay_i:importoSingoloVersamento> 			<pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA> 			<pay_i:ibanAccredito>IT00R0000000000000000000000</pay_i:ibanAccredito> 			<pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito> 			<pay_i:ibanAppoggio>IT00R0000000000000000000000</pay_i:ibanAppoggio> 			<pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio> 			<pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore> 			<pay_i:causaleVersamento>Stress Test RPT</pay_i:causaleVersamento> 			<pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione> 		</pay_i:datiSingoloVersamento> 	</pay_i:datiVersamento> </pay_i:RPT>`;

    
}

export function getRptC(p1,p2,p3,p4,p5,p6) {
   
return `<pay_i:RPT xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd " xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 	<pay_i:versioneOggetto>1.0</pay_i:versioneOggetto> 	<pay_i:dominio> 		<pay_i:identificativoDominio>${p1}</pay_i:identificativoDominio> 		<pay_i:identificativoStazioneRichiedente>${p2}</pay_i:identificativoStazioneRichiedente> 	</pay_i:dominio> 	<pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta> 	<pay_i:dataOraMessaggioRichiesta>${p3}</pay_i:dataOraMessaggioRichiesta> 	<pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto> 	<pay_i:soggettoVersante> 		<pay_i:identificativoUnivocoVersante> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoVersante> 		<pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante> 		<pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante> 		<pay_i:civicoVersante>11</pay_i:civicoVersante> 		<pay_i:capVersante>00186</pay_i:capVersante> 		<pay_i:localitaVersante>Roma</pay_i:localitaVersante> 		<pay_i:provinciaVersante>RM</pay_i:provinciaVersante> 		<pay_i:nazioneVersante>IT</pay_i:nazioneVersante> 		<pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante> 	</pay_i:soggettoVersante> 	<pay_i:soggettoPagatore> 		<pay_i:identificativoUnivocoPagatore> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoPagatore> 		<pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore> 		<pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore> 		<pay_i:civicoPagatore>11</pay_i:civicoPagatore> 		<pay_i:capPagatore>00186</pay_i:capPagatore> 		<pay_i:localitaPagatore>Roma</pay_i:localitaPagatore> 		<pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore> 		<pay_i:nazionePagatore>IT</pay_i:nazionePagatore> 		<pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore> 	</pay_i:soggettoPagatore> 	<pay_i:enteBeneficiario> 		<pay_i:identificativoUnivocoBeneficiario> 			<pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoBeneficiario> 		<pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario> 		<pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario> 		<pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario> 		<pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario> 		<pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario> 		<pay_i:capBeneficiario>22222</pay_i:capBeneficiario> 		<pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario> 		<pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario> 		<pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario> 	</pay_i:enteBeneficiario> 	<pay_i:datiVersamento> 		<pay_i:dataEsecuzionePagamento>${p4}</pay_i:dataEsecuzionePagamento> 		<pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare> 		<pay_i:tipoVersamento>CP</pay_i:tipoVersamento> 		<pay_i:identificativoUnivocoVersamento>${p5}</pay_i:identificativoUnivocoVersamento> 		<pay_i:codiceContestoPagamento>${p6}</pay_i:codiceContestoPagamento> 		<pay_i:ibanAddebito>IT00R0000000000000000000000</pay_i:ibanAddebito> 		<pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito> 		<pay_i:firmaRicevuta>0</pay_i:firmaRicevuta> 		<pay_i:datiSingoloVersamento> 			<pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento> 			<pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA> 			<pay_i:ibanAccredito>IT00R0000000000000000000000</pay_i:ibanAccredito> 			<pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito> 			<pay_i:ibanAppoggio>IT00R0000000000000000000000</pay_i:ibanAppoggio> 			<pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio> 			<pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore> 			<pay_i:causaleVersamento>Stress Test RPT</pay_i:causaleVersamento> 			<pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione> 		</pay_i:datiSingoloVersamento> 	</pay_i:datiVersamento> </pay_i:RPT>`;

    
}

export function getRptBBT(p1,p2,p3,p4,p5,p6) {
   
return `<pay_i:RPT xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd " xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"> 	<pay_i:versioneOggetto>1.0</pay_i:versioneOggetto> 	<pay_i:dominio> 		<pay_i:identificativoDominio>${p1}</pay_i:identificativoDominio> 		<pay_i:identificativoStazioneRichiedente>${p2}</pay_i:identificativoStazioneRichiedente> 	</pay_i:dominio> 	<pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta> 	<pay_i:dataOraMessaggioRichiesta>${p3}</pay_i:dataOraMessaggioRichiesta> 	<pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto> 	<pay_i:soggettoVersante> 		<pay_i:identificativoUnivocoVersante> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoVersante> 		<pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante> 		<pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante> 		<pay_i:civicoVersante>11</pay_i:civicoVersante> 		<pay_i:capVersante>00186</pay_i:capVersante> 		<pay_i:localitaVersante>Roma</pay_i:localitaVersante> 		<pay_i:provinciaVersante>RM</pay_i:provinciaVersante> 		<pay_i:nazioneVersante>IT</pay_i:nazioneVersante> 		<pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante> 	</pay_i:soggettoVersante> 	<pay_i:soggettoPagatore> 		<pay_i:identificativoUnivocoPagatore> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoPagatore> 		<pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore> 		<pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore> 		<pay_i:civicoPagatore>11</pay_i:civicoPagatore> 		<pay_i:capPagatore>00186</pay_i:capPagatore> 		<pay_i:localitaPagatore>Roma</pay_i:localitaPagatore> 		<pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore> 		<pay_i:nazionePagatore>IT</pay_i:nazionePagatore> 		<pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore> 	</pay_i:soggettoPagatore> 	<pay_i:enteBeneficiario> 		<pay_i:identificativoUnivocoBeneficiario> 			<pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoBeneficiario> 		<pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario> 		<pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario> 		<pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario> 		<pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario> 		<pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario> 		<pay_i:capBeneficiario>22222</pay_i:capBeneficiario> 		<pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario> 		<pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario> 		<pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario> 	</pay_i:enteBeneficiario> 	<pay_i:datiVersamento> 		<pay_i:dataEsecuzionePagamento>${p4}</pay_i:dataEsecuzionePagamento> 		<pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare> 		<pay_i:tipoVersamento>BBT</pay_i:tipoVersamento> 		<pay_i:identificativoUnivocoVersamento>${p5}</pay_i:identificativoUnivocoVersamento> 		<pay_i:codiceContestoPagamento>${p6}</pay_i:codiceContestoPagamento> 		<pay_i:ibanAddebito>IT00R0000000000000000000000</pay_i:ibanAddebito> 		<pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito> 		<pay_i:firmaRicevuta>0</pay_i:firmaRicevuta> 		<pay_i:datiSingoloVersamento> 			<pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento> 			<pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA> 			<pay_i:ibanAccredito>IT00R0000000000000000000000</pay_i:ibanAccredito> 			<pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito> 			<pay_i:ibanAppoggio>IT00R0000000000000000000000</pay_i:ibanAppoggio> 			<pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio> 			<pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore> 			<pay_i:causaleVersamento>Stress Test RPT</pay_i:causaleVersamento> 			<pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione> 		</pay_i:datiSingoloVersamento> 	</pay_i:datiVersamento> </pay_i:RPT>`;

    
}

export function getRt(p1,p2,p3,p4,p5,p6) {
   
return `<?xml version="1.0" encoding="UTF-8"?> <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd "> 	<pay_i:versioneOggetto>6.0</pay_i:versioneOggetto> 	<pay_i:dominio> 		<pay_i:identificativoDominio>${p1}</pay_i:identificativoDominio> 	</pay_i:dominio> 	<pay_i:identificativoMessaggioRicevuta>IdentificativoMessaggioRicevuta</pay_i:identificativoMessaggioRicevuta> 	<pay_i:dataOraMessaggioRicevuta>${p2}</pay_i:dataOraMessaggioRicevuta> 	<pay_i:riferimentoMessaggioRichiesta>RiferimentoMessaggioRichiesta</pay_i:riferimentoMessaggioRichiesta> 	<pay_i:riferimentoDataRichiesta>${p3}</pay_i:riferimentoDataRichiesta> 	<pay_i:istitutoAttestante> 		<pay_i:identificativoUnivocoAttestante> 			<pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>IDPSPFNZ</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoAttestante> 		<pay_i:denominazioneAttestante>DenominazioneAttestante</pay_i:denominazioneAttestante> 		<pay_i:codiceUnitOperAttestante>CodiceUnitOperAttestante</pay_i:codiceUnitOperAttestante> 		<pay_i:denomUnitOperAttestante>DenomUnitOperAttestante</pay_i:denomUnitOperAttestante> 		<pay_i:indirizzoAttestante>IndirizzoAttestante</pay_i:indirizzoAttestante> 		<pay_i:civicoAttestante>11</pay_i:civicoAttestante> 		<pay_i:capAttestante>11111</pay_i:capAttestante> 		<pay_i:localitaAttestante>LocalitaAttestante</pay_i:localitaAttestante> 		<pay_i:provinciaAttestante>ProvinciaAttestante</pay_i:provinciaAttestante> 		<pay_i:nazioneAttestante>IT</pay_i:nazioneAttestante> 	</pay_i:istitutoAttestante> 	<pay_i:enteBeneficiario> 		<pay_i:identificativoUnivocoBeneficiario> 			<pay_i:tipoIdentificativoUnivoco>G</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>11111111117</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoBeneficiario> 		<pay_i:denominazioneBeneficiario>AZIENDA XXX</pay_i:denominazioneBeneficiario> 		<pay_i:codiceUnitOperBeneficiario>123</pay_i:codiceUnitOperBeneficiario> 		<pay_i:denomUnitOperBeneficiario>XXX</pay_i:denomUnitOperBeneficiario> 		<pay_i:indirizzoBeneficiario>IndirizzoBeneficiario</pay_i:indirizzoBeneficiario> 		<pay_i:civicoBeneficiario>123</pay_i:civicoBeneficiario> 		<pay_i:capBeneficiario>22222</pay_i:capBeneficiario> 		<pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario> 		<pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario> 		<pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario> 	</pay_i:enteBeneficiario> 	<pay_i:soggettoVersante> 		<pay_i:identificativoUnivocoVersante> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H502E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoVersante> 		<pay_i:anagraficaVersante>Gesualdo;Riccitelli</pay_i:anagraficaVersante> 		<pay_i:indirizzoVersante>via del gesu</pay_i:indirizzoVersante> 		<pay_i:civicoVersante>11</pay_i:civicoVersante> 		<pay_i:capVersante>00186</pay_i:capVersante> 		<pay_i:localitaVersante>Roma</pay_i:localitaVersante> 		<pay_i:provinciaVersante>RM</pay_i:provinciaVersante> 		<pay_i:nazioneVersante>IT</pay_i:nazioneVersante> 		<pay_i:e-mailVersante>gesualdo.riccitelli@poste.it</pay_i:e-mailVersante> 	</pay_i:soggettoVersante> 	<pay_i:soggettoPagatore> 		<pay_i:identificativoUnivocoPagatore> 			<pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco> 			<pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco> 		</pay_i:identificativoUnivocoPagatore> 		<pay_i:anagraficaPagatore>Gesualdo;Riccitelli</pay_i:anagraficaPagatore> 		<pay_i:indirizzoPagatore>via del gesu</pay_i:indirizzoPagatore> 		<pay_i:civicoPagatore>11</pay_i:civicoPagatore> 		<pay_i:capPagatore>00186</pay_i:capPagatore> 		<pay_i:localitaPagatore>Roma</pay_i:localitaPagatore> 		<pay_i:provinciaPagatore>RM</pay_i:provinciaPagatore> 		<pay_i:nazionePagatore>IT</pay_i:nazionePagatore> 		<pay_i:e-mailPagatore>gesualdo.riccitelli@poste.it</pay_i:e-mailPagatore> 	</pay_i:soggettoPagatore> 	<pay_i:datiPagamento> 		<pay_i:codiceEsitoPagamento>${p4}</pay_i:codiceEsitoPagamento> 		<pay_i:importoTotalePagato>10.00</pay_i:importoTotalePagato> 		<pay_i:identificativoUnivocoVersamento>${p5}</pay_i:identificativoUnivocoVersamento> 		<pay_i:CodiceContestoPagamento>${p6}</pay_i:CodiceContestoPagamento> 		<pay_i:datiSingoloPagamento> 			<pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato> 			<pay_i:esitoSingoloPagamento>REJECT</pay_i:esitoSingoloPagamento> 			<pay_i:dataEsitoSingoloPagamento>2001-01-01</pay_i:dataEsitoSingoloPagamento> 			<pay_i:identificativoUnivocoRiscossione>IRPTRES05_01</pay_i:identificativoUnivocoRiscossione> 			<pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento> 			<pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione> 			<pay_i:commissioniApplicatePSP>0.12</pay_i:commissioniApplicatePSP> 		</pay_i:datiSingoloPagamento> 	</pay_i:datiPagamento> </pay_i:RT>`;

    
}



export function getRptEncoded(pa, stazpa, creditorRefId, paymentToken, importoTotaleDaVersare){
	
	const today = new Date();
    let ms = today.getMilliseconds();
	
	var d = new Date(today),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    var nowDate = [year, month, day].join('-');
	//console.debug(nowDate);
	//var nowDate = today.format("YYYY-MM-dd");

    var nowMilliseconds =  new Date(today.getTime())
                    .toISOString()
                    //.split("T")[0];

    //console.debug("nowMilliseconds==="+nowMilliseconds);
	if(importoTotaleDaVersare == undefined || importoTotaleDaVersare == ''){
		importoTotaleDaVersare = "10.00";
	}	
	let rptXml = getRpt(pa,stazpa,nowMilliseconds,nowDate,creditorRefId,paymentToken, importoTotaleDaVersare);
	//console.debug(rptXml);
	
    let rptEncoded= encoding.b64encode(rptXml);
	//let rptEncoded=encode(getBytes(rptXml));
	//console.debug("RPT____="+pa+" "+stazpa+" "+nowMilliseconds+" "+nowDate+" "+creditorRefId+" "+paymentToken);
	
	//console.debug(rptEncoded);
	return rptEncoded;
}

export function getRptBBTEncoded(pa, stazpa, iuv){
	
	const today = new Date();
    let ms = today.getMilliseconds();
	
	var d = new Date(today),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    var nowDate = [year, month, day].join('-');
	//console.debug(nowDate);
	
    var nowMilliseconds =  new Date(today.getTime())
                    .toISOString();
     
	
	let rptXml = getRptBBT(pa,stazpa,nowMilliseconds,nowDate,iuv,"PERFORMANCE");
	//console.debug(rptXml);
	
    let rptEncoded= encoding.b64encode(rptXml);
	//console.debug("RPT____="+pa+" "+stazpa+" "+nowMilliseconds+" "+nowDate+" "+iuv);
	//console.debug(rptEncoded);
	return rptEncoded;
}

export function getRptCEncoded(pa, stazpa, iuv){
	
	const today = new Date();
    let ms = today.getMilliseconds();
	
	var d = new Date(today),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    var nowDate = [year, month, day].join('-');
	//console.debug(nowDate);
	
    var nowMilliseconds =  new Date(today.getTime())
                    .toISOString();
     
	
	let rptXml = getRptC(pa,stazpa,nowMilliseconds,nowDate,iuv,"PERFORMANCE");
	//console.debug(rptXml);
	
    let rptEncoded= encoding.b64encode(rptXml);
	//console.debug("RPT____="+pa+" "+stazpa+" "+nowMilliseconds+" "+nowDate+" "+iuv);
	//console.debug(rptEncoded);
	return rptEncoded;
}


export function getRtEncoded(pa, iuv){
	
	const today = new Date();
    let ms = today.getMilliseconds();
	
	var d = new Date(today),
        month = '' + (d.getMonth() + 1),
        day = '' + d.getDate(),
        year = d.getFullYear();

    if (month.length < 2) 
        month = '0' + month;
    if (day.length < 2) 
        day = '0' + day;

    var nowDate = [year, month, day].join('-');
	//console.debug(nowDate);
	
    var nowMilliseconds =  new Date(today.getTime())
                    .toISOString();
     
	
	let rtXml = getRt(pa,nowMilliseconds,nowDate,"0",iuv,"PERFORMANCE");
	//console.debug(rptXml);
	
    let rtEncoded= encoding.b64encode(rtXml);
	
	return rtEncoded;
}


	