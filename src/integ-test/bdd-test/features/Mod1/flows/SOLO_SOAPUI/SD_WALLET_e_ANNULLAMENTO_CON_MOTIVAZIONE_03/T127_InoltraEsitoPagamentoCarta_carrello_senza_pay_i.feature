Feature: T127_InoltraEsitoPagamentoCarta_carrello_senza_pay_i
  Background:
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And generate 2 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr_old#
    And RPT generation 
    """
    <RPT xmlns="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
      <versioneOggetto>1.0</versioneOggetto>
      <dominio>
        <identificativoDominio>#creditor_institution_code#</identificativoDominio>
        <identificativoStazioneRichiedente>#id_station#</identificativoStazioneRichiedente>
      </dominio>
      <identificativoMessaggioRichiesta>MSGRICHIESTA01</identificativoMessaggioRichiesta>
      <dataOraMessaggioRichiesta>2016-09-16T11:24:10</dataOraMessaggioRichiesta>
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
        <dataEsecuzionePagamento>2016-09-16</dataEsecuzionePagamento>
        <importoTotaleDaVersare>15.00</importoTotaleDaVersare>
        <tipoVersamento>BBT</tipoVersamento>
        <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
        <ibanAddebito>IT96R0123454321000000012345</ibanAddebito>
        <bicAddebito>ARTIITM1045</bicAddebito>
        <firmaRicevuta>0</firmaRicevuta>
        <datiSingoloVersamento>
          <importoSingoloVersamento>15.00</importoSingoloVersamento>
          <commissioneCaricoPA>1.00</commissioneCaricoPA>
          <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
          <bicAccredito>ARTIITM1050</bicAccredito>
          <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
          <bicAppoggio>ARTIITM1050</bicAppoggio>
          <credenzialiPagatore>CP1.1</credenzialiPagatore>
          <causaleVersamento>RPT1</causaleVersamento>
          <datiSpecificiRiscossione>1/abc</datiSpecificiRiscossione>
        </datiSingoloVersamento>
      </datiVersamento>
    </RPT>
    """
    And RPT2 generation
    """
    <RPT xmlns="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
      <versioneOggetto>1.0</versioneOggetto>
      <dominio>
        <identificativoDominio>#creditor_institution_code#</identificativoDominio>
        <identificativoStazioneRichiedente>#id_station#</identificativoStazioneRichiedente>
      </dominio>
      <identificativoMessaggioRichiesta>MSGRICHIESTA01</identificativoMessaggioRichiesta>
      <dataOraMessaggioRichiesta>2016-09-16T11:24:10</dataOraMessaggioRichiesta>
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
        <dataEsecuzionePagamento>2016-09-16</dataEsecuzionePagamento>
        <importoTotaleDaVersare>5.00</importoTotaleDaVersare>
        <tipoVersamento>BBT</tipoVersamento>
        <identificativoUnivocoVersamento>$2iuv</identificativoUnivocoVersamento>
        <codiceContestoPagamento>CCD01</codiceContestoPagamento>
        <ibanAddebito>IT96R0123454321000000012345</ibanAddebito>
        <bicAddebito>ARTIITM1045</bicAddebito>
        <firmaRicevuta>0</firmaRicevuta>
        <datiSingoloVersamento>
          <importoSingoloVersamento>5.00</importoSingoloVersamento>
          <commissioneCaricoPA>10.00</commissioneCaricoPA>
          <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
          <bicAccredito>ARTIITM1050</bicAccredito>
          <ibanAppoggio>IT96R0123454321000000012345</ibanAppoggio>
          <bicAppoggio>ARTIITM1050</bicAppoggio>
          <credenzialiPagatore>CP1.1</credenzialiPagatore>
          <causaleVersamento>RPT2</causaleVersamento>
          <datiSpecificiRiscossione>1/abc</datiSpecificiRiscossione>
        </datiSingoloVersamento>
      </datiVersamento>
    </RPT>
    """

  Scenario: Execute nodoInviaCarrelloRPT request
    Given initial XML nodoInviaCarrelloRPT
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
          <ppt:intestazioneCarrelloPPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <identificativoCarrello>CART$1iuv</identificativoCarrello>
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
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <rpt>$rptAttachment</rpt>
                </elementoListaRPT>
                <elementoListaRPT>
                  <identificativoDominio>#creditor_institution_code#</identificativoDominio>
                  <identificativoUnivocoVersamento>$2iuv</identificativoUnivocoVersamento>
                  <codiceContestoPagamento>CCD01</codiceContestoPagamento>
                  <rpt>$rpt2Attachment</rpt>
                </elementoListaRPT>
            </listaRPT>
          </ws:nodoInviaCarrelloRPT>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
    Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
    And check url contains acards of nodoInviaCarrelloRPT response
    And retrieve session token from $nodoInviaCarrelloRPTResponse.url

  Scenario: Execute informazioniPagamento request
    Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
    When WISP sends rest GET informazioniPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
    Then verify the HTTP status code of informazioniPagamento response is 200
    And check importo field exists in informazioniPagamento response
    And check email field exists in informazioniPagamento response
    And check ragioneSociale field exists in informazioniPagamento response
    And check oggettoPagamento field exists in informazioniPagamento response
    And check urlRedirectEC field exists in informazioniPagamento response

  Scenario: Execute nodoInoltraEsitoPagamentoCarta1 request
    Given the Execute informazioniPagamento request scenario executed successfully
    And initial XML pspInviaCarrelloRPTCarte
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspInviaCarrelloRPTCarteResponse>
                <pspInviaCarrelloRPTResponse>
                    <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTCarteResponse>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPTCarte
    When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {"idPagamento": "$sessionToken",
    "RRN":1872787,
    "identificativoPsp": "#psp#",
    "tipoVersamento": "CP",
    "identificativoIntermediario": "#psp#",
    "identificativoCanale": "#canale#",
    "esitoTransazioneCarta": "00", 
    "importoTotalePagato": 11.11,
    "timestampOperazione": "2012-04-23T18:25:43.001Z",
    "codiceAutorizzativo": "123212"}
    """
    Then check esito field exists in inoltroEsito/carta response
    And check esito is OK of inoltroEsito/carta response
    And check url field not exists in inoltroEsito/carta response
    And check redirect field not exists in inoltroEsito/carta response

  Scenario: Execute nodoChiediStatoRPT request
    Given the Execute nodoInoltraEsitoPagamentoCarta1 scenario executed successfully
    And initial XML nodoChiediStatoRPT
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header/>
      <soapenv:Body>
          <ws:nodoChiediStatoRPT>
            <identificativoIntermediarioPA>#creditor_institution_code#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code#</identificativoDominio>
            <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>CCD01</codiceContestoPagamento>
          </ws:nodoChiediStatoRPT>
      </soapenv:Body>
    </soapenv:Envelope>
    """
    When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
    Then checks stato contains RPT_ACCETTATA_PSP of nodoChiediStatoRPT response
    And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
    And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response

@runnable
  Scenario: Execute nodoInoltraEsitoPagamentoCarta2 request
    Given the Execute nodoChiediStatoRPT request scenario executed successfully
    And initial XML pspInviaCarrelloRPTCarte
    """
    <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header/>
        <soapenv:Body>
            <ws:pspInviaCarrelloRPTCarteResponse>
                <pspInviaCarrelloRPTResponse>
                    <esitoComplessivoOperazione>OK</esitoComplessivoOperazione>
                </pspInviaCarrelloRPTResponse>
            </ws:pspInviaCarrelloRPTCarteResponse>
        </soapenv:Body>
    </soapenv:Envelope>
    """
    And PSP replies to nodo-dei-pagamenti with the pspInviaCarrelloRPTCarte
    When WISP sends REST POST inoltroEsito/carta to nodo-dei-pagamenti
    """
    {"idPagamento": "$sessionToken",
    "RRN":1872787,
    "identificativoPsp": "#psp#",
    "tipoVersamento": "CP",
    "identificativoIntermediario": "#psp#",
    "identificativoCanale": "#canale#",
    "esitoTransazioneCarta": "123456", 
    "importoTotalePagato": 11.11,
    "timestampOperazione": "2012-04-23T18:25:43.001Z",
    "codiceAutorizzativo": "123212"}
    """
    Then check esito field exists in inoltroEsito/carta response
    And check esito is OK of inoltroEsito/carta response
    And check url field not exists in inoltroEsito/carta response
    And check redirect field not exists in inoltroEsito/carta response