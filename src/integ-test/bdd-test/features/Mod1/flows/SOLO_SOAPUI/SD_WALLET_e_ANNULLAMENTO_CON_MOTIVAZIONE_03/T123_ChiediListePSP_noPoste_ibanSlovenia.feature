Feature: T123_ChiediListePSP_noPoste_IbanSlovenia
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
        <pay_i:identificativoDominio>23232323232</pay_i:identificativoDominio>
        <pay_i:identificativoStazioneRichiedente>stazPaStress23</pay_i:identificativoStazioneRichiedente>
      </pay_i:dominio>
      <pay_i:identificativoMessaggioRichiesta>idMsgRichiesta</pay_i:identificativoMessaggioRichiesta>
      <pay_i:dataOraMessaggioRichiesta>#timedate#</pay_i:dataOraMessaggioRichiesta>
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
        <pay_i:dataEsecuzionePagamento>#date#</pay_i:dataEsecuzionePagamento>
        <pay_i:importoTotaleDaVersare>6.20</pay_i:importoTotaleDaVersare>
        <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
        <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
        <pay_i:ibanAddebito>IT45R0760103200000000001016</pay_i:ibanAddebito>
        <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
        <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
        <pay_i:datiSingoloVersamento>
          <pay_i:importoSingoloVersamento>6.20</pay_i:importoSingoloVersamento>
          <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
          <pay_i:ibanAccredito>SI56107601000123438</pay_i:ibanAccredito>
          <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
          <pay_i:ibanAppoggio>SI56107601000123438</pay_i:ibanAppoggio>
          <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
          <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
          <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
          <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
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
        <identificativoIntermediarioPA>intPaStress23</identificativoIntermediarioPA>
        <identificativoStazioneIntermediarioPA>stazPaStress23</identificativoStazioneIntermediarioPA>
        <identificativoDominio>23232323232</identificativoDominio>
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
    And retrieve session token from $nodoInviaRPTResponse.url

  Scenario: Execute nodoChiediInfoPag request
    Given the Execute nodoInviaRPT request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200

    # DB Check
    And execution query version to get value on the table ELENCO_SERVIZI_PSP_SYNC_STATUS, with the columns SNAPSHOT_VERSION under macro Mod1 with db name nodo_offline
    And through the query version retrieve param version at position 0 and save it under the key version
    And replace importoTot content with 6.20 content
    And replace lingua content with IT content
    # Carte
    And execution query getPspCarte to get value on the table ELENCO_SERVIZI_PSP, with the columns COUNT(*) under macro Mod1 with db name nodo_offline
    And through the query getPspCarte retrieve param sizeCarte at position 0 and save it under the key sizeCarte
    And execution query getPspCarte to get value on the table ELENCO_SERVIZI_PSP, with the columns ID under macro Mod1 with db name nodo_offline
    And through the query getPspCarte retrieve param listaCarte at position -1 and save it under the key listaCarte
    # Conto
    And execution query getPspConto to get value on the table ELENCO_SERVIZI_PSP, with the columns COUNT(*) under macro Mod1 with db name nodo_offline
    And through the query getPspConto retrieve param sizeConto at position 0 and save it under the key sizeConto
    And execution query getPspConto to get value on the table ELENCO_SERVIZI_PSP, with the columns ID under macro Mod1 with db name nodo_offline
    And through the query getPspConto retrieve param listaConto at position -1 and save it under the key listaConto
    # Altro
    And execution query getPspAltro to get value on the table ELENCO_SERVIZI_PSP, with the columns COUNT(*) under macro Mod1 with db name nodo_offline
    And through the query getPspAltro retrieve param sizeAltro at position 0 and save it under the key sizeAltro
    And execution query getPspAltro to get value on the table ELENCO_SERVIZI_PSP, with the columns ID under macro Mod1 with db name nodo_offline
    And through the query getPspAltro retrieve param listaAltro at position -1 and save it under the key listaAltro

  Scenario: Execute nodoChiediListaPSP - conto
    Given the Execute nodoChiediInfoPag request scenario executed successfully
    When WISP sends rest GET listaPSP?idPagamento=$sessionToken&percorsoPagamento=CC&lingua=$lingua to nodo-dei-pagamenti
    Then verify the HTTP status code of listaPSP response is 200
    And check totalRows is $sizeConto of listaPSP response
    And check data is $listaConto of listaPSP response

  Scenario: Execute nodoChiediListaPSP - altro
    Given the Execute nodoChiediListaPSP - conto scenario executed successfully
    When WISP sends rest GET listaPSP?idPagamento=$sessionToken&percorsoPagamento=ALTRO&lingua=$lingua to nodo-dei-pagamenti
    Then verify the HTTP status code of listaPSP response is 200
    And check totalRows is $sizeAltro of listaPSP response
    And check data is $listaAltro of listaPSP response

@runnable
  Scenario: Execute nodoChiediListaPSP - carte
    Given the Execute nodoChiediListaPSP - altro scenario executed successfully
    When WISP sends rest GET listaPSP?idPagamento=$sessionToken&percorsoPagamento=CARTE&lingua=$lingua to nodo-dei-pagamenti
    Then verify the HTTP status code of listaPSP response is 200
    And check totalRows is $sizeCarte of listaPSP response
    And check data is $listaCarte of listaPSP response