Feature: T126_InoltraEsitoPagamentoCarta_RPT_KO_convenzioni
  Background:
    Given systems up

  Scenario: Create RPT 
    Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And replace $1iuv content with RPTcheckConv content
    And initial XML RPT_XML
    """
    <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/"
              xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
              xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
      <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
      <pay_i:dominio>
        <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
        <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
        <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>#ccp3#</pay_i:codiceContestoPagamento>
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
          <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
          <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
          <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
        </pay_i:datiSingoloVersamento>
      </pay_i:datiVersamento>
    </pay_i:RPT>
    """
    And RPT generation
    """
    $RPT_XML
    """
    And replace canaleUsato content with #canale_DIFFERITO_MOD2# content
    Then checks the value idPsp1 of the record at column ID_SERV_PLUGIN of the table CANALI retrived by the query ID_Serv_Plugin on db nodo_cfg under macro Mod1

  Scenario: Execute nodoInviaRPT request
    Given the Create RPT scenario executed successfully
    And initial XML nodoInviaRPT
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
      <ppt:intestazionePPT>
        <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
        <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
        <identificativoDominio>#creditor_institution_code#</identificativoDominio>
        <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
        <codiceContestoPagamento>$RPT_XML.codiceContestoPagamento</codiceContestoPagamento>
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
    And check url contains acards of nodoInviaRPT response
    And retrieve session token from $nodoInviaRPTResponse.url

@runnable @dependentread 
  Scenario: Execute nodoInoltraEsitoPagamentoCarta request
    Given the Execute nodoInviaRPT request scenario executed successfully
    And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPTCarte 
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspInviaCarrelloRPTCarteResponse>
                <pspInviaCarrelloRPTResponse>
                  <fault>
                      <faultCode>CANALE_RPT_RIFIUTATA</faultCode>
                      <faultString>random</faultString>
                      <id>idPsp1</id>
                  </fault>
                  <esitoComplessivoOperazione>KO</esitoComplessivoOperazione>
                </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTCarteResponse>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {"idPagamento":"$sessionToken",
    "RRN":12352689,
    "identificativoPsp":"#psp#",
    "tipoVersamento":"CP",
    "identificativoIntermediario":"#psp#",
    "identificativoCanale":"#canaleRtPush#",
    "importoTotalePagato":12.31,
    "timestampOperazione":"2018-02-08T17:06:03.100+01:00",
    "codiceAutorizzativo":"123456",
    "esitoTransazioneCarta":"00",
    "codiceConvenzione":"CONV1"}
    """
    Then check errorCode is RIFPSP of inoltroEsito/carta response
 
  # DB Check
    And replace sessionExpected content with $sessionToken content
    And checks the value CONV1 of the record at column CODICE_CONVENZIONE of the table PM_SESSION_DATA retrived by the query codice_convenzione_session on db nodo_online under macro Mod1