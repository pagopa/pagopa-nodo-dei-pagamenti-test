Feature: Semantic checks for nodoInviaCarrelloRPT

   Background:
         Given systems up

   Scenario: Define RPT
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>#idCarrello#</pay_i:codiceContestoPagamento>
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
  
   Scenario Outline: Check PPT_DOMINIO_SCONOSCIUTO error for nodoInviaCarrelloRPT primitive
         Given the Define RPT scenario executed successfully
         And <tag> with <value> in rptAttachment
         And initial XML nodoInviaCarrelloRPT

         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$idCarrello</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$idCarrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_DOMINIO_SCONOSCIUTO of nodoInviaCarrelloRPT response
      Examples:
         | tag                            | value                    | soapUI test |
         | pay_i:identificativoDominio    | 09812374659              | SEM_MB_02   |
         | pay_i:identificativoDominio    | 77777777777              | SEM_MB_03   |



   Scenario: Define RPT2
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
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

   Scenario Outline: Check error for nodoInviaCarrelloRPT primitive
         Given the Define RPT2 scenario executed successfully
         And <tag> with <value> in rptAttachment
         And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is <fault_code> of nodoInviaCarrelloRPT response
      Examples:
         | tag                            | value                       | fault_code                     | soapUI test |
         | pay_i:identificativoDominio    | 09812374659                 | PPT_DOMINIO_SCONOSCIUTO        | SEM_MB_04   |
         | pay_i:identificativoDominio    | 77777777778                 | PPT_MULTI_BENEFICIARIO         | SEM_MB_05   |
         | pay_i:identificativoDominio    | NOT_ENABLED                 | PPT_DOMINIO_DISABILITATO       | SEM_MB_10   |



   Scenario: Define RPT3
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
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

   Scenario Outline: Check PPT_SEMANTICA error for nodoInviaCarrelloRPT primitive
         Given the Define RPT3 scenario executed successfully
         And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And <tag> with <value> in nodoInviaCarrelloRPT
      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is <fault_code> of nodoInviaCarrelloRPT response
      Examples:
         | tag                            | value                           | fault_code                     | soapUI test |
         | identificativoDominio          | 09871234560                     | PPT_SEMANTICA                  | SEM_MB_06   |
         | identificativoDominio          | 77777777778                     | PPT_SEMANTICA                  | SEM_MB_07   |


Scenario: Define RPT4
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>#carrello_NOT_ENABLED#</pay_i:codiceContestoPagamento>
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

   Scenario Outline: Check PPT_DOMINIO_DISABILITATO error for nodoInviaCarrelloRPT primitive
         Given the Define RPT4 scenario executed successfully
         And <tag> with <value> in rptAttachment
         And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello_NOT_ENABLED</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello_NOT_ENABLED</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is <fault_code> of nodoInviaCarrelloRPT response
      Examples:
         | tag                            | value                       | fault_code                     | soapUI test |
         | pay_i:identificativoDominio    | 11111122223                 | PPT_DOMINIO_DISABILITATO       | SEM_MB_08   |
         | pay_i:identificativoDominio    | 77777777777                 | PPT_DOMINIO_DISABILITATO       | SEM_MB_09   |
      # il test 08 individua un idDominio disabilitato ma che non sia NOT_ENABLED. Verificare un idDominio disabilitato per costruzione carrello !


   # [SEM_MB_11]
   Scenario: Define RPT5
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>11111122223</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>#carrello2#</pay_i:codiceContestoPagamento>
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

   Scenario: Check PPT_STAZIONE_INT_PA_SCONOSCIUTA error for nodoInviaCarrelloRPT primitive
         Given the Define RPT5 scenario executed successfully
         And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello2</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello2</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_STAZIONE_INT_PA_SCONOSCIUTA of nodoInviaCarrelloRPT response



   # [SEM_MB_12]
   Scenario: Define RPT6
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>11111122223</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>#carrello_NOT_ENABLED#</pay_i:codiceContestoPagamento>
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

   Scenario: Check PPT_STAZIONE_INT_PA_DISABILITATA error for nodoInviaCarrelloRPT primitive
         Given the Define RPT6 scenario executed successfully
         And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>11111122222_01</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello_NOT_ENABLED</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello_NOT_ENABLED</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_STAZIONE_INT_PA_DISABILITATA of nodoInviaCarrelloRPT response


   # [SEM_MB_13]
   Scenario: Define RPT7
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>#carrello3#</pay_i:codiceContestoPagamento>
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

   Scenario: Check PPT_INTERMEDIARIO_PA_DISABILITATO error for nodoInviaCarrelloRPT primitive
         Given the Define RPT7 scenario executed successfully
         And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>11111122222_01</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello3</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello3</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_INTERMEDIARIO_PA_DISABILITATO of nodoInviaCarrelloRPT response


   # [SEM_MB_14]
   Scenario: No error for nodoInviaCarrelloRPT primitive
         Given the Define RPT2 scenario executed successfully 
         And initial XML nodoInviaCarrelloRPT

         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaCarrelloRPT response


   Scenario: Check PPT_ID_CARRELLO_DUPLICATO error for nodoInviaCarrelloRPT primitive
         Given the No error for nodoInviaCarrelloRPT primitive scenario executed successfully 
         And initial XML nodoInviaCarrelloRPT

         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT1 to nodo-dei-pagamenti
      Then check faultCode is PPT_ID_CARRELLO_DUPLICATO of nodoInviaCarrelloRPT response 



   # [SEM_MB_15]
   Scenario: Define RPT8
         Given RPT generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#codicePA#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
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


   Scenario: Define RPT9
         Given the Define RPT8 scenario executed successfully
         And RPT2 generation
         """
         <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>90000000001</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#intermediarioPA#</pay_i:identificativoStazioneRichiedente>
         </pay_i:dominio>
         <pay_i:identificativoMessaggioRichiesta>MSGRICHIESTA01</pay_i:identificativoMessaggioRichiesta>
         <pay_i:dataOraMessaggioRichiesta>2016-09-16T11:24:10</pay_i:dataOraMessaggioRichiesta>
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
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
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


   Scenario: Check error for nodoInviaCarrelloRPT primitive
         Given the Define RPT9 scenario executed successfully
         And initial XML nodoInviaCarrelloRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
               <ppt:intestazioneCarrelloPPT>
                  <identificativoIntermediarioPA>#codicePA#</identificativoIntermediarioPA>
                  <identificativoStazioneIntermediarioPA>#id_station#</identificativoStazioneIntermediarioPA>
                  <identificativoCarrello>$carrello</identificativoCarrello>
               </ppt:intestazioneCarrelloPPT>
            </soapenv:Header>
            <soapenv:Body>
               <ws:nodoInviaCarrelloRPT>
                  <password>pwdpwdpwd</password>
                  <identificativoPSP>#psp#</identificativoPSP>
                  <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                  <identificativoCanale>#canale#</identificativoCanale>
                  <listaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>#codicePA#</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment</rpt>
                     </elementoListaRPT>
                     <elementoListaRPT>
                        <identificativoDominio>90000000001</identificativoDominio>
                        <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
                        <codiceContestoPagamento>$carrello</codiceContestoPagamento>
                        <rpt>$rptAttachment2</rpt>
                     </elementoListaRPT>
                  </listaRPT>
                  <requireLightPayment>01</requireLightPayment>
                  <multiBeneficiario>1</multiBeneficiario>
               </ws:nodoInviaCarrelloRPT>
            </soapenv:Body>
         </soapenv:Envelope>
         """

      And multiBeneficiario with true in nodoInviaCarrelloRPT
      When EC sends SOAP nodoInviaCarrelloRPT to nodo-dei-pagamenti
      Then check outcome is KO of nodoInviaCarrelloRPT response
      And check faultCode is PPT_SEMANTICA of nodoInviaCarrelloRPT response
      And check description is flagMultibeneficiario non disponibile per pagamenti diversi da WISP2 of nodoInviaCarrelloRPT response
