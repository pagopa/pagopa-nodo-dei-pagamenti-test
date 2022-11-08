Feature: Flows checks for nodoInviaCarrelloRPT [annulli_04]

   Background:
      Given systems up


   # [annulli_04]
   Scenario: RPT generation
      Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
      And generate 1 cart with PA #creditor_institution_code# and notice number $1noticeNumber
      And RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.1</pay_i:versioneOggetto>
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
         <pay_i:importoTotaleDaVersare>1.50</pay_i:importoTotaleDaVersare>
         <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
         <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
         <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
         <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
         <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
         <pay_i:datiSingoloVersamento>
         <pay_i:importoSingoloVersamento>1.50</pay_i:importoSingoloVersamento>
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
      And generate 2 notice number and iuv with aux digit 3, segregation code #cod_segr# and application code NA
      And RPT2 generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.1</pay_i:versioneOggetto>
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
         <pay_i:importoTotaleDaVersare>1.50</pay_i:importoTotaleDaVersare>
         <pay_i:tipoVersamento>BBT</pay_i:tipoVersamento>
         <pay_i:identificativoUnivocoVersamento>$2iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>CCD01</pay_i:codiceContestoPagamento>
         <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
         <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
         <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
         <pay_i:datiSingoloVersamento>
         <pay_i:importoSingoloVersamento>1.50</pay_i:importoSingoloVersamento>
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

   Scenario: Execute nodoInviaCarrelloRPT request
      Given the RPT generation scenario executed successfully
      And initial XML paaInviaRT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header/>
         <soapenv:Body>
         <ws:paaInviaRTRisposta>
         <paaInviaRTRisposta>
         <esito>OK</esito>
         </paaInviaRTRisposta>
         </ws:paaInviaRTRisposta>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paaInviaRT
      And initial XML nodoInviaCarrelloRPT
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
         <requireLightPayment>01</requireLightPayment>
         <multiBeneficiario>0</multiBeneficiario>
         </ws:nodoInviaCarrelloRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is OK of nodoInviaCarrelloRPT response
      Then retrieve session token from $nodoInviaCarrelloRPTResponse.url


   Scenario: update column valid_to UPDATED_TIMESTAMP
      Given the Execute nodoInviaCarrelloRPT request scenario executed successfully
      And replace iuv content with $1iuv content
      And replace pa1 content with #creditor_institution_code_secondary# content
      And change date Today to remove minutes 20
      Then update through the query DB_GEST_ANN_update1 with date $date under macro Mod1Mb on db nodo_online
      And replace iuv content with $2iuv content
      And update through the query DB_GEST_ANN_update1 with date $date under macro Mod1Mb on db nodo_online
      And wait 10 second for expiration

@runnable
   # Activate phase
   Scenario: Trigger annullamentoRptMaiRichiesteDaPm
      Given the update column valid_to UPDATED_TIMESTAMP scenario executed successfully
      When job annullamentoRptMaiRichiesteDaPm triggered after 10 seconds
      And wait 10 seconds for expiration
      Then verify the HTTP status code of annullamentoRptMaiRichiesteDaPm response is 200



      #DB-CHECK-STATI_RPT
      And replace iuv content with $1iuv content

      And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query DB_GEST_ANN_stati_rpt on db nodo_online under macro Mod1Mb
      And replace 2IuV content with $2iuv content
      And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query DB_GEST_ANN_iuv2 on db nodo_online under macro Mod1Mb

      #DB-CHECK-STATI_RPT_SNAPSHOT
      And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_stati_rpt on db nodo_online under macro Mod1Mb
      And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query DB_GEST_ANN_iuv2 on db nodo_online under macro Mod1Mb

      #DB-CHECK-STATI_CARRELLO
      And checks the value CART_RICEVUTO_NODO, CART_ACCETTATO_NODO, CART_PARCHEGGIATO_NODO of the record at column STATO of the table STATI_CARRELLO retrived by the query DB_GEST_ANN_stati_payment_token on db nodo_online under macro Mod1Mb

      #DB-CHECK-STATI_CARRELLO_SNAPSHOT
      And checks the value CART_PARCHEGGIATO_NODO of the record at column STATO of the table STATI_CARRELLO_SNAPSHOT retrived by the query DB_GEST_ANN_stati_payment_token on db nodo_online under macro Mod1Mb

      #DB-CHECK-POSITION_PAYMENT_STATUS
      And verify 0 record for the table POSITION_PAYMENT_STATUS retrived by the query DB_GEST_ANN_stati_position_payment_status on db nodo_online under macro Mod1Mb

      #DB-CHECK-POSITION_PAYMENT_STATUS_SNAPSHOT
      And verify 0 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query DB_GEST_ANN_stati_position_payment_status on db nodo_online under macro Mod1Mb

      #DB-CHECK-POSITION_STATUS
      And verify 0 record for the table POSITION_STATUS retrived by the query DB_GEST_ANN_stati_position_status on db nodo_online under macro Mod1Mb

      #DB-CHECK-POSITION_STATUS_SNAPSHOT
      And verify 0 record for the table POSITION_STATUS_SNAPSHOT retrived by the query DB_GEST_ANN_stati_position_status on db nodo_online under macro Mod1Mb

