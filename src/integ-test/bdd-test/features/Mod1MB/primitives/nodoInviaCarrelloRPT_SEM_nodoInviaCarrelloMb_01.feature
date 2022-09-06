Feature: Semantic checks for nodoInviaCarrelloRPT

   Background:

      Given systems up

         Given systems up



   # [SEM_MB_01]
   Scenario: RPT generation

      Given RPT generation

         Given RPT generation

         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
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
         <pay_i:identificativoUnivocoVersamento>#iuv#</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>#carrello#</pay_i:codiceContestoPagamento>
         <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
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

   Scenario: RPT2 generation

      Given the RPT generation scenario executed successfully
      And RPT2 generation

         Given the RPT generation scenario executed successfully
         And RPT2 generation

         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>90000000001</pay_i:identificativoDominio>
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
         <pay_i:identificativoUnivocoVersamento>#IuV#</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>$carrello</pay_i:codiceContestoPagamento>
         <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
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



   Scenario Outline: Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_nessunTrattino primitive
      Given the RPT2 generation scenario executed successfully
      And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazioneCarrelloPPT>
         <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
         <identificativoCarrello>#carrello1#</identificativoCarrello>
         </ppt:intestazioneCarrelloPPT>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoInviaCarrelloRPT>
         <password>pwdpwdpwd</password>
         <identificativoPSP>AGID_01</identificativoPSP>
         <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
         <identificativoCanale>97735020584_02</identificativoCanale>
         <listaRPT>
         <elementoListaRPT>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
         <codiceContestoPagamento>$carrello</codiceContestoPagamento>
         <rpt>$rptAttachment</rpt>
         </elementoListaRPT>
         <elementoListaRPT>
         <identificativoDominio>#codicePA#</identificativoDominio>
         <identificativoUnivocoVersamento>$IuV</identificativoUnivocoVersamento>
         <codiceContestoPagamento>$carrello</codiceContestoPagamento>
         <rpt>$rpt2Attachment</rpt>
         </elementoListaRPT>
         </listaRPT>
         <requireLightPayment>01</requireLightPayment>
         <multiBeneficiario>1</multiBeneficiario>
         </ws:nodoInviaCarrelloRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And <elem> with <value> in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT response
      And check faultCode is <error> of nodoInviaCarrelloRPT response
      Examples:
         | elem                   | value                               | error                   |
         | identificativoCarrello | 7777777777731101905117516600059410  | PPT_MULTI_BENEFICIARIO  |
         | identificativoCarrello | 90000000001311017011570102700-48595 | PPT_MULTI_BENEFICIARIO  |
         | identificativoCarrello | 44444444444311017141190124500-07607 | PPT_MULTI_BENEFICIARIO  |
         | identificativoCarrello | 7777777777311015321688135500-14816  | PPT_MULTI_BENEFICIARIO  |
         | identificativoCarrello | 31101473154911720077777777777-23596 | PPT_DOMINIO_SCONOSCIUTO |


   Scenario: Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_nessunTrattino primitive
         Given the RPT2 generation scenario executed successfully
         And initial XML nodoInviaCarrelloRPT_nessunTrattino
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>#carrello1#</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>AGID_01</identificativoPSP>
                  <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                  <identificativoCanale>97735020584_02</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$IuV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rpt2Attachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT_nessunTrattino
      When EC sends SOAP nodoInviaCarrelloRPT_nessunTrattino to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT_nessunTrattino response
      And check faultCode is PPT_MULTI_BENEFICIARIO of nodoInviaCarrelloRPT_nessunTrattino response



   Scenario: Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_idDominioRPT2 primitive
         Given the Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_nessunTrattino primitive scenario executed successfully
         And initial XML nodoInviaCarrelloRPT_idDominioRPT2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>#carrello_PaIla#</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>AGID_01</identificativoPSP>
                  <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                  <identificativoCanale>97735020584_02</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$IuV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rpt2Attachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT_idDominioRPT2
      When EC sends SOAP nodoInviaCarrelloRPT_idDominioRPT2 to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT_idDominioRPT2 response
      And check faultCode is PPT_MULTI_BENEFICIARIO of nodoInviaCarrelloRPT_idDominioRPT2 response



   Scenario: Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_idDominioNessunaRPT primitive
         Given the Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_idDominioRPT2 primitive scenario executed successfully
         And initial XML nodoInviaCarrelloRPT_idDominioNessunaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>#carrello_nessunaRPT#</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>AGID_01</identificativoPSP>
                  <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                  <identificativoCanale>97735020584_02</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$IuV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rpt2Attachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT_idDominioNessunaRPT
      When EC sends SOAP nodoInviaCarrelloRPT_idDominioNessunaRPT to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT_idDominioNessunaRPT response
      And check faultCode is PPT_MULTI_BENEFICIARIO of nodoInviaCarrelloRPT_idDominioNessunaRPT response


   Scenario: Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_lunghezzaInferiore primitive
         Given the Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_idDominioNessunaRPT primitive scenario executed successfully
         And initial XML nodoInviaCarrelloRPT_lunghezzaInferiore
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>#carrello_lungInferiore#</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>AGID_01</identificativoPSP>
                  <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                  <identificativoCanale>97735020584_02</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$IuV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rpt2Attachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT_lunghezzaInferiore
      When EC sends SOAP nodoInviaCarrelloRPT_lunghezzaInferiore to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT_lunghezzaInferiore response
      And check faultCode is PPT_MULTI_BENEFICIARIO of nodoInviaCarrelloRPT_lunghezzaInferiore response



   Scenario: Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_ordineInvertito primitive
         Given the Check PPT_MULTI_BENEFICIARIO error for nodoInviaCarrelloRPT_lunghezzaInferiore primitive scenario executed successfully
         And initial XML nodoInviaCarrelloRPT_ordineInvertito
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>#carrello_ordInvertito#</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>AGID_01</identificativoPSP>
                  <identificativoIntermediarioPSP>97735020584</identificativoIntermediarioPSP>
                  <identificativoCanale>97735020584_02</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$IuV</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rpt2Attachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT_ordineInvertito
      When EC sends SOAP nodoInviaCarrelloRPT_ordineInvertito to nodo-dei-pagamenti
      Then check esitoComplessivoOperazione is KO of nodoInviaCarrelloRPT_ordineInvertito response
      And check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoInviaCarrelloRPT_ordineInvertito response

