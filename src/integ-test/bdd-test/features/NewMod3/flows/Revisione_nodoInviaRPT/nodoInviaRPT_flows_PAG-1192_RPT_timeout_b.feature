Feature: process tests for nodoInviaRPT [PAG-1192_RPT_timeout_b]

    Background:
        Given systems up
        And EC old version
    #START SETUP
    Scenario: Execute activatePaymentNotice request
        Given initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>#notice_number_old#</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
            <amount>10.00</amount>
            </nod:activatePaymentNoticeReq>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then check outcome is OK of activatePaymentNotice response
        And save activatePaymentNotice response in activatePaymentNotice1
        And saving activatePaymentNotice request in activatePaymentNotice1

    # test execution
    Scenario: Define RPT
        Given the Execute activatePaymentNotice request scenario executed successfully
        And RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
            <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
            </pay_i:datiSingoloVersamento>
            </pay_i:datiVersamento>
            </pay_i:RPT>
            """

    Scenario: Excecute nodoInviaRPT
        Given the Define RPT scenario executed successfully
        And initial XML nodoInviaRPT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header>
            <ppt:intestazionePPT>
            <identificativoIntermediarioPA>$activatePaymentNotice1.fiscalCode</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>$activatePaymentNotice1.fiscalCode</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$activatePaymentNotice1Response.paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#pspFittizio#</identificativoPSP>
            <identificativoIntermediarioPSP>#pspFittizio#</identificativoIntermediarioPSP>
            <identificativoCanale>#canaleFittizio#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
        Then check esito is OK of nodoInviaRPT response
        And wait 3 seconds for expiration

    Scenario: Trigger mod3Cancel
        Given the Excecute nodoInviaRPT scenario executed successfully
        When job mod3CancelV1 triggered after 15 seconds
        Then wait 15 seconds for expiration
        And verify the HTTP status code of mod3CancelV1 response is 200
    #END SETUP

    Scenario: Execute activatePaymentNotice3 request
        Given the Trigger mod3Cancel scenario executed successfully
        And  initial XML activatePaymentNotice
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
            <soapenv:Header/>
            <soapenv:Body>
            <nod:activatePaymentNoticeReq>
            <idPSP>#psp#</idPSP>
            <idBrokerPSP>#psp#</idBrokerPSP>
            <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
            <password>pwdpwdpwd</password>
            <qrCode>
            <fiscalCode>#creditor_institution_code_old#</fiscalCode>
            <noticeNumber>$activatePaymentNotice.noticeNumber</noticeNumber>
            </qrCode>
            <expirationTime>2000</expirationTime>
            <amount>11.00</amount>
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
            <esito>KO</esito>
            <delay>10000</delay>
            <datiPagamentoPA>
            <importoSingoloVersamento>2.00</importoSingoloVersamento>
            <ibanAccredito>IT96R0123454321000000012345</ibanAccredito>
            <bicAccredito>BSCTCH22</bicAccredito>
            <enteBeneficiario>
            <pag:identificativoUnivocoBeneficiario>
            <pag:tipoIdentificativoUnivoco>G</pag:tipoIdentificativoUnivoco>
            <pag:codiceIdentificativoUnivoco>11111111117</pag:codiceIdentificativoUnivoco>
            </pag:identificativoUnivocoBeneficiario>
            <pag:denominazioneBeneficiario>AZIENDA XXX</pag:denominazioneBeneficiario>
            <pag:codiceUnitOperBeneficiario>123</pag:codiceUnitOperBeneficiario>
            <pag:denomUnitOperBeneficiario>uj</pag:denomUnitOperBeneficiario>
            <pag:indirizzoBeneficiario>y</pag:indirizzoBeneficiario>
            <pag:civicoBeneficiario>j</pag:civicoBeneficiario>
            <pag:capBeneficiario>gt</pag:capBeneficiario>
            <pag:localitaBeneficiario>gw</pag:localitaBeneficiario>
            <pag:provinciaBeneficiario>ds</pag:provinciaBeneficiario>
            <pag:nazioneBeneficiario>UK</pag:nazioneBeneficiario>
            </enteBeneficiario>
            <credenzialiPagatore>i</credenzialiPagatore>
            <causaleVersamento>pagamento fotocopie pratica RPT</causaleVersamento>
            </datiPagamentoPA>
            </paaAttivaRPTRisposta>
            </ws:paaAttivaRPTRisposta>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
        When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
        Then execution query payment_status_orderbydesc to get value on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN under macro NewMod3 with db name nodo_online
        And through the query payment_status_orderbydesc retrieve param paymentToken at position 0 and save it under the key paymentToken
        And RPT generation
            """
            <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
            <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
            <pay_i:dominio>
            <pay_i:identificativoDominio>#creditor_institution_code_old#</pay_i:identificativoDominio>
            <pay_i:identificativoStazioneRichiedente>#id_station_old#</pay_i:identificativoStazioneRichiedente>
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
            <pay_i:codiceContestoPagamento>$paymentToken</pay_i:codiceContestoPagamento>
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
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$paymentToken</codiceContestoPagamento>
            </ppt:intestazionePPT>
            </soapenv:Header>
            <soapenv:Body>
            <ws:nodoInviaRPT>
            <password>pwdpwdpwd</password>
            <identificativoPSP>#pspFittizio#</identificativoPSP>
            <identificativoIntermediarioPSP>#pspFittizio#</identificativoIntermediarioPSP>
            <identificativoCanale>#canaleFittizio#</identificativoCanale>
            <tipoFirma></tipoFirma>
            <rpt>$rptAttachment</rpt>
            </ws:nodoInviaRPT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        And send, by sender EC, soap action nodoInviaRPT to nodo-dei-pagamenti
        And check outcome is KO of activatePaymentNotice response
        And check faultCode is PPT_STAZIONE_INT_PA_TIMEOUT of activatePaymentNotice response
        And check esito is OK of nodoInviaRPT response
        And save activatePaymentNotice response in activatePaymentNotice2
        And saving activatePaymentNotice request in activatePaymentNotice2

    Scenario: DB check
        Given the Execute activatePaymentNotice3 request scenario executed successfully
        When job paInviaRt triggered after 30 seconds
        And waiting 40 seconds for thread
        #RPT_ACTIVATIONS
        Then verify 0 record for the table RPT_ACTIVATIONS retrived by the query idempotency_paymentToken_2 on db nodo_online under macro NewMod3
        #POSITION_PAYMENT
        And checks the value $activatePaymentNotice1.fiscalCode of the record at column pa_fiscal_code of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice1.noticeNumber of the record at column notice_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $paymentToken of the record at column payment_token of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice1.fiscalCode of the record at column broker_pa_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value 1 of the record at column station_version of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice1.idPSP of the record at column psp_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice1.idBrokerPSP of the record at column broker_psp_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column idempotency_key of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value 10 of the record at column amount of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column fee of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column payment_method of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NA of the record at column payment_channel of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column transfer_date of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column payer_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column application_date of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column updated_timestamp of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value MOD3 of the record at column payment_type of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column carrello_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
        ##
        And checks the value $activatePaymentNotice2.fiscalCode of the record at column pa_fiscal_code of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice2.noticeNumber of the record at column notice_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $paymentToken of the record at column payment_token of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice2.fiscalCode of the record at column broker_pa_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value 1 of the record at column station_version of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice2.idPSP of the record at column psp_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice2.idBrokerPSP of the record at column broker_psp_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column idempotency_key of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value 10 of the record at column amount of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column fee of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column payment_method of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NA of the record at column payment_channel of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column updated_timestamp of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value MOD3 of the record at column payment_type of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column carrello_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value Y of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        #POSITION_ACTIVATE
        And checks the value $activatePaymentNotice1.fiscalCode of the record at column pa_fiscal_code of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice1.noticeNumber of the record at column notice_id of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value None of the record at column idempotency_key of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value $paymentToken of the record at column payment_token of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column token_valid_from of the table POSITION_ACTIVATE retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column token_valid_to of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
        And checks the value 10 of the record at column amount of the table POSITION_ACTIVATE retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
        ##
        And checks the value $activatePaymentNotice2.fiscalCode of the record at column pa_fiscal_code of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice2.noticeNumber of the record at column notice_id of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column idempotency_key of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $paymentToken of the record at column payment_token of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        #And checks the value NotNone of the record at column token_valid_from of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column token_valid_to of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        #And checks the value 10 of the record at column amount of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        #POSITION_PAYMENT_PLAN
        And checks the value $activatePaymentNotice1.fiscalCode of the record at column pa_fiscal_code of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice1.noticeNumber of the record at column notice_id of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column due_date of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column RETENTION_DATE of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value 10 of the record at column amount of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column updated_timestamp of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        #POSITION_SERVICE
        And checks the value $activatePaymentNotice1.fiscalCode of the record at column pa_fiscal_code of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value $activatePaymentNotice1.noticeNumber of the record at column notice_id of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value pagamento multibeneficiario of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value None of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        And checks the value NotNone of the record at column updated_timestamp of the table POSITION_SERVICE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
        #STATI
        #POSITION_PAYMENT_STATUS
        And checks the value PAYING,PAYING_RPT,CANCELLED of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_pay_only_act1 on db nodo_online under macro NewMod3
        And checks the value CANCELLED of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query payment_status_pay_only_act1 on db nodo_online under macro NewMod3
        #POSITION_PAYMENT_STATUS_SNAPSHOT
        And checks the value CANCELLED,CANCELLED of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status_only_act1 on db nodo_online under macro NewMod3
        #POSITION_STATUS
        And checks the value PAYING,INSERTED,INSERTED of the record at column status of the table POSITION_STATUS retrived by the query payment_status_only_act1 on db nodo_online under macro NewMod3
        #POSITION_STATUS
        And checks the value PAYING,INSERTED,INSERTED of the record at column status of the table POSITION_STATUS retrived by the query payment_status_only_act1 on db nodo_online under macro NewMod3
        #STATI_RPT
        And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column stato of the table STATI_RPT retrived by the query rt_v2 on db nodo_online under macro NewMod3

    Scenario: Execute nodoChiediCopiaRT
        Given the DB check scenario executed successfully
        And initial XML nodoChiediCopiaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediCopiaRT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$paymentToken</codiceContestoPagamento>
            </ws:nodoChiediCopiaRT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends soap nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response
    
    @check
    Scenario: Execute_nodoChiediCopiaRT2
        Given the Execute nodoChiediCopiaRT scenario executed successfully
        And initial XML nodoChiediCopiaRT
            """
            <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
            <soapenv:Header/>
            <soapenv:Body>
            <ws:nodoChiediCopiaRT>
            <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
            <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
            <password>pwdpwdpwd</password>
            <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
            <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
            <codiceContestoPagamento>$paymentToken</codiceContestoPagamento>
            </ws:nodoChiediCopiaRT>
            </soapenv:Body>
            </soapenv:Envelope>
            """
        When psp sends soap nodoChiediCopiaRT to nodo-dei-pagamenti
        Then check rt field exists in nodoChiediCopiaRT response
        And check ppt:nodoChiediCopiaRTRisposta field exists in nodoChiediCopiaRT response