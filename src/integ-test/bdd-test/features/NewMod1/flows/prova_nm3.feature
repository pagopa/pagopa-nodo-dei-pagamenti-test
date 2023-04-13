Feature: spostamento traduttore

    Background:
        Given systems up

    Scenario: activatePaymentNotice
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>002#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: paaAttivaRPT delay
        Given initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <delay>5000</delay>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>$activatePaymentNotice.amount</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>#broker_AGID#</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>#canale_AGID_02#</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TXT/causale $iuv</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT

    Scenario: paaAttivaRPT timeout
        Given initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <delay>10000</delay>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT

    Scenario: paaAttivaRPT KO
        Given initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
            <esito>KO</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>$activatePaymentNotice.amount</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>#broker_AGID#</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>#canale_AGID_02#</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaAttivaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/018431538193400/TXT/causale $iuv</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT

    Scenario: nodoInviaRPT
        Given RPT generation
            """
            <pay_i:RPT xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd " xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>$activatePaymentNotice.amount</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>$activatePaymentNotice.amount</pay_i:importoSingoloVersamento>
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
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>#password#</password>
            <identificativoPSP>#pspFittizio#</identificativoPSP>
            <identificativoIntermediarioPSP>#brokerFittizio#</identificativoIntermediarioPSP>
            <identificativoCanale>#canaleFittizio#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: nodoInviaRPT with ccp from DB
        Given RPT generation
            """
            <pay_i:RPT xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd " xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:dataEsecuzionePagamento>2016-09-16</pay_i:dataEsecuzionePagamento>
            <pay_i:importoTotaleDaVersare>10.00</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$ccp</pay_i:codiceContestoPagamento>
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
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$ccp</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>#password#</password>
            <identificativoPSP>#pspFittizio#</identificativoPSP>
            <identificativoIntermediarioPSP>#brokerFittizio#</identificativoIntermediarioPSP>
            <identificativoCanale>#canaleFittizio#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    #####################################################################################

    @test @check
    Scenario: Test 11
        Given the activatePaymentNotice scenario executed successfully
        And the paaAttivaRPT delay scenario executed successfully
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        And execution query select_activate to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully

        # RPT_ACTIVATIONS
        And checks the value N of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value N of the record at column PAAATTIVARPTERROR of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        And EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        And wait 5 seconds for expiration
        And check outcome is OK of activatePaymentNotice response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value PAYING_RPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 3 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    @test @check
    Scenario: Test 12
        Given the activatePaymentNotice scenario executed successfully
        And the paaAttivaRPT timeout scenario executed successfully
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        And execution query select_activate to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully

        # RPT_ACTIVATIONS
        And checks the value N of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value N of the record at column PAAATTIVARPTERROR of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        And EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And checks the value N of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value Y of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        And wait 12 seconds for expiration
        Then check outcome is KO of activatePaymentNotice response

        # POSITION_PAYMENT
        And checks the value Y of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 4 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    @test @check
    Scenario: Test 13
        Given the activatePaymentNotice scenario executed successfully
        And the paaAttivaRPT timeout scenario executed successfully
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        And wait 12 seconds for expiration
        And execution query select_activate to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully

        # RPT_ACTIVATIONS
        And checks the value N of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value N of the record at column PAAATTIVARPTERROR of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        And EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check outcome is KO of activatePaymentNotice response

        # RPT_ACTIVATIONS
        And checks the value N of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value Y of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value Y of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 4 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################


    Scenario: Test 14 (part 1)
        Given the activatePaymentNotice scenario executed successfully
        And the paaAttivaRPT KO scenario executed successfully
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_ERRORE_RESPONSE of activatePaymentNotice response

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And checks the value Y of the record at column PAAATTIVARPTERROR of the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

    @test @check
    Scenario: Test 14 (part 2)
        Given the Test 14 (part 1) scenario executed successfully
        And execution query select_activate to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activate retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
        And check description is RPT non attivata of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_RIFIUTATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 2 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RPT_RIFIUTATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1