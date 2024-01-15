Feature: T126_InoltraEsitoPagamentoCarta_RPT_bollo_pspNonBollo - NODO4-949
  Background:
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And RPT generation
    """
    <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_2_0.xsd ">
      <pay_i:versioneOggetto>6.0</pay_i:versioneOggetto>
      <pay_i:dominio>
        <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
        <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
      </pay_i:dominio>
      <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
      <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
          <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
          <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
          <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
          <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
          <pay_i:causaleVersamento>RPT con richiesta bollo'</pay_i:causaleVersamento>
          <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
          <pay_i:datiMarcaBolloDigitale>
            <pay_i:tipoBollo>01</pay_i:tipoBollo>
            <pay_i:hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</pay_i:hashDocumento>
            <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
          </pay_i:datiMarcaBolloDigitale>
        </pay_i:datiSingoloVersamento>
      </pay_i:datiVersamento>
    </pay_i:RPT>
    """

  Scenario: Execute nodoInviaRPT request
    Given initial XML nodoInviaRPT
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
        <identificativoPSP>#psp_AGID#</identificativoPSP>
        <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
        <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
        <tipoFirma></tipoFirma>
        <rpt>$rptAttachment</rpt>
      </ws:nodoInviaRPT>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    And check url field exists in nodoInviaRPT response
    And check url contains acardste of nodoInviaRPT response
    And check redirect is 1 of nodoInviaRPT response
    And retrieve session token from $nodoInviaRPTResponse.url

  Scenario: Execute nodoChiediInfoPag request
    Given the Execute nodoInviaRPT request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200
    And check importo field exists in informazioniPagamento response
    And check ragioneSociale field exists in informazioniPagamento response
    And check oggettoPagamento field exists in informazioniPagamento response
    And check urlRedirectEC field exists in informazioniPagamento response
    And check bolloDigitale is True of informazioniPagamento response     
    
  Scenario: Execute nodoInoltraEsitoPagamentoCarta1 request
    Given the Execute nodoInviaRPT request scenario executed successfully
    And initial XML pspInviaCarrelloRPTCarte
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspInviaCarrelloRPTCarteResponse>
                <pspInviaCarrelloRPTResponse>
                  <fault>
                      <faultCode>CANALE_RPT_RIFIUTATA</faultCode>
                      <faultString>fault esterno</faultString>
                      <id>400000000001</id>
                      <description>descrizione fault esterno</description>
                  </fault>
                  <esitoComplessivoOperazione>KO</esitoComplessivoOperazione>
                </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTCarteResponse>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPTCarte
    When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {"idPagamento":"$sessionToken",
    "RRN":12345678,
    "identificativoPsp":"POSTE1",
    "tipoVersamento":"CP",
    "identificativoIntermediario":"BANCOPOSTA",
    "identificativoCanale":"POSTE1",
    "importoTotalePagato":12.31,
    "timestampOperazione":"2018-02-08T17:06:03.100+01:00",
    "codiceAutorizzativo":"123456",
    "esitoTransazioneCarta":"00"}
    """
    Then verify the HTTP status code of inoltroEsito/carta response is 404
    And check error is il PSP indicato non esiste of inoltroEsito/carta response
    And check url field not exists in inoltroEsito/carta response
    And check redirect field not exists in inoltroEsito/carta response

  Scenario: Execution nodoInoltraPagamentoMod1 request
    Given the Execute nodoInoltraEsitoPagamentoCarta1 request scenario executed successfully
    When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
        """
        {
        "idPagamento": "$sessionToken",
        "identificativoPsp":"POSTE1",
        "tipoVersamento":"BP", 
        "identificativoIntermediario":"BANCOPOSTA",
        "identificativoCanale":"POSTE1",
        "tipoOperazione":"web"}
        """
    Then verify the HTTP status code of inoltroEsito/mod1 response is 404
    And check error is il PSP indicato non esiste of inoltroEsito/mod1 response
    And check error field exists in inoltroEsito/mod1 response

Scenario: Execute nodoInoltraEsitoPagamentoCarta2 request
    Given the Execution nodoInoltraPagamentoMod1 request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPTCarte 
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspInviaCarrelloRPTCarteResponse>
                <pspInviaCarrelloRPTResponse>
                  <fault>
                      <faultCode>CANALE_RPT_RIFIUTATA</faultCode>
                      <faultString>fault esterno</faultString>
                      <id>400000000001</id>
                      <description>descrizione fault esterno</description>
                  </fault>
                  <esitoComplessivoOperazione>KO</esitoComplessivoOperazione>
                </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTCarteResponse>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPTCarte
    When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {"idPagamento":"$sessionToken",
      "RRN":12345678,
      "identificativoPsp": "idPsp1",
      "tipoVersamento": "CP",
      "identificativoIntermediario": "91000000002",
      "identificativoCanale": "91000000002_03",
      "esitoTransazioneCarta": "123456", 
      "importoTotalePagato": 11.11,
      "timestampOperazione": "2012-04-23T18:25:43.001Z",
      "codiceAutorizzativo": "123212"}
    """
    Then verify the HTTP status code of inoltroEsito/carta response is 404
    And check error is il PSP indicato non esiste of inoltroEsito/carta response
    And check url field not exists in inoltroEsito/carta response
    And check redirect field not exists in inoltroEsito/carta response

@runnable @independent
  Scenario: Execution nodoInoltraPagamentoMod2 request
    Given the Execute nodoInoltraEsitoPagamentoCarta2 request scenario executed successfully
    When WISP sends rest POST inoltroEsito/mod1 to nodo-dei-pagamenti
        """
        {
        "idPagamento": "$sessionToken",
        "identificativoPsp":"idPsp1",
        "tipoVersamento":"BBT", 
        "identificativoIntermediario": "91000000002",
        "identificativoCanale": "91000000002_03",
        "tipoOperazione":"web"}
        """
    Then verify the HTTP status code of inoltroEsito/mod1 response is 404
    And check error is il PSP indicato non esiste of inoltroEsito/mod1 response
    And check error field exists in inoltroEsito/mod1 response