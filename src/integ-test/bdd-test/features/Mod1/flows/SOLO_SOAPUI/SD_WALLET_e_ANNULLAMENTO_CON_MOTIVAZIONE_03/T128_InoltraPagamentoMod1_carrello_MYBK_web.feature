Feature: T128_InoltraPagamentoMod1_carrello_MYBK_web
  Background:
    Given systems up
     Given generate 1 notice number and iuv with aux digit 3, segregation code 12 and application code -
        And generate 2 notice number and iuv with aux digit 3, segregation code 12 and application code -
        And replace $1iuv content with newMybank content
        And replace $2iuv content with newMybank content
        And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
        Given RPT1 generation
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
        <pay_i:codiceContestoPagamento>#ccp1#</pay_i:codiceContestoPagamento>
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
        <pay_i:identificativoUnivocoVersamento>$2iuv</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>#ccp2#</pay_i:codiceContestoPagamento>
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
    <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
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
        <pay_i:CodiceContestoPagamento>$1ccp</pay_i:CodiceContestoPagamento>
        <pay_i:datiSingoloPagamento>
          <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
          <pay_i:esitoSingoloPagamento>TUTTO_OK</pay_i:esitoSingoloPagamento>
          <pay_i:dataEsitoSingoloPagamento>2001-01-01</pay_i:dataEsitoSingoloPagamento>
          <pay_i:identificativoUnivocoRiscossione>newMybank</pay_i:identificativoUnivocoRiscossione>
          <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
          <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
        </pay_i:datiSingoloPagamento>
      </pay_i:datiPagamento>
    </pay_i:RT>
    """
    And RT2 generation
    """
    <pay_i:RT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
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
        <pay_i:identificativoUnivocoVersamento>$2iuv</pay_i:identificativoUnivocoVersamento>
        <pay_i:CodiceContestoPagamento>$2ccp</pay_i:CodiceContestoPagamento>
        <pay_i:datiSingoloPagamento>
          <pay_i:singoloImportoPagato>10.00</pay_i:singoloImportoPagato>
          <pay_i:esitoSingoloPagamento>TUTTO_OK</pay_i:esitoSingoloPagamento>
          <pay_i:dataEsitoSingoloPagamento>2001-01-01</pay_i:dataEsitoSingoloPagamento>
          <pay_i:identificativoUnivocoRiscossione>newMybank</pay_i:identificativoUnivocoRiscossione>
          <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
          <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
        </pay_i:datiSingoloPagamento>
      </pay_i:datiPagamento>
    </pay_i:RT>
    """
  Scenario: Execute nodoInviaCarrelloRPT request
    Given initial XML nodoInviaCarrelloRPT
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
                <!--1 or more repetitions:-->
                <elementoListaRPT>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
                  <rpt>$rpt1Attachment</rpt>
                </elementoListaRPT>
                <elementoListaRPT>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$2iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>$2ccp</codiceContestoPagamento>
                  <rpt>$rpt2Attachment</rpt>
                </elementoListaRPT>
            </listaRPT>
          </ws:nodoInviaCarrelloRPT>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
    And check url field exists in nodoInviaCarrelloRPT response
    And check url contains acards of nodoInviaCarrelloRPT response
    And retrieve session token from $nodoInviaCarrelloRPTResponse.url

  Scenario: Execute nodoInoltraEsitoPagamentoMod1 request
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
     And initial XML pspInviaCarrelloRPT 
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaCarrelloRPTResponse>
                        <pspInviaCarrelloRPTResponse>
                            <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                            <identificativoCarrello>$1carrello</identificativoCarrello>
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
      "buyerBank":"CT000002", 
      "idPagamento": "$sessionToken",
      "identificativoPsp": "#psp#",
      "tipoVersamento": "MYBK",
      "identificativoIntermediario": "#psp#",
      "identificativoCanale": "#canale#",
      "tipoOperazione":"web"
    }
    """
    Then verify the HTTP status code of inoltroEsito/mod1 response is 200
    And check esito is OK of inoltroEsito/mod1 response
    And check urlRedirectPSP field exists in inoltroEsito/mod1 response
    And checks the value IDVS=CT000002 of the record at column PARAMETRI_PROFILO_PAGAMENTO of the table CARRELLO_RPT retrived by the query parametri_profilo_pagamento on db wfesp under macro wfesp
  
  
  Scenario: Execute nodoChiediAvanzamentoPagamento
    Given the Execute nodoInoltraEsitoPagamentoMod1 request scenario executed successfully
    When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti  
    Then verify the HTTP status code of avanzamentoPagamento response is 200
    And check esito field exists in avanzamentoPagamento response
    And check esito is OK of avanzamentoPagamento response

  Scenario: Execute nodoInviaRT request
    Given the Execute nodoChiediAvanzamentoPagamento scenario executed successfully
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

@runnable
  Scenario: Execute nodoInviaRT2 request
    Given the Execute nodoInviaRT request scenario executed successfully
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
            <identificativoUnivocoVersamento>$2iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$2ccp</codiceContestoPagamento>
            <tipoFirma></tipoFirma>
            <forzaControlloSegno>1</forzaControlloSegno>
          <rt>$rt2Attachment</rt>
          </ws:nodoInviaRT>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When EC sends SOAP nodoInviaRT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRT response