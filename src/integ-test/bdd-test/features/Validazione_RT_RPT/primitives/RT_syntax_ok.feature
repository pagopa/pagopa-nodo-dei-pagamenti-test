Feature: Syntax checks for RT - OK

  Background:
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And RPT generation
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
      <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
      <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
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
    And initial XML nodoInviaRPT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
      <ppt:intestazionePPT>
      <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
      <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
      <identificativoDominio>#creditor_institution_code#</identificativoDominio>
      <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
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
      <identificativoCarrello>$1iuv</identificativoCarrello>
      <parametriPagamentoImmediato>$1iuv</parametriPagamentoImmediato>
      </pspInviaRPTResponse>
      </ws:pspInviaRPTResponse>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And psp replies to nodo-dei-pagamenti with the pspInviaRPT

  @runnable
  Scenario Outline: Check faultCode PPT_SINTASSI_XSD error on invalid RT tag
    Given initial xml RT
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
      <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
      <pay_i:dominio>
      <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
      <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
      </pay_i:dominio>
      <pay_i:identificativoMessaggioRicevuta>IdentificativoMessaggioRicevuta</pay_i:identificativoMessaggioRicevuta>
      <pay_i:dataOraMessaggioRicevuta>2001-12-31T12:00:00</pay_i:dataOraMessaggioRicevuta>
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
      <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
      <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
      <pay_i:datiSingoloPagamento>
      <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
      <pay_i:esitoSingoloPagamento>TUTTO_OK</pay_i:esitoSingoloPagamento>
      <pay_i:dataEsitoSingoloPagamento>2001-01-01</pay_i:dataEsitoSingoloPagamento>
      <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
      <pay_i:causaleVersamento>pagamento fotocopie pratica RT</pay_i:causaleVersamento>
      <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
      <pay_i:commissioniApplicatePSP>0.12</pay_i:commissioniApplicatePSP>
      </pay_i:datiSingoloPagamento>
      </pay_i:datiPagamento>
      </pay_i:RT>
      """
    And <tag> with <tag_value> in RT
    And RT generation
      """
      $RT
      """
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
      <identificativoDominio>#creditor_institution_code#</identificativoDominio>
      <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
      <codiceContestoPagamento>CCD01</codiceContestoPagamento>
      <tipoFirma></tipoFirma>
      <forzaControlloSegno>1</forzaControlloSegno>
      <rt>$rtAttachment</rt>
      </ws:nodoInviaRT>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRT response
    Examples:
      | SoapUI     | tag                                     | tag_value |
      | RTSIN8.1   | pay_i:identificativoStazioneRichiedente | None      |
      | RTSIN38.1  | pay_i:codiceUnitOperAttestante          | None      |
      | RTSIN40.1  | pay_i:denomUnitOperAttestante           | None      |
      | RTSIN42.1  | pay_i:indirizzoAttestante               | None      |
      | RTSIN44.1  | pay_i:civicoAttestante                  | None      |
      | RTSIN46.1  | pay_i:capAttestante                     | None      |
      | RTSIN48.1  | pay_i:localitaAttestante                | None      |
      | RTSIN50.1  | pay_i:provinciaAttestante               | None      |
      | RTSIN52.1  | pay_i:nazioneAttestante                 | None      |
      | RTSIN70.1  | pay_i:codiceUnitOperBeneficiario        | None      |
      | RTSIN72.1  | pay_i:denomUnitOperBeneficiario         | None      |
      | RTSIN74.1  | pay_i:indirizzoBeneficiario             | None      |
      | RTSIN76.1  | pay_i:civicoBeneficiario                | None      |
      | RTSIN78.1  | pay_i:capBeneficiario                   | None      |
      | RTSIN80.1  | pay_i:localitaBeneficiario              | None      |
      | RTSIN82.1  | pay_i:provinciaBeneficiario             | None      |
      | RTSIN84.1  | pay_i:nazioneBeneficiario               | None      |
      | RTSIN86.1  | pay_i:soggettoVersante                  | None      |
      | RTSIN99.1  | pay_i:indirizzoVersante                 | None      |
      | RTSIN101.1 | pay_i:civicoVersante                    | None      |
      | RTSIN103.1 | pay_i:capVersante                       | None      |
      | RTSIN105.1 | pay_i:localitaVersante                  | None      |
      | RTSIN107.1 | pay_i:provinciaVersante                 | None      |
      | RTSIN109.1 | pay_i:nazioneVersante                   | None      |
      | RTSIN111.1 | pay_i:e-mailVersante                    | None      |
      | RTSIN128.1 | pay_i:indirizzoPagatore                 | None      |
      | RTSIN130.1 | pay_i:civicoPagatore                    | None      |
      | RTSIN132.1 | pay_i:capPagatore                       | None      |
      | RTSIN134.1 | pay_i:localitaPagatore                  | None      |
      | RTSIN136.1 | pay_i:provinciaPagatore                 | None      |
      | RTSIN138.1 | pay_i:nazionePagatore                   | None      |
      | RTSIN140.1 | pay_i:e-mailPagatore                    | None      |
      | RTSIN169.1 | pay_i:esitoSingoloPagamento             | None      |
# | RTSIN190.1| pay_i:allegatoRicevuta                   | None       |
