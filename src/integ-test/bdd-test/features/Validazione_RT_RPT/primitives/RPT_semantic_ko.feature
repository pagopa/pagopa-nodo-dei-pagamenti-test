Feature: Syntax checks for SEMANTIC RPT

  Background: 
    Given systems up
    And generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
    And initial XML RPT
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
        <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
        <pay_i:dominio>
          <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
          <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
        </pay_i:dominio>
        <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
        <pay_i:dataOraMessaggioRichiesta>2022-07-07T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
          <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
          <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
          <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
          <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
        </pay_i:enteBeneficiario>
        <pay_i:datiVersamento>
          <pay_i:dataEsecuzionePagamento>2022-07-07</pay_i:dataEsecuzionePagamento>
          <pay_i:importoTotaleDaVersare>1.01</pay_i:importoTotaleDaVersare>
          <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
          <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
          <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
          <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
          <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
          <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
          <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>1.01</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.25</pay_i:commissioneCaricoPA>
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
    And PSP replies to nodo-dei-pagamenti with the pspInviaRPT



@midRunnable
# [RPTSEM7]
Scenario: Check faultCode PPT_AUTORIZZAZIONE error on invalid RPT tag [RPTSEM7]
    Given pay_i:tipoVersamento with PO in RPT
    And RPT generation
      """
      $RPT
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
              <identificativoIntermediarioPSP>91000000001</identificativoIntermediarioPSP>
              <identificativoCanale>91000000001_04</identificativoCanale>
              <tipoFirma></tipoFirma>
              <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
        </soapenv:Body>
      </soapenv:Envelope>
      """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_AUTORIZZAZIONE of nodoInviaRPT response



@midRunnable
# [RPTSEM18]
Scenario: Check faultCode PPT_SEMANTICA error on invalid RPT tag [RPTSEM18]
    Given pay_i:ibanAccredito with None in RPT
    And RPT generation
      """
      $RPT
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
              <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
              <tipoFirma></tipoFirma>
              <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
        </soapenv:Body>
      </soapenv:Envelope>
      """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response

@midRunnable
Scenario: Check faultCode PPT_SEMANTICA error on invalid RPT tag combination [RPTSEM9]
    Given pay_i:ibanAddebito with None in RPT
    And pay_i:tipoVersamento with AD in RPT
    And RPT generation
      """
      $RPT
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
              <identificativoPSP>idPsp1</identificativoPSP>
              <identificativoIntermediarioPSP>91000000001</identificativoIntermediarioPSP>
              <identificativoCanale>91000000001_04</identificativoCanale>
              <tipoFirma></tipoFirma>
              <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
        </soapenv:Body>
      </soapenv:Envelope>
      """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response


@midRunnable
# [RPTSEM16]
Scenario: Check faultCode PPT_IBAN_NON_CENSITO error on invalid RPT tag [RPTSEM16]
    Given pay_i:ibanAccredito with IT96R0123454321000000012345ZZ in RPT
    And RPT generation
      """
      $RPT
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
              <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
              <tipoFirma></tipoFirma>
              <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
        </soapenv:Body>
      </soapenv:Envelope>
      """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_IBAN_NON_CENSITO of nodoInviaRPT response


@midRunnable
# [RPTSEM17]
Scenario: Check faultCode PPT_SEMANTICA error on invalid RPT tag [RPTSEM17]
    Given RPT generation
      """
      <?xml version="1.0" encoding="UTF-8"?>
      <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
        <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
        <pay_i:dominio>
          <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
          <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
        </pay_i:dominio>
        <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
        <pay_i:dataOraMessaggioRichiesta>2022-07-07T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
          <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
          <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
          <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
          <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
        </pay_i:enteBeneficiario>
        <pay_i:datiVersamento>
          <pay_i:dataEsecuzionePagamento>2022-07-07</pay_i:dataEsecuzionePagamento>
          <pay_i:importoTotaleDaVersare>1.01</pay_i:importoTotaleDaVersare>
          <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
          <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
          <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
          <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
          <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
          <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
          <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>1.01</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.25</pay_i:commissioneCaricoPA>
            <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            <pay_i:datiMarcaBolloDigitale>
                <pay_i:tipoBollo>01</pay_i:tipoBollo>
                <pay_i:hashDocumento>ciao</pay_i:hashDocumento>
                <pay_i:provinciaResidenza>RM</pay_i:provinciaResidenza>
            </pay_i:datiMarcaBolloDigitale>
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
              <identificativoCanale>#canaleRtPush#</identificativoCanale>
              <tipoFirma></tipoFirma>
              <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
        </soapenv:Body>
      </soapenv:Envelope>
      """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response


@midRunnable
# [RPTSEM12]
Scenario: 2 datiSingoloVersamento + tipoVersamento = PO [RPTSEM12]
    Given RPT generation
    """
    <?xml version="1.0" encoding="UTF-8"?>
    <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
      <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
      <pay_i:dominio>
        <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
        <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
      </pay_i:dominio>
      <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
      <pay_i:dataOraMessaggioRichiesta>2022-07-07T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
        <pay_i:capBeneficiario>00123</pay_i:capBeneficiario>
        <pay_i:localitaBeneficiario>Roma</pay_i:localitaBeneficiario>
        <pay_i:provinciaBeneficiario>RM</pay_i:provinciaBeneficiario>
        <pay_i:nazioneBeneficiario>IT</pay_i:nazioneBeneficiario>
      </pay_i:enteBeneficiario>
      <pay_i:datiVersamento>
        <pay_i:dataEsecuzionePagamento>2022-07-07</pay_i:dataEsecuzionePagamento>
        <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
        <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
        <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
        <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
        <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
        <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
        <pay_i:datiSingoloVersamento>
          <pay_i:importoSingoloVersamento>2.40</pay_i:importoSingoloVersamento>
          <pay_i:commissioneCaricoPA>1.25</pay_i:commissioneCaricoPA>
          <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
          <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
          <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
          <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
          <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
          <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
          <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
          <!--<pay_i:datiMarcaBolloDigitale> <pay_i:tipoBollo></pay_i:tipoBollo> <pay_i:hashDocumento></pay_i:hashDocumento> <pay_i:provinciaResidenza></pay_i:provinciaResidenza> </datiMarcaBolloDigitale>-->
        </pay_i:datiSingoloVersamento>
         <pay_i:datiSingoloVersamento>
          <pay_i:importoSingoloVersamento>2.40</pay_i:importoSingoloVersamento>
          <pay_i:commissioneCaricoPA>1.25</pay_i:commissioneCaricoPA>
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
            <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
          </ws:nodoInviaRPT>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response