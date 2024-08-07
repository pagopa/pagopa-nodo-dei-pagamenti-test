Feature: spostamento traduttore 954

    Background:
        Given systems up

    Scenario: activatePaymentNoticeV2
        Given initial XML activatePaymentNoticeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeV2Request>
            <idPSP>#pspEcommerce#</idPSP>
            <idBrokerPSP>#brokerEcommerce#</idBrokerPSP>
            <idChannel>#canaleEcommerce#</idChannel>
            <password>#password#</password>
            <idempotencyKey>#idempotency_key#</idempotencyKey>
            <qrCode>
            <fiscalCode>#creditor_institution_code#</fiscalCode>
            <noticeNumber>002#iuv#</noticeNumber>
            </qrCode>
            <expirationTime>60000</expirationTime>
            <amount>10.00</amount>
            <paymentNote>responseFull</paymentNote>
            </nod:activatePaymentNoticeV2Request>
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
            <importoSingoloVersamento>$activatePaymentNoticeV2.amount</importoSingoloVersamento>
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
            <importoSingoloVersamento>$activatePaymentNoticeV2.amount</importoSingoloVersamento>
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
            <fault>
            <faultCode>PAA_SEMANTICA_EXTRAXSD</faultCode>
            <faultString>errore semantico PA</faultString>
            <id>#creditor_institution_code#</id>
            <description>Errore semantico emesso dalla PA</description>
            </fault>
            <esito>KO</esito>
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
            <pay_i:importoTotaleDaVersare>$activatePaymentNoticeV2.amount</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$activatePaymentNoticeV2Response.paymentToken</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>$activatePaymentNoticeV2.amount</pay_i:importoSingoloVersamento>
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
            <codiceContestoPagamento>$activatePaymentNoticeV2Response.paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>#password#</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
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
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: nodoInviaRPT with MBD
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
            <pay_i:importoTotaleDaVersare>$activatePaymentNoticeV2.amount</pay_i:importoTotaleDaVersare>
            <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
            <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
            <pay_i:codiceContestoPagamento>$activatePaymentNoticeV2Response.paymentToken</pay_i:codiceContestoPagamento>
            <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
            <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
            <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
            <pay_i:datiSingoloVersamento>
            <pay_i:importoSingoloVersamento>10.00</pay_i:importoSingoloVersamento>
            <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
            <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
            <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
            <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
            <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            <pay_i:datiMarcaBolloDigitale>
            <pay_i:tipoBollo>01</pay_i:tipoBollo>
            <pay_i:hashDocumento>wHpFSLCGZjIvNSXxqtGbxg7275t446DRTk5ZrsdUQ6E=</pay_i:hashDocumento>
            <pay_i:provinciaResidenza>MI</pay_i:provinciaResidenza>
            </pay_i:datiMarcaBolloDigitale>
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
            <codiceContestoPagamento>$activatePaymentNoticeV2Response.paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>#password#</password>
            <identificativoPSP>#psp_AGID#</identificativoPSP>
            <identificativoIntermediarioPSP>#broker_AGID#</identificativoIntermediarioPSP>
            <identificativoCanale>#canale_AGID_BBT#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: closePaymentV2
        Given initial json v2/closepayment
            """
            {
                "paymentTokens": [
                    "$activatePaymentNoticeV2Response.paymentToken"
                ],
                "outcome": "OK",
                "idPSP": "#psp#",
                "paymentMethod": "TPAY",
                "idBrokerPSP": "#id_broker_psp#",
                "idChannel": "#canale_IMMEDIATO_MULTIBENEFICIARIO#",
                "transactionId": "#transaction_id#",
                "totalAmount": 12,
                "fee": 2,
                "timestampOperation": "2033-04-23T18:25:43Z",
                "additionalPaymentInformations": {
                    "key": "12345678"
                }
            }
            """

    Scenario: pspNotifyPayment malformata
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <outcome>OO</outcome>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: pspNotifyPayment KO
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <outcome>KO</outcome>
            <!--Optional:-->
            <fault>
            <faultCode>CANALE_SEMANTICA</faultCode>
            <faultString>Errore semantico dal psp</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>Errore dal psp</description>
            </fault>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: pspNotifyPayment irraggiungibile
        Given initial XML pspNotifyPayment
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentRes>
            <irraggiungibile/>
            </pfn:pspNotifyPaymentRes>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPayment

    Scenario: pspNotifyPaymentV2 malformata
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <outcome>OO</outcome>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    Scenario: pspNotifyPaymentV2 KO
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <outcome>KO</outcome>
            <!--Optional:-->
            <fault>
            <faultCode>CANALE_SEMANTICA</faultCode>
            <faultString>Errore semantico dal psp</faultString>
            <id>1</id>
            <!--Optional:-->
            <description>Errore dal psp</description>
            </fault>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

    Scenario: pspNotifyPaymentV2 irraggiungibile
        Given initial XML pspNotifyPaymentV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:pfn="http://pagopa-api.pagopa.gov.it/psp/pspForNode.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <pfn:pspNotifyPaymentV2Res>
            <irraggiungibile/>
            </pfn:pspNotifyPaymentV2Res>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And PSP replies to nodo-dei-pagamenti with the pspNotifyPaymentV2

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
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>postal</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>prova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
            </details>
            </nod:sendPaymentOutcomeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    Scenario: sendPaymentOutcomeV2
        Given initial XML sendPaymentOutcomeV2
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:sendPaymentOutcomeV2Request>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>#password#</password>
            <paymentTokens>
            <paymentToken>$activatePaymentNoticeV2Response.paymentToken</paymentToken>
            </paymentTokens>
            <outcome>OK</outcome>
            <!--Optional:-->
            <details>
            <paymentMethod>creditCard</paymentMethod>
            <!--Optional:-->
            <paymentChannel>app</paymentChannel>
            <fee>2.00</fee>
            <!--Optional:-->
            <payer>
            <uniqueIdentifier>
            <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
            <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
            </uniqueIdentifier>
            <fullName>name</fullName>
            <!--Optional:-->
            <streetName>street</streetName>
            <!--Optional:-->
            <civicNumber>civic</civicNumber>
            <!--Optional:-->
            <postalCode>postal</postalCode>
            <!--Optional:-->
            <city>city</city>
            <!--Optional:-->
            <stateProvinceRegion>state</stateProvinceRegion>
            <!--Optional:-->
            <country>IT</country>
            <!--Optional:-->
            <e-mail>prova@test.it</e-mail>
            </payer>
            <applicationDate>2021-12-12</applicationDate>
            <transferDate>2021-12-11</transferDate>
            </details>
            </nod:sendPaymentOutcomeV2Request>
            </soapenv:Body>
            </soapenv:Envelope>
            """

    #####################################################################################

    Scenario: Test 1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 1 (part 2)
        Given the Test 1 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 1 (part 3)
        Given the Test 1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 1 (part 4)
        Given the Test 1 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome scenario executed successfully
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

    @test 
    Scenario: Test 1 (part 5)
        Given the Test 1 (part 4) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station_old# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 1.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 1.1 (part 2)
        Given the Test 1.1 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 1.1 (part 3)
        Given the Test 1.1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 1.1 (part 4)
        Given the Test 1.1 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    @test 
    Scenario: Test 1.1 (part 5)
        Given the Test 1.1 (part 4) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_ACCEPTED,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_ACCETTATA_PSP,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 8 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station_old# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 2 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 2 (part 2)
        Given the Test 2 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 2 (part 3)
        Given the Test 2 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the pspNotifyPayment malformata scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 2 (part 4)
        Given the Test 2 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcome scenario executed successfully
        When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcome response

    @test 
    Scenario: Test 2 (part 5)
        Given the Test 2 (part 4) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 7 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station_old# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcome of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 2.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 2.1 (part 2)
        Given the Test 2.1 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 2.1 (part 3)
        Given the Test 2.1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        And the pspNotifyPaymentV2 malformata scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 2.1 (part 4)
        Given the Test 2.1 (part 3) scenario executed successfully
        And wait 5 seconds for expiration
        And the sendPaymentOutcomeV2 scenario executed successfully
        When psp sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
        Then check outcome is OK of sendPaymentOutcomeV2 response

    @test 
    Scenario: Test 2.1 (part 5)
        Given the Test 2.1 (part 4) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 8 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 7 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # POSITION_RECEIPT
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column PAYMENT_AMOUNT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column METADATA of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_RECEIPT_XML
        And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.fiscalCode of the record at column RECIPIENT_BROKER_PA_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_station_old# of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_RECEIPT_XML retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 3 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 2000
        And the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 2000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 3 (part 2)
        Given the Test 3 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 3 (part 3)
        Given the Test 3 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the pspNotifyPayment malformata scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 3 (part 4)
        Given the Test 3 (part 3) scenario executed successfully
        When job mod3CancelV1 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        And apply new restore initial configurations

    @test 
    Scenario: Test 3 (part 5)
        Given the Test 3 (part 4) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 3.1 (part 1)
        Given nodo-dei-pagamenti has config parameter default_durata_estensione_token_IO set to 2000
        And the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 2000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 3.1 (part 2)
        Given the Test 3.1 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 3.1 (part 3)
        Given the Test 3.1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        And the pspNotifyPaymentV2 malformata scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 3.1 (part 4)
        Given the Test 3.1 (part 3) scenario executed successfully
        When job mod3CancelV1 triggered after 5 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200
        And apply new restore initial configurations

    @test 
    Scenario: Test 3.1 (part 5)
        Given the Test 3.1 (part 4) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_UNKNOWN,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 4 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 4 (part 2)
        Given the Test 4 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 4 (part 3)
        Given the Test 4 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the pspNotifyPayment KO scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 4 (part 4)
        Given the Test 4 (part 3) scenario executed successfully
        When job paInviaRt triggered after 1 seconds
        And wait 5 seconds for expiration
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value PM of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 4.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 4.1 (part 2)
        Given the Test 4.1 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 4.1 (part 3)
        Given the Test 4.1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        And the pspNotifyPaymentV2 KO scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 4.1 (part 4)
        Given the Test 4.1 (part 3) scenario executed successfully
        When job paInviaRt triggered after 1 seconds
        And wait 5 seconds for expiration
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_REFUSED,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value PM of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 5 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 5 (part 2)
        Given the Test 5 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 5 (part 3)
        Given the Test 5 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And the pspNotifyPayment irraggiungibile scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_IMMEDIATO_MULTIBENEFICIARIO# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 5 (part 4)
        Given the Test 5 (part 3) scenario executed successfully
        When job paInviaRt triggered after 1 seconds
        And wait 5 seconds for expiration
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value PM of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 5.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 5.1 (part 2)
        Given the Test 5.1 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 5.1 (part 3)
        Given the Test 5.1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        And the pspNotifyPaymentV2 irraggiungibile scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value #psp# of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #id_broker_psp# of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value #canale_versione_primitive_2# of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value WISP of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value TPAY of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $transaction_id of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value v2 of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 5.1 (part 4)
        Given the Test 5.1 (part 3) scenario executed successfully
        When job paInviaRt triggered after 1 seconds
        And wait 5 seconds for expiration
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,PAYMENT_RESERVED,PAYMENT_SENT,PAYMENT_SEND_ERROR,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 6 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value PM of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 6 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 6 (part 2)
        Given the Test 6 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 6 (part 3)
        Given the Test 6 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 6 (part 4)
        Given the Test 6 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value PM of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 6.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 6.1 (part 2)
        Given the Test 6.1 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 6.1 (part 3)
        Given the Test 6.1 (part 2) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And outcome with KO in v2/closepayment
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 200
        And check outcome is OK of v2/closepayment response

        # POSITION_PAYMENT
        And checks the value $activatePaymentNoticeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column FEE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value None of the record at column CLOSE_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 6.1 (part 4)
        Given the Test 6.1 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value PM of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 7 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 2000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 7 (part 2)
        Given the Test 7 (part 1) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 7 (part 3)
        Given the Test 7 (part 2) scenario executed successfully
        When job mod3CancelV1 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    @test 
    Scenario: Test 7 (part 4)
        Given the Test 7 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 8 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 8 (part 2)
        Given the Test 8 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Node did not receive RPT yet of v2/closepayment response

    Scenario: Test 8 (part 3)
        Given the Test 8 (part 2) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    @test 
    Scenario: Test 8 (part 4)
        Given the Test 8 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED_NORPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 8.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 8.1 (part 2)
        Given the Test 8.1 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Node did not receive RPT yet of v2/closepayment response

    Scenario: Test 8.1 (part 3)
        Given the Test 8.1 (part 2) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    @test 
    Scenario: Test 8.1 (part 4)
        Given the Test 8.1 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED_NORPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 9 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 9 (part 2)
        Given the Test 9 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And outcome with KO in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Node did not receive RPT yet of v2/closepayment response

    Scenario: Test 9 (part 3)
        Given the Test 9 (part 2) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    @test 
    Scenario: Test 9 (part 4)
        Given the Test 9 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED_NORPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 9.1 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 9.1 (part 2)
        Given the Test 9.1 (part 1) scenario executed successfully
        And the closePaymentV2 scenario executed successfully
        And outcome with KO in v2/closepayment
        And idChannel with #canale_versione_primitive_2# in v2/closepayment
        When WISP sends rest POST v2/closepayment_json to nodo-dei-pagamenti
        Then verify the HTTP status code of v2/closepayment response is 422
        And check outcome is KO of v2/closepayment response
        And check description is Node did not receive RPT yet of v2/closepayment response

    Scenario: Test 9.1 (part 3)
        Given the Test 9.1 (part 2) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    @test 
    Scenario: Test 9.1 (part 4)
        Given the Test 9.1 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED_NORPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 10 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And expirationTime with 2000 in activatePaymentNoticeV2
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    Scenario: Test 10 (part 2)
        Given the Test 10 (part 1) scenario executed successfully
        When job mod3CancelV1 triggered after 3 seconds
        Then verify the HTTP status code of mod3CancelV1 response is 200

    Scenario: Test 10 (part 3)
        Given the Test 10 (part 2) scenario executed successfully
        And the nodoInviaRPT scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response

    @test 
    Scenario: Test 10 (part 4)
        Given the Test 10 (part 3) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,CANCELLED_NORPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $activatePaymentNoticeV2Response.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    @test 
    Scenario: Test 11
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the paaAttivaRPT delay scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        And execution query select_activatev2 to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activatev2 retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully
        And EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And wait 5 seconds for expiration
        And check outcome is OK of activatePaymentNoticeV2 response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value PAYING_RPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 3 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RPT_PARCHEGGIATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 12 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the paaAttivaRPT timeout scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        And execution query select_activatev2 to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activatev2 retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully
        And EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And wait 12 seconds for expiration
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of activatePaymentNoticeV2 response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 12 (part 2)
        Given the Test 12 (part 1) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT
        And checks the value Y of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $ccp of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $ccp of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 13 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the paaAttivaRPT timeout scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        And wait 12 seconds for expiration
        And execution query select_activatev2 to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activatev2 retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully
        And EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of activatePaymentNoticeV2 response

        # RPT_ACTIVATIONS
        And verify 0 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 13 (part 2)
        Given the Test 13 (part 1) scenario executed successfully
        When job paInviaRt triggered after 0 seconds
        Then verify the HTTP status code of paInviaRt response is 200

        # POSITION_PAYMENT
        And checks the value Y of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS
        And checks the value PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 6 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT
        And checks the value NotNone of the record at column ID of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $ccp of the record at column CCP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value 0.00 of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT retrived by the query iuv on db nodo_online under macro NewMod1

        # RT_XML
        And checks the value NotNone of the record at column ID of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value $ccp of the record at column CCP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value None of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 1 record for the table RT_XML retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 14 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        And the paaAttivaRPT KO scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is KO of activatePaymentNoticeV2 response
        And check faultCode is PPT_ERRORE_EMESSO_DA_PAA of activatePaymentNoticeV2 response

    @test 
    Scenario: Test 14 (part 2)
        Given the Test 14 (part 1) scenario executed successfully
        And execution query select_activatev2 to get value on the table RPT_ACTIVATIONS, with the columns PAYMENT_TOKEN under macro NewMod1 with db name nodo_online
        And through the query select_activatev2 retrieve param ccp at position 0 and save it under the key ccp
        And the nodoInviaRPT with ccp from DB scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_SEMANTICA of nodoInviaRPT response
        And check description is RPT non attivata of nodoInviaRPT response

        # RPT_ACTIVATIONS
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_RIFIUTATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1
        And verify 2 record for the table STATI_RPT retrived by the query iuv on db nodo_online under macro NewMod1

        # STATI_RPT_SNAPSHOT
        And verify 0 record for the table STATI_RPT_SNAPSHOT retrived by the query iuv on db nodo_online under macro NewMod1

    #####################################################################################

    Scenario: Test 15 (part 1)
        Given the activatePaymentNoticeV2 scenario executed successfully
        When psp sends SOAP activatePaymentNoticeV2 to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNoticeV2 response

        # POSITION_PAYMENT
        And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value Y of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table POSITION_PAYMENT retrived by the query select_activatev2 on db nodo_online under macro NewMod1

        # RPT_ACTIVATIONS
        And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1
        And verify 1 record for the table RPT_ACTIVATIONS retrived by the query select_activatev2 on db nodo_online under macro NewMod1

    @test 
    Scenario: Test 15 (part 2)
        Given the Test 15 (part 1) scenario executed successfully
        And the nodoInviaRPT with MBD scenario executed successfully
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is KO of nodoInviaRPT response
        And check faultCode is PPT_SEMANTICA of nodoInviaRPT response