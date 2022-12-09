Feature: T136_InoltraPagamentoMod2_RPT_BP_KO_PSP
  Background:
    Given systems up
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr#
    And replace $1iuv content with RPTdaRifPsp content
    And RPT generation
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
        <pay_i:codiceContestoPagamento>#ccp1#</pay_i:codiceContestoPagamento>
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
      <pay_i:dataOraMessaggioRicevuta>#timedate#</pay_i:dataOraMessaggioRicevuta>
      <pay_i:riferimentoMessaggioRichiesta>RiferimentoMessaggioRichiesta</pay_i:riferimentoMessaggioRichiesta>
      <pay_i:riferimentoDataRichiesta>#date#</pay_i:riferimentoDataRichiesta>
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
          <pay_i:esitoSingoloPagamento>REJECT</pay_i:esitoSingoloPagamento>
          <pay_i:dataEsitoSingoloPagamento>#date#</pay_i:dataEsitoSingoloPagamento>
          <pay_i:identificativoUnivocoRiscossione>$1iuv</pay_i:identificativoUnivocoRiscossione>
          <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
          <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
        </pay_i:datiSingoloPagamento>
      </pay_i:datiPagamento>
    </pay_i:RT>
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
        <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
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

  Scenario: Execute nodoInoltraEsitoPagamentoMod2 request
    Given the Execute nodoInviaRPT request scenario executed successfully
    And initial XML pspInviaRPT 
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
                <soapenv:Body>
                    <ws:pspInviaRPTResponse>
                        <pspInviaRPTResponse>
                            <esitoComplessivoOperazione>KO</esitoComplessivoOperazione>
                            <fault>
                            <faultCode>CANALE_RPT_RIFIUTATA</faultCode>
                            <faultString>fault esterno</faultString>
                            <id>#psp#</id>
                            <description>descrizione fault esterno</description>
                        </fault>
                        </pspInviaRPTResponse>
                    </ws:pspInviaRPTResponse>
                </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspInviaRPT
    When WISP sends REST POST inoltroEsito/mod2 to nodo-dei-pagamenti
    """
    {
      "idPagamento": "$sessionToken",
      "identificativoPsp": "#psp#",
      "tipoVersamento": "BP",
      "identificativoIntermediario": "#psp#",
      "identificativoCanale": "#canale_DIFFERITO_MOD2#"
    }
    """
    Then verify the HTTP status code of inoltroEsito/mod2 response is 200
    And check esito is KO of inoltroEsito/mod2 response
    And check errorCode is RIFPSP of inoltroEsito/mod2 response
    And check descrizione is Risposta negativa del Canale of inoltroEsito/mod2 response


  Scenario: Execute nodoChiediStatoRPT request
        Given the Execute nodoInoltraEsitoPagamentoMod2 request scenario executed successfully
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
                <codiceContestoPagamento>$1ccp</codiceContestoPagamento>
            </ws:nodoChiediStatoRPT>
        </soapenv:Body>
        </soapenv:Envelope>
        """
        When EC sends SOAP nodoChiediStatoRPT to nodo-dei-pagamenti
        Then check stato field exists in nodoChiediStatoRPT response
        And checks stato contains RPT_RIFIUTATA_PSP of nodoChiediStatoRPT response
        And checks stato contains RPT_RICEVUTA_NODO of nodoChiediStatoRPT response
        And checks stato contains RPT_ACCETTATA_NODO of nodoChiediStatoRPT response

    Scenario: Execute nodoChiediAvanzamentoPagamento
        Given the Execute nodoChiediStatoRPT request scenario executed successfully
        When WISP sends REST GET avanzamentoPagamento?idPagamento=$sessionToken to nodo-dei-pagamenti
        Then verify the HTTP status code of avanzamentoPagamento response is 200
        And checks esito contains KO of avanzamentoPagamento response
    
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
        When PSP sends SOAP nodoInviaRT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRT response
      
    Scenario: Execute nodoNotificaAnnullamento
        Given the Execute nodoInviaRT request scenario executed successfully
        When WISP sends rest GET notificaAnnullamento?idPagamento=$sessionToken&motivoAnnullamento=RIFPSP to nodo-dei-pagamenti
        Then verify the HTTP status code of notificaAnnullamento response is 200

     Scenario: Check DB
        Given the Execute nodoNotificaAnnullamento scenario executed successfully
        #When job paInviaRt triggered after 5 seconds
        And wait 6 seconds for expiration 
        Then checks the value Annullato per RPT rifiutata of the record at column ESITO of the table RT retrived by the query esito on db nodo_online under macro Mod1
        And checks the value RIFPSP of the record at column MOTIVO_ANNULLAMENTO of the table PM_SESSION_DATA retrived by the query motivo_annullamento on db nodo_online under macro Mod1
        
 
  
 