Feature: Syntax checks for nodoInviaRPT - KO

  Background: 
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And initial XML RPT
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
      <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
      <pay_i:dominio>
          <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
          <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
      </pay_i:dominio>
      <pay_i:identificativoMessaggioRichiesta>TO_GENERATE</pay_i:identificativoMessaggioRichiesta>
      <pay_i:dataOraMessaggioRichiesta>2012-01-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
      <pay_i:autenticazioneSoggetto>CNS</pay_i:autenticazioneSoggetto>
      <pay_i:soggettoVersante>
          <pay_i:identificativoUnivocoVersante>
            <pay_i:tipoIdentificativoUnivoco>F</pay_i:tipoIdentificativoUnivoco>
            <pay_i:codiceIdentificativoUnivoco>RCCGLD09P09H501E</pay_i:codiceIdentificativoUnivoco>
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
            <pay_i:codiceIdentificativoUnivoco>$1iuv</pay_i:codiceIdentificativoUnivoco>
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
      <pay_i:datiVersamento>
          <pay_i:dataEsecuzionePagamento>2012-01-16</pay_i:dataEsecuzionePagamento>
          <pay_i:importoTotaleDaVersare>201</pay_i:importoTotaleDaVersare>
          <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
          <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
          <pay_i:codiceContestoPagamento>n/a</pay_i:codiceContestoPagamento>
          <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
          <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
          <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
          <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>101</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>125</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            <!--<pay_i:datiMarcaBolloDigitale> <pay_i:tipoBollo></pay_i:tipoBollo> <pay_i:hashDocumento></pay_i:hashDocumento> <pay_i:provinciaResidenza></pay_i:provinciaResidenza> </datiMarcaBolloDigitale>-->
          </pay_i:datiSingoloVersamento>
      </pay_i:datiVersamento>
    </pay_i:RPT>
    """
   
  @prova
  Scenario Outline: Check faultCode PPT_SINTASSI_XSD error on invalid RPT tag
    Given <tag> with <tag_value> in RPT
    And RPT generation
    """
    $RPT
    """
    And initial XML nodoInviaRPT
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
          <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
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
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SINTASSI_XSD of nodoInviaRPT response

    Examples: 
      | SoapUI   | tag                                      | tag_value                                                                                                                                                                                                                                                 |
      | RPTSIN1  | pay_i:versioneOggetto                    | None                                                                                                                                                                                                                                                      |
      | RPTSIN2  | pay_i:versioneOggetto                    | Empty                                                                                                                                                                                                                                                     |
      | RPTSIN3  | pay_i:versioneOggetto                    | Sono17CaratteAlfa                                                                                                                                                                                                                                         |
      | RPTSIN4  | pay_i:dominio                            | None                                                                                                                                                                                                                                                      |
      | RPTSIN5  | pay_i:identificativoDominio              | None                                                                                                                                                                                                                                                      |
      | RPTSIN6   | pay_i:identificativoDominio             | Empty                                                                                                                                                                                                                                                     |
      | RPTSIN7   | pay_i:identificativoDominio             | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RPTSIN8   | pay_i:identificativoStazioneRichiedente | Empty                                                                                                                                                                                                                                                     |
      | RPTSIN9   | pay_i:identificativoStazioneRichiedente | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RPTSIN10  | pay_i:identificativoMessaggioRichiesta  | None                                                                                                                                                                                                                                                      |
      | RPTSIN11  | pay_i:identificativoMessaggioRichiesta  | Empty                                                                                                                                                                                                                                                     |
      | RPTSIN12  | pay_i:identificativoMessaggioRichiesta  | QuestiSono36CaratteriAlfaNumericiTT1                                                                                                                                                                                                                      |
      | RPTSIN13  | pay_i:dataOraMessaggioRichiesta         | None                                                                                                                                                                                                                                                      |
      | RPTSIN14  | pay_i:dataOraMessaggioRichiesta         | Empty                                                                                                                                                                                                                                                     |
      | RPTSIN15  | pay_i:dataOraMessaggioRichiesta         | 2001-12-31T12:00:00:0001                                                                                                                                                                                                                                  |
      | RPTSIN16  | pay_i:dataOraMessaggioRichiesta         | 2001-12-31T12:00                                                                                                                                                                                                                                          |
      | RPTSIN17  | pay_i:dataOraMessaggioRichiesta         | 31-12-2001T12:00:00                                                                                                                                                                                                                                       |
      | RPTSIN18  | pay_i:autenticazioneSoggetto            | None                                                                                                                                                                                                                                                      |
      | RPTSIN19  | pay_i:autenticazioneSoggetto            | Empty                                                                                                                                                                                                                                                     |
      | RPTSIN20  | pay_i:autenticazioneSoggetto            | ABS12                                                                                                                                                                                                                                                     |
      | RPTSIN21  | pay_i:autenticazioneSoggetto            | USP                                                                                                                                                                                                                                                       |
      | RPTSIN22  | pay_i:soggettoVersante                  | RemoveParent                                                                                                                                                                                                                                              |
      | RPTSIN23  | pay_i:identificativoUnivocoVersante     | None                                                                                                                                                                                                                                                      |
      | RPTSIN24  | pay_i:identificativoUnivocoVersante     | RemoveParent                                                                                                                                                                                                                                              |
