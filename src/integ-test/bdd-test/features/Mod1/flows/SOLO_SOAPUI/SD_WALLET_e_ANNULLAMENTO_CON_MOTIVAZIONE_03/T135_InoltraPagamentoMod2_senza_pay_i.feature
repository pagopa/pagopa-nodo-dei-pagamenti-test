Feature: T135_InoltraPagamentoMod2_senza_pay_i
  Background:
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And RPT generation
    """
    <RPT xmlns="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
      <versioneOggetto>1.0</versioneOggetto>
      <dominio>
        <identificativoDominio>#creditor_institution_code#</identificativoDominio>
        <identificativoStazioneRichiedente>#id_station#</identificativoStazioneRichiedente>
      </dominio>
      <identificativoMessaggioRichiesta>MSGRICHIESTA01</identificativoMessaggioRichiesta>
      <dataOraMessaggioRichiesta>#timedate#</dataOraMessaggioRichiesta>
      <autenticazioneSoggetto>CNS</autenticazioneSoggetto>
      <soggettoVersante>
        <identificativoUnivocoVersante>
          <tipoIdentificativoUnivoco>F</tipoIdentificativoUnivoco>
          <codiceIdentificativoUnivoco>RCCGLD09P09H502E</codiceIdentificativoUnivoco>
        </identificativoUnivocoVersante>
        <anagraficaVersante>Gesualdo;Riccitelli</anagraficaVersante>
        <indirizzoVersante>via del gesu</indirizzoVersante>
        <civicoVersante>11</civicoVersante>
        <capVersante>00186</capVersante>
        <localitaVersante>Roma</localitaVersante>
        <provinciaVersante>RM</provinciaVersante>
        <nazioneVersante>IT</nazioneVersante>
        <e-mailVersante>gesualdo.riccitelli@poste.it</e-mailVersante>
      </soggettoVersante>
      <soggettoPagatore>
        <identificativoUnivocoPagatore>
          <tipoIdentificativoUnivoco>F</tipoIdentificativoUnivoco>
          <codiceIdentificativoUnivoco>RCCGLD09P09H501E</codiceIdentificativoUnivoco>
        </identificativoUnivocoPagatore>
        <anagraficaPagatore>Gesualdo;Riccitelli</anagraficaPagatore>
        <indirizzoPagatore>via del gesu</indirizzoPagatore>
        <civicoPagatore>11</civicoPagatore>
        <capPagatore>00186</capPagatore>
        <localitaPagatore>Roma</localitaPagatore>
        <provinciaPagatore>RM</provinciaPagatore>
        <nazionePagatore>IT</nazionePagatore>
        <e-mailPagatore>gesualdo.riccitelli@poste.it</e-mailPagatore>
      </soggettoPagatore>
      <enteBeneficiario>
        <identificativoUnivocoBeneficiario>
          <tipoIdentificativoUnivoco>G</tipoIdentificativoUnivoco>
          <codiceIdentificativoUnivoco>11111111117</codiceIdentificativoUnivoco>
        </identificativoUnivocoBeneficiario>
        <denominazioneBeneficiario>AZIENDA XXX</denominazioneBeneficiario>
        <codiceUnitOperBeneficiario>123</codiceUnitOperBeneficiario>
        <denomUnitOperBeneficiario>XXX</denomUnitOperBeneficiario>
        <indirizzoBeneficiario>IndirizzoBeneficiario</indirizzoBeneficiario>
        <civicoBeneficiario>123</civicoBeneficiario>
        <capBeneficiario>22222</capBeneficiario>
        <localitaBeneficiario>Roma</localitaBeneficiario>
        <provinciaBeneficiario>RM</provinciaBeneficiario>
        <nazioneBeneficiario>IT</nazioneBeneficiario>
      </enteBeneficiario>
      <datiVersamento>
        <dataEsecuzionePagamento>#date#</dataEsecuzionePagamento>
        <importoTotaleDaVersare>10.00</importoTotaleDaVersare>
        <tipoVersamento>BBT</tipoVersamento>
        <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
        <ibanAddebito>IT45R0760103200000000001016</ibanAddebito>
        <bicAddebito>ARTIITM1045</bicAddebito>
        <firmaRicevuta>0</firmaRicevuta>
        <datiSingoloVersamento>
          <importoSingoloVersamento>10.00</importoSingoloVersamento>
          <commissioneCaricoPA>1.00</commissioneCaricoPA>
          <ibanAccredito>IT96R0123454321000000012345</ibanAccredito>
          <bicAccredito>ARTIITM1050</bicAccredito>
          <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
          <bicAppoggio>ARTIITM1050</bicAppoggio>
          <credenzialiPagatore>CP1.1</credenzialiPagatore>
          <causaleVersamento>pagamento fotocopie pratica RPT</causaleVersamento>
          <datiSpecificiRiscossione>1/abc</datiSpecificiRiscossione>
        </datiSingoloVersamento>
      </datiVersamento>
    </RPT>
    """
  Scenario: Execute nodoInviaRPT request
    Given initial XML nodoInviaRPT
    """
    <soapenv:Envelope
    xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/">
    <soapenv:Header>
        <ns1:intestazionePPT
            xmlns:ns1="http://ws.pagamenti.telematici.gov/ppthead"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
        </ns1:intestazionePPT>
    </soapenv:Header>
    <soapenv:Body>
        <nodoInviaRPT
            xmlns="http://ws.pagamenti.telematici.gov/"
            xmlns:xsd="http://www.w3.org/2001/XMLSchema"
            xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <password xmlns="">pwdpwdpwd</password>
            <identificativoPSP xmlns="">#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP
                xmlns="">#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale xmlns="">#canale_AGID_BBT#</identificativoCanale>
            <tipoFirma xmlns=""/>
                <rpt xmlns="">$rptAttachment</rpt>
            </nodoInviaRPT>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    And retrieve session token from $nodoInviaRPTResponse.url

@runnable @independent
  Scenario: Execute nodoInoltraEsitoPagamentoMod2 request
    Given the Execute nodoInviaRPT request scenario executed successfully
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
    When WISP sends REST POST inoltroEsito/mod2 to nodo-dei-pagamenti
    """
    {
      "idPagamento":"$sessionToken",
      "identificativoPsp":"#psp#",
      "tipoVersamento":"AD",
      "identificativoIntermediario":"#psp#",
      "identificativoCanale":"#canale_DIFFERITO_MOD2#"
    }
    """
    Then check esito field exists in inoltroEsito/mod2 response
    And check esito is OK of inoltroEsito/mod2 response 
   