Feature: Syntax checks for RT - KO

  Background:
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And RPT generation
      """
      <?xml version="1.0" encoding="UTF-8"?>
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

  @midCheck
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
    Then check esito is KO of nodoInviaRT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response
    Examples:
      | SoapUI   | tag                                     | tag_value                                                                                                                                                                                                                                                 |
      | RTSIN1   | pay_i:versioneOggetto                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN2   | pay_i:versioneOggetto                   | None                                                                                                                                                                                                                                                      |
      | RTSIN3   | pay_i:versioneOggetto                   | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN4   | pay_i:dominio                           | None                                                                                                                                                                                                                                                      |
      | RTSIN5   | pay_i:identificativoDominio             | None                                                                                                                                                                                                                                                      |
      | RTSIN6   | pay_i:identificativoDominio             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN7   | pay_i:identificativoDominio             | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN8   | pay_i:identificativoStazioneRichiedente | Empty                                                                                                                                                                                                                                                     |
      | RTSIN9   | pay_i:identificativoStazioneRichiedente | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN10  | pay_i:identificativoMessaggioRicevuta   | None                                                                                                                                                                                                                                                      |
      | RTSIN11  | pay_i:identificativoMessaggioRicevuta   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN12  | pay_i:identificativoMessaggioRicevuta   | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN13  | pay_i:dataOraMessaggioRicevuta          | None                                                                                                                                                                                                                                                      |
      | RTSIN14  | pay_i:dataOraMessaggioRicevuta          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN15  | pay_i:dataOraMessaggioRicevuta          | 2001-12-31T12:00:00:0001                                                                                                                                                                                                                                  |
      | RTSIN16  | pay_i:dataOraMessaggioRicevuta          | 2001-12-31T12:00                                                                                                                                                                                                                                          |
      | RTSIN17  | pay_i:dataOraMessaggioRicevuta          | 31-12-2001T12:00:00                                                                                                                                                                                                                                       |
      | RTSIN18  | pay_i:riferimentoMessaggioRichiesta     | None                                                                                                                                                                                                                                                      |
      | RTSIN19  | pay_i:riferimentoMessaggioRichiesta     | Empty                                                                                                                                                                                                                                                     |
      | RTSIN20  | pay_i:riferimentoMessaggioRichiesta     | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN21  | pay_i:riferimentoDataRichiesta          | None                                                                                                                                                                                                                                                      |
      | RTSIN22  | pay_i:riferimentoDataRichiesta          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN23  | pay_i:riferimentoDataRichiesta          | 2001-12-31T12                                                                                                                                                                                                                                             |
      | RTSIN24  | pay_i:riferimentoDataRichiesta          | 12-31                                                                                                                                                                                                                                                     |
      | RTSIN25  | pay_i:riferimentoDataRichiesta          | 20011231                                                                                                                                                                                                                                                  |
      | RTSIN26  | pay_i:istitutoAttestante                | None                                                                                                                                                                                                                                                      |
      | RTSIN27  | pay_i:identificativoUnivocoAttestante   | None                                                                                                                                                                                                                                                      |
      | RTSIN29  | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN30  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN31  | pay_i:tipoIdentificativoUnivoco         | C                                                                                                                                                                                                                                                         |
      | RTSIN32  | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN33  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN34  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN35  | pay_i:denominazioneAttestante           | None                                                                                                                                                                                                                                                      |
      | RTSIN36  | pay_i:denominazioneAttestante           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN37  | pay_i:denominazioneAttestante           | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN38  | pay_i:codiceUnitOperAttestante          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN39  | pay_i:codiceUnitOperAttestante          | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN40  | pay_i:denomUnitOperAttestante           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN41  | pay_i:denomUnitOperAttestante           | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN42  | pay_i:indirizzoAttestante               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN43  | pay_i:indirizzoAttestante               | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN44  | pay_i:civicoAttestante                  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN45  | pay_i:civicoAttestante                  | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN46  | pay_i:capAttestante                     | Empty                                                                                                                                                                                                                                                     |
      | RTSIN47  | pay_i:capAttestante                     | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN48  | pay_i:localitaAttestante                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN49  | pay_i:localitaAttestante                | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN50  | pay_i:provinciaAttestante               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN51  | pay_i:provinciaAttestante               | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN52  | pay_i:nazioneAttestante                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN53  | pay_i:nazioneAttestante                 | ITT                                                                                                                                                                                                                                                       |
      | RTSIN54  | pay_i:nazioneAttestante                 | I                                                                                                                                                                                                                                                         |
      | RTSIN55  | pay_i:nazioneAttestante                 | I8                                                                                                                                                                                                                                                        |
      | RTSIN56  | pay_i:enteBeneficiario                  | None                                                                                                                                                                                                                                                      |
      | RTSIN57  | pay_i:denominazioneBeneficiario         | None                                                                                                                                                                                                                                                      |
      | RTSIN58  | pay_i:identificativoUnivocoBeneficiario | None                                                                                                                                                                                                                                                      |
      | RTSIN59  | pay_i:identificativoUnivocoBeneficiario | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN60  | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN61  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN62  | pay_i:tipoIdentificativoUnivoco         | PP                                                                                                                                                                                                                                                        |
      | RTSIN64  | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN65  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN66  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN67  | pay_i:denominazioneBeneficiario         | None                                                                                                                                                                                                                                                      |
      | RTSIN68  | pay_i:denominazioneBeneficiario         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN69  | pay_i:denominazioneBeneficiario         | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN70  | pay_i:codiceUnitOperBeneficiario        | Empty                                                                                                                                                                                                                                                     |
      | RTSIN71  | pay_i:codiceUnitOperBeneficiario        | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN72  | pay_i:denomUnitOperBeneficiario         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN73  | pay_i:denomUnitOperBeneficiario         | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN74  | pay_i:indirizzoBeneficiario             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN75  | pay_i:indirizzoBeneficiario             | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN76  | pay_i:civicoBeneficiario                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN77  | pay_i:civicoBeneficiario                | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN78  | pay_i:capBeneficiario                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN79  | pay_i:capBeneficiario                   | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN80  | pay_i:localitaBeneficiario              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN81  | pay_i:localitaBeneficiario              | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN82  | pay_i:provinciaBeneficiario             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN83  | pay_i:provinciaBeneficiario             | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN84  | pay_i:nazioneBeneficiario               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN85  | pay_i:nazioneBeneficiario               | 1IT                                                                                                                                                                                                                                                       |
      | RTSIN86  | pay_i:soggettoVersante                  | Occurrences,2                                                                                                                                                                                                                                             |
      | RTSIN87  | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN88  | pay_i:identificativoUnivocoVersante     | None                                                                                                                                                                                                                                                      |
      | RTSIN89  | pay_i:identificativoUnivocoVersante     | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN90  | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN91  | pay_i:tipoIdentificativoUnivoco         | PP                                                                                                                                                                                                                                                        |
      | RTSIN93  | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN94  | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN95  | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN96  | pay_i:anagraficaVersante                | None                                                                                                                                                                                                                                                      |
      | RTSIN97  | pay_i:anagraficaVersante                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN98  | pay_i:anagraficaVersante                | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN99  | pay_i:indirizzoVersante                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN100 | pay_i:indirizzoVersante                 | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN101 | pay_i:civicoVersante                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN102 | pay_i:civicoVersante                    | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN103 | pay_i:capVersante                       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN104 | pay_i:capVersante                       | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN105 | pay_i:localitaVersante                  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN106 | pay_i:localitaVersante                  | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN107 | pay_i:provinciaVersante                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN108 | pay_i:provinciaVersante                 | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN109 | pay_i:nazioneVersante                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN110 | pay_i:nazioneVersante                   | IIT                                                                                                                                                                                                                                                       |
      | RTSIN111 | pay_i:e-mailVersante                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN112 | pay_i:e-mailVersante                    | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail |
      | RTSIN113 | pay_i:e-mailVersante                    | &                                                                                                                                                                                                                                                         |
      | RTSIN114 | pay_i:soggettoPagatore                  | None                                                                                                                                                                                                                                                      |
      | RTSIN115 | pay_i:anagraficaPagatore                | None                                                                                                                                                                                                                                                      |
      | RTSIN116 | pay_i:identificativoUnivocoPagatore     | None                                                                                                                                                                                                                                                      |
      | RTSIN117 | pay_i:identificativoUnivocoPagatore     | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN118 | pay_i:tipoIdentificativoUnivoco         | None                                                                                                                                                                                                                                                      |
      | RTSIN119 | pay_i:tipoIdentificativoUnivoco         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN120 | pay_i:tipoIdentificativoUnivoco         | FF                                                                                                                                                                                                                                                        |
      | RTSIN121 | pay_i:tipoIdentificativoUnivoco         | H                                                                                                                                                                                                                                                         |
      | RTSIN122 | pay_i:codiceIdentificativoUnivoco       | None                                                                                                                                                                                                                                                      |
      | RTSIN123 | pay_i:codiceIdentificativoUnivoco       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN124 | pay_i:codiceIdentificativoUnivoco       | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN125 | pay_i:anagraficaPagatore                | None                                                                                                                                                                                                                                                      |
      | RTSIN126 | pay_i:anagraficaPagatore                | Empty                                                                                                                                                                                                                                                     |
      | RTSIN127 | pay_i:anagraficaPagatore                | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN128 | pay_i:indirizzoPagatore                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN129 | pay_i:indirizzoPagatore                 | QuestiSono71CaratteriAlfaNumericiQuestiSono71CaratteriAlfaNumerici12345                                                                                                                                                                                   |
      | RTSIN130 | pay_i:civicoPagatore                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN131 | pay_i:civicoPagatore                    | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN132 | pay_i:capPagatore                       | Empty                                                                                                                                                                                                                                                     |
      | RTSIN133 | pay_i:capPagatore                       | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RTSIN134 | pay_i:localitaPagatore                  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN135 | pay_i:localitaPagatore                  | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN136 | pay_i:provinciaPagatore                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN137 | pay_i:provinciaPagatore                 | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN138 | pay_i:nazionePagatore                   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN139 | pay_i:nazionePagatore                   | IIT                                                                                                                                                                                                                                                       |
      | RTSIN140 | pay_i:e-mailPagatore                    | Empty                                                                                                                                                                                                                                                     |
      | RTSIN141 | pay_i:e-mailPagatore                    | 257DDDDDDDDDDDDDDDDDDDDDDDDDFFFFFFFFFFFFFFDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDFDDDmail |
      | RTSIN142 | pay_i:datiPagamento                     | None                                                                                                                                                                                                                                                      |
      | RTSIN143 | pay_i:datiPagamento                     | RemoveParent                                                                                                                                                                                                                                              |
      | RTSIN144 | pay_i:codiceEsitoPagamento              | None                                                                                                                                                                                                                                                      |
      | RTSIN145 | pay_i:codiceEsitoPagamento              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN146 | pay_i:codiceEsitoPagamento              | 22                                                                                                                                                                                                                                                        |
      | RTSIN147 | pay_i:codiceEsitoPagamento              | 9                                                                                                                                                                                                                                                         |
      | RTSIN148 | pay_i:importoTotalePagato               | None                                                                                                                                                                                                                                                      |
      | RTSIN149 | pay_i:importoTotalePagato               | Empty                                                                                                                                                                                                                                                     |
      | RTSIN150 | pay_i:importoTotalePagato               | Sono13Caratte                                                                                                                                                                                                                                             |
      | RTSIN151 | pay_i:importoTotalePagato               | 12                                                                                                                                                                                                                                                        |
      | RTSIN152 | pay_i:importoTotalePagato               | 23.1                                                                                                                                                                                                                                                      |
      | RTSIN153 | pay_i:importoTotalePagato               | 235,12                                                                                                                                                                                                                                                    |
      | RTSIN154 | pay_i:identificativoUnivocoVersamento   | None                                                                                                                                                                                                                                                      |
      | RTSIN155 | pay_i:identificativoUnivocoVersamento   | Empty                                                                                                                                                                                                                                                     |
      | RTSIN156 | pay_i:identificativoUnivocoVersamento   | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN157 | pay_i:CodiceContestoPagamento           | None                                                                                                                                                                                                                                                      |
      | RTSIN158 | pay_i:CodiceContestoPagamento           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN159 | pay_i:CodiceContestoPagamento           | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN160 | pay_i:datiSingoloPagamento              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN161 | pay_i:datiSingoloPagamento              | Occurrences,6                                                                                                                                                                                                                                             |
      | RTSIN162 | pay_i:singoloImportoPagato              | None                                                                                                                                                                                                                                                      |
      | RTSIN163 | pay_i:singoloImportoPagato              | Empty                                                                                                                                                                                                                                                     |
      | RTSIN164 | pay_i:singoloImportoPagato              | 99                                                                                                                                                                                                                                                        |
      | RTSIN165 | pay_i:singoloImportoPagato              | 1999999999.99                                                                                                                                                                                                                                             |
      | RTSIN167 | pay_i:singoloImportoPagato              | 10.563                                                                                                                                                                                                                                                    |
      | RTSIN168 | pay_i:singoloImportoPagato              | 10,51                                                                                                                                                                                                                                                     |
      | RTSIN169 | pay_i:esitoSingoloPagamento             | Empty                                                                                                                                                                                                                                                     |
      | RTSIN170 | pay_i:esitoSingoloPagamento             | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN171 | pay_i:dataEsitoSingoloPagamento         | None                                                                                                                                                                                                                                                      |
      | RTSIN172 | pay_i:dataEsitoSingoloPagamento         | Empty                                                                                                                                                                                                                                                     |
      | RTSIN173 | pay_i:dataEsitoSingoloPagamento         | 2001-12-31T12                                                                                                                                                                                                                                             |
      | RTSIN174 | pay_i:dataEsitoSingoloPagamento         | 2001-12-                                                                                                                                                                                                                                                  |
      | RTSIN175 | pay_i:identificativoUnivocoRiscossione  | None                                                                                                                                                                                                                                                      |
      | RTSIN176 | pay_i:identificativoUnivocoRiscossione  | Empty                                                                                                                                                                                                                                                     |
      | RTSIN177 | pay_i:identificativoUnivocoRiscossione  | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RTSIN178 | pay_i:causaleVersamento                 | None                                                                                                                                                                                                                                                      |
      | RTSIN179 | pay_i:causaleVersamento                 | Empty                                                                                                                                                                                                                                                     |
      | RTSIN180 | pay_i:causaleVersamento                 | QuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumerici12345                                                                                                             |
      | RTSIN181 | pay_i:datiSpecificiRiscossione          | None                                                                                                                                                                                                                                                      |
      | RTSIN182 | pay_i:datiSpecificiRiscossione          | Empty                                                                                                                                                                                                                                                     |
      | RTSIN183 | pay_i:datiSpecificiRiscossione          | QuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumericiQuestiSono141CaratteriAlfaNumerici12345                                                                                                             |
      | RTSIN184 | pay_i:commissioniApplicatePSP           | Empty                                                                                                                                                                                                                                                     |
      | RTSIN185 | pay_i:commissioniApplicatePSP           | 22                                                                                                                                                                                                                                                        |
      | RTSIN188 | pay_i:commissioniApplicatePSP           | 10.251                                                                                                                                                                                                                                                    |
      | RTSIN189 | pay_i:commissioniApplicatePSP           | 10,25                                                                                                                                                                                                                                                     |

  @midCheck
  Scenario: Check faultCode PPT_SINTASSI_XSD error on invalid RT tag [RTSIN28]
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
      <pay_i:IdentificativoUnivoco>G</pay_i:IdentificativoUnivoco>
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
      <pay_i:IdentificativoUnivoco>G</pay_i:IdentificativoUnivoco>
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
      <pay_i:IdentificativoUnivoco>F</pay_i:IdentificativoUnivoco>
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
      <pay_i:IdentificativoUnivoco>F</pay_i:IdentificativoUnivoco>
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
    Then check esito is KO of nodoInviaRT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response

  @midCheck
  Scenario: Check faultCode PPT_SINTASSI_XSD error on invalid singoloImportoPagato [RTSIN166]
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
      <pay_i:IdentificativoUnivoco>G</pay_i:IdentificativoUnivoco>
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
      <pay_i:IdentificativoUnivoco>G</pay_i:IdentificativoUnivoco>
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
      <pay_i:IdentificativoUnivoco>F</pay_i:IdentificativoUnivoco>
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
      <pay_i:IdentificativoUnivoco>F</pay_i:IdentificativoUnivoco>
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
      <pay_i:importoTotalePagato>999999999.99</pay_i:importoTotalePagato>
      <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
      <pay_i:CodiceContestoPagamento>CCD01</pay_i:CodiceContestoPagamento>
      <pay_i:datiSingoloPagamento>
      <pay_i:singoloImportoPagato>999999999.99</pay_i:singoloImportoPagato>
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
    Then check esito is KO of nodoInviaRT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRT response