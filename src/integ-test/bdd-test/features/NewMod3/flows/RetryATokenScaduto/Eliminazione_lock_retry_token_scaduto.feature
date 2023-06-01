Feature: Eliminazione_lock_retry_token_scaduto

    Background:
        Given systems up

    Scenario: verifyPaymentNotice
        Given initial XML verifyPaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:verifyPaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>002#iuv#</noticeNumber>
            </qrCode>
            </nod:verifyPaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial xml paaVerificaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaVerificaRPTRisposta>
            <paaVerificaRPTRisposta>
            <esito>OK</esito>
            <datiPagamentoPA>
            <importoSingoloVersamento>1.00</importoSingoloVersamento>
            <ibanAccredito>IT45R0760103200000000001016</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>#id_station_old#</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>f6</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>r6</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>yr</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>"paaVerificaRPT"</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>ut</pag:civicoBeneficiario>
            <pag:capBeneficiario>jyr</pag:capBeneficiario>
            <pag:localitaBeneficiario>yj</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>h8</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>IT</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>of8</credenzialiPagatore>
            <causaleVersamento>prova/RFDB/$iuv/TESTO/causale del versamento</causaleVersamento>
            </datiPagamentoPA>
            </paaVerificaRPTRisposta>
            </ws:paaVerificaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaVerificaRPT
        When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of verifyPaymentNotice response

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
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>002$iuv</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
            <amount>10.00</amount>
            <dueDate>2021-12-31</dueDate>
            <paymentNote>causale</paymentNote>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And initial XML paaAttivaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/" xmlns:pag="http://www.digitpa.gov.it/schemas/2011/Pagamenti/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:paaAttivaRPTRisposta>
            <paaAttivaRPTRisposta>
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
        When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response

    Scenario: nodoInviaRPT request
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>$activatePaymentNotice.fiscalCode</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>##id_station_old##</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
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
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
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

    Scenario: nodoInviaRPT token-v2 request
        Given RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>$activatePaymentNotice.fiscalCode</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>##id_station_old##</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken-v2</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123451234512345678904</pay_i:ibanAddebito>
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
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
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
            <codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken-v2</codiceContestoPagamento>
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

    Scenario: sendPaymentOutcome
        Given initial XML sendPaymentOutcome
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
            <outcome>OK</outcome>
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>JHNDOE00A01F205N</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>John Doe</fullName>
            <streetName>street</streetName>
            <civicNumber>12</civicNumber>
            <postalCode>89020</postalCode>
            <city>city</city>
            <stateProvinceRegion>MI</stateProvinceRegion>
            <country>IT</country>
            <e-mail>john.doe@test.it</e-mail>
            </payer>
            <applicationDate>2021-10-01</applicationDate>
            <transferDate>2021-10-02</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is KO of sendPaymentOutcome response
        And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response

    Scenario: No regression 1 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        And wait 5 seconds for expiration
        And the nodoInviaRPT request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check redirect is 0 of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

    Scenario: No regression 1 (part 2)
        Given the No regression 1 (part 1) scenario executed successfully
        When job mod3CancelV1 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    Scenario: No regression 1 (part 3)
        Given the No regression 1 (part 2) scenario executed successfully
        When job paInviaRt triggered after 4 seconds
        Then verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3
    @test @lazy @dependentread
    Scenario: No regression 1 (part 4)
        Given the No regression 1 (part 3) scenario executed successfully
        And the sendPaymentOutcome scenario executed successfully
        And wait 5 seconds for expiration
        And the nodoInviaRPT token-v2 request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And wait 5 seconds for expiration

        # Check XML RT-
        And execution query rt_xml to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value #pspFittizio#
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value 0
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

        # Check XML RT+
        And execution query rt_xml_v2 to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml_v2 to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query receipt_xml_v2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
        And through the query receipt_xml_v2 retrieve xml XML_CONTENT at position 0 and save it under the key xml_receipt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value $PSP_ID
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value $PAYMENT_TOKEN
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

    Scenario: No regression 2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        And wait 5 seconds for expiration
        And the nodoInviaRPT request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check redirect is 0 of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

    Scenario: No regression 2 (part 2)
        Given the No regression 2 (part 1) scenario executed successfully
        When job mod3CancelV1 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    Scenario: No regression 2 (part 3)
        Given the No regression 2 (part 2) scenario executed successfully
        And wait 4 seconds for expiration

        # STATI_RPT_SNAPSHOT
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3

        And the sendPaymentOutcome scenario executed successfully
        When job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of paInviaRt response is 200

    Scenario: No regression 2 (part 4)
        Given the No regression 2 (part 3) scenario executed successfully
        When job paRetryAttivaRpt triggered after 5 seconds
        Then verify the HTTP status code of paRetryAttivaRpt response is 200
    @test @lazy @dependentread
    Scenario: No regression 2 (part 5)
        Given the No regression 2 (part 4) scenario executed successfully
        And wait 5 seconds for expiration
        And the nodoInviaRPT token-v2 request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And wait 5 seconds for expiration

        # Check XML RT-
        And execution query rt_xml to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value #pspFittizio#
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value 0
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

        # Check XML RT+
        And execution query rt_xml_v2 to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml_v2 to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query receipt_xml_v2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
        And through the query receipt_xml_v2 retrieve xml XML_CONTENT at position 0 and save it under the key xml_receipt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value $PSP_ID
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value $PAYMENT_TOKEN
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

    Scenario: Test 1 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        And wait 5 seconds for expiration
        And the nodoInviaRPT request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check redirect is 0 of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

    Scenario: Test 1 (part 2)
        Given the Test 1 (part 1) scenario executed successfully
        When job mod3CancelV1 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    Scenario: Test 1 (part 3)
        Given the Test 1 (part 2) scenario executed successfully
        When job paInviaRt triggered after 4 seconds
        Then verify the HTTP status code of paInviaRt response is 200
        And wait 5 seconds for expiration

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3

    Scenario: Test 1 (part 4)
        Given the Test 1 (part 3) scenario executed successfully
        And the sendPaymentOutcome scenario executed successfully
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN_v2_no_quotes of the table POSITION_PAYMENT the parameter AMOUNT with null under macro NewMod3 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_v2 of the table RPT_ACTIVATIONS the parameter PAAATTIVARPTRESP with N under macro NewMod3 on db nodo_online
        And the nodoInviaRPT token-v2 request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
        And check description is RPT non accettabile per retry su Outcome a token scaduto of nodoInviaRPT response
        And wait 5 seconds for expiration

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column RETRY_PENDING of the table RPT_ACTIVATIONS retrived by the query payment_token_v2 on db nodo_online under macro NewMod3

        # RETRY_PA_ATTIVA_RPT
        And verify 1 record for the table RETRY_PA_ATTIVA_RPT retrived by the query token_v2 on db nodo_online under macro NewMod3

        # Check XML RT-
        And execution query rt_xml to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value #pspFittizio#
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value 0
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

    Scenario: Test 1 (part 5)
        Given the Test 1 (part 4) scenario executed successfully
        When job paRetryAttivaRpt triggered after 5 seconds
        Then verify the HTTP status code of paRetryAttivaRpt response is 200
    @test @lazy @dependentread @dependentwrite
    Scenario: Test 1 (part 6)
        Given the Test 1 (part 5) scenario executed successfully
        And wait 5 seconds for expiration
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # Check XML RT+
        And execution query rt_xml_v2 to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml_v2 to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query receipt_xml_v2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
        And through the query receipt_xml_v2 retrieve xml XML_CONTENT at position 0 and save it under the key xml_receipt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value $PSP_ID
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value $PAYMENT_TOKEN
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query payment_token_v2 on db nodo_online under macro NewMod3

        # RETRY_PA_ATTIVA_RPT
        And verify 0 record for the table RETRY_PA_ATTIVA_RPT retrived by the query token_v2 on db nodo_online under macro NewMod3

    Scenario: Test 2 (part 1)
        Given the verifyPaymentNotice scenario executed successfully
        And the activatePaymentNotice scenario executed successfully
        And wait 5 seconds for expiration
        And the nodoInviaRPT request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check redirect is 0 of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activate on db nodo_online under macro NewMod1

    Scenario: Test 2 (part 2)
        Given the Test 2 (part 1) scenario executed successfully
        When job mod3CancelV1 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    Scenario: Test 2 (part 3)
        Given the Test 2 (part 2) scenario executed successfully
        And wait 4 seconds for expiration

        # STATI_RPT_SNAPSHOT
        And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3

        And the sendPaymentOutcome scenario executed successfully
        When job paInviaRt triggered after 5 seconds
        Then verify the HTTP status code of paInviaRt response is 200

    Scenario: Test 2 (part 4)
        Given the Test 2 (part 3) scenario executed successfully
        When job paRetryAttivaRpt triggered after 5 seconds
        Then verify the HTTP status code of paRetryAttivaRpt response is 200

    Scenario: Test 2 (part 5)
        Given the Test 2 (part 4) scenario executed successfully
        And wait 5 seconds for expiration
        And updates through the query update_PAYMENT_TOKEN_v2_no_quotes of the table POSITION_PAYMENT the parameter AMOUNT with null under macro NewMod3 on db nodo_online
        And updates through the query update_PAYMENT_TOKEN_v2 of the table RPT_ACTIVATIONS the parameter PAAATTIVARPTRESP with N under macro NewMod3 on db nodo_online
        And the nodoInviaRPT token-v2 request scenario executed successfully
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
        And check description is RPT non accettabile per retry su Outcome a token scaduto of nodoInviaRPT response
        And wait 5 seconds for expiration

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column RETRY_PENDING of the table RPT_ACTIVATIONS retrived by the query payment_token_v2 on db nodo_online under macro NewMod3

        # RETRY_PA_ATTIVA_RPT
        And verify 1 record for the table RETRY_PA_ATTIVA_RPT retrived by the query token_v2 on db nodo_online under macro NewMod3

    Scenario: Test 2 (part 6)
        Given the Test 2 (part 5) scenario executed successfully
        When job paRetryAttivaRpt triggered after 0 seconds
        Then verify the HTTP status code of paRetryAttivaRpt response is 200
    @test @lazy @dependentread @dependentwrite
    Scenario: Test 2 (part 7)
        Given the Test 2 (part 6) scenario executed successfully
        And wait 5 seconds for expiration

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column RETRY_PENDING of the table RPT_ACTIVATIONS retrived by the query payment_token_v2 on db nodo_online under macro NewMod3

        # RETRY_PA_ATTIVA_RPT
        And verify 0 record for the table RETRY_PA_ATTIVA_RPT retrived by the query token_v2 on db nodo_online under macro NewMod3

        # Check XML RT-
        And execution query rt_xml to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value #pspFittizio#
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value 0
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

        And wait 5 seconds for expiration
        When EC sends sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # Check XML RT+
        And execution query rt_xml_v2 to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
        And execution query rt_xml_v2 to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
        And through the query rt_xml_v2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
        And execution query receipt_xml_v2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
        And through the query receipt_xml_v2 retrieve xml XML_CONTENT at position 0 and save it under the key xml_receipt
        And execution query payment_status_pay to get value on the table POSITION_PAYMENT, with the columns * under macro NewMod3 with db name nodo_online
        And through the query payment_status_pay retrieve param BROKER_PA_ID at position 5 and save it under the key BROKER_PA_ID
        And through the query payment_status_pay retrieve param STATION_ID at position 6 and save it under the key STATION_ID
        And through the query payment_status_pay retrieve param PAYMENT_TOKEN at position 4 and save it under the key PAYMENT_TOKEN
        And through the query payment_status_pay retrieve param NOTICE_ID at position 2 and save it under the key NOTICE_ID
        And through the query payment_status_pay retrieve param PA_FISCAL_CODE at position 1 and save it under the key PA_FISCAL_CODE
        And through the query payment_status_pay retrieve param OUTCOME at position 14 and save it under the key OUTCOME
        And through the query payment_status_pay retrieve param CREDITOR_REFERENCE_ID at position 3 and save it under the key CREDITOR_REFERENCE_ID
        And through the query payment_status_pay retrieve param AMOUNT at position 12 and save it under the key AMOUNT
        And through the query payment_status_pay retrieve param PSP_ID at position 8 and save it under the key PSP_ID
        And through the query payment_status_pay retrieve param CHANNEL_ID at position 10 and save it under the key CHANNEL_ID
        And through the query payment_status_pay retrieve param PAYMENT_CHANNEL at position 16 and save it under the key PAYMENT_CHANNEL
        And through the query payment_status_pay retrieve param PAYMENT_METHOD at position 15 and save it under the key PAYMENT_METHOD
        And through the query payment_status_pay retrieve param FEE at position 13 and save it under the key FEE
        And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
        And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
        And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
        And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
        And check value $xml_rt.codiceIdentificativoUnivoco is equal to value $PSP_ID
        And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
        And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
        And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
        And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
        And check value $xml_rt.identificativoUnivocoRiscossione is equal to value $PAYMENT_TOKEN
        And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
        And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query payment_token_v2 on db nodo_online under macro NewMod3

        # RETRY_PA_ATTIVA_RPT
        And verify 0 record for the table RETRY_PA_ATTIVA_RPT retrived by the query token_v2 on db nodo_online under macro NewMod3