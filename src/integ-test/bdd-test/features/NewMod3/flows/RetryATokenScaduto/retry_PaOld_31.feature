Feature: process tests for retry a token scaduto 1209

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:verifyPaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      </nod:verifyPaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    

  # Verify phase
  Scenario: Execute verifyPaymentNotice request
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response

  # Activate Phase
  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>$verifyPaymentNotice.idPSP</idPSP>
      <idBrokerPSP>$verifyPaymentNotice.idBrokerPSP</idBrokerPSP>
      <idChannel>$verifyPaymentNotice.idChannel</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>$verifyPaymentNotice.fiscalCode</fiscalCode>
      <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>2000</expirationTime>
      <amount>8.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And saving activatePaymentNotice request in activatePaymentNotice2
    And save activatePaymentNotice response in activatePaymentNotice2

  Scenario: Execute poller Annulli
    Given the Execute activatePaymentNotice request scenario executed successfully
    When job mod3CancelV1 triggered after 5 seconds
    Then verify the HTTP status code of mod3CancelV1 response is 200

  Scenario: Define RPT
    Given the Execute poller Annulli scenario executed successfully
    And RPT generation
      """
      <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
      <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
      <pay_i:dominio>
      <pay_i:identificativoDominio>$activatePaymentNotice.fiscalCode</pay_i:identificativoDominio>
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
      <pay_i:causaleVersamento>pagamento</pay_i:causaleVersamento>
      <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
      </pay_i:datiSingoloVersamento>
      </pay_i:datiVersamento>
      </pay_i:RPT>
      """

  Scenario: Execute nodoInviaRPT request
    Given the Define RPT scenario executed successfully
    And initial XML nodoInviaRPT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
      <ppt:intestazionePPT>
      <identificativoIntermediarioPA>$activatePaymentNotice.fiscalCode</identificativoIntermediarioPA>
      <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
      <identificativoDominio>$activatePaymentNotice.fiscalCode</identificativoDominio>
      <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
      <codiceContestoPagamento>$activatePaymentNoticeResponse.paymentToken</codiceContestoPagamento>
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
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response

  Scenario: trigger paInviaRT + DB check
    Given the Execute nodoInviaRPT request scenario executed successfully
    When job paInviaRt triggered after 3 seconds
    Then verify the HTTP status code of paInviaRt response is 200
    And wait 50 seconds for expiration
    And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3

  Scenario: Execute sendPaymentOutcome1 request
    Given the trigger paInviaRT + DB check scenario executed successfully
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>$activatePaymentNotice.idPSP</idPSP>
      <idBrokerPSP>$activatePaymentNotice.idBrokerPSP</idBrokerPSP>
      <idChannel>$activatePaymentNotice.idChannel</idChannel>
      <password>pwdpwdpwd</password>
      <paymentToken>$activatePaymentNotice2Response.paymentToken</paymentToken>
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

  Scenario: RPT2 generation
    Given the Execute sendPaymentOutcome1 request scenario executed successfully
    And wait 5 seconds for expiration
    And RPT generation
        """
        <pay_i:RPT xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd ">
        <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
        <pay_i:dominio>
        <pay_i:identificativoDominio>$activatePaymentNotice.fiscalCode</pay_i:identificativoDominio>
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
        <pay_i:codiceContestoPagamento>$activatePaymentNotice2Response.paymentToken-v2</pay_i:codiceContestoPagamento>
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
        <pay_i:causaleVersamento>pagamento</pay_i:causaleVersamento>
        <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
        </pay_i:datiSingoloVersamento>
        </pay_i:datiVersamento>
        </pay_i:RPT>
        """ 

  Scenario: Execute nodoInviaRPT1 request
    Given the RPT2 generation scenario executed successfully
    And initial XML nodoInviaRPT
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
      <soapenv:Header>
      <ppt:intestazionePPT>
      <identificativoIntermediarioPA>$activatePaymentNotice.fiscalCode</identificativoIntermediarioPA>
      <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
      <identificativoDominio>$activatePaymentNotice.fiscalCode</identificativoDominio>
      <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
      <codiceContestoPagamento>$activatePaymentNotice2Response.paymentToken-v2</codiceContestoPagamento>
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
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response

  @runnable @prova1
  Scenario: DB check [retry_PaOld_31]
    Given the Execute nodoInviaRPT1 request scenario executed successfully
    And wait 5 seconds for expiration
    #STATI
    Then checks the value PAYING,INSERTED,PAID,NOTICE_STORED of the record at column status of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value PAYING,CANCELLED_NORPT,CANCELLED,PAID_NORPT,PAID of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column stato of the table STATI_RPT retrived by the query stati_rpt on db nodo_online under macro NewMod3
    #POSITION_PAYMENT
    And checks the value $activatePaymentNotice2.fiscalCode of the record at column pa_fiscal_code of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.noticeNumber of the record at column notice_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2Response.paymentToken of the record at column payment_token of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.fiscalCode of the record at column broker_pa_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 1 of the record at column station_version of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.idPSP of the record at column psp_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.idBrokerPSP of the record at column broker_psp_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.idempotencyKey of the record at column idempotency_key of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column amount of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 2 of the record at column fee of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value creditCard of the record at column payment_method of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NA of the record at column payment_channel of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value MOD3 of the record at column payment_type of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column carrello_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    ##
    And checks the value $activatePaymentNotice2.fiscalCode of the record at column pa_fiscal_code of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.noticeNumber of the record at column notice_id of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2.idempotencyKey of the record at column idempotency_key of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice2Response.paymentToken of the record at column payment_token of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column token_valid_from of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column token_valid_to of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value 8 of the record at column amount of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    #TOKEN_UTILITY
    And verify 1 record for the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column creditor_reference_id of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column token1 of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken-v2 of the record at column token2 of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And execution query payment_status to get value on the table TOKEN_UTILITY, with the columns fk_rpt1 under macro NewMod3 with db name nodo_online
    And through the query payment_status retrieve param fk_rpt1 at position 0 and save it under the key fk_rptid1
    And checks the value $fk_rptid1 of the record at column id of the table RPT retrived by the query rt_stati on db nodo_online under macro NewMod3
    And through the query payment_status retrieve param fk_rpt2 at position 0 and save it under the key fk_rptid2
    And checks the value $fk_rptid2 of the record at column id of the table RPT retrived by the query rt_stati on db nodo_online under macro NewMod3
    #check xml rt-/+ receipt
    # Assigning XML_CONTENT query result to
    And execution query rt_xml to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
    And by the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
    # Assigning XML_CONTENT query result to
    And execution query rt_xml to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
    And by the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
    #position_payment
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
    #psp
    And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
    And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
    #checks on XML
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
    # Assigning XML_CONTENT query result to
    And execution query rt_xml_v2 to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
    And by the query rt_xml_V2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
    # Assigning XML_CONTENT query result to
    And execution query rt_xml_v2 to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
    And by the query rt_xml_V2 retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
    # Assigning XML_CONTENT query result to receipt
    And execution query receipt_xml_v2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
    And through the query receipt_xml_v2 retrieve xml XML_CONTENT at position 0 and save it under the key xml_receipt
    #position_payment
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
    #psp
    And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
    And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
    #checks on XML
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
    #Assigning XML_CONTENT query result to
    And execution query receipt_xml_v2 to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
    And through the query receipt_xml_v2 retrieve xml XML at position 0 and save it under the key xml_receipt
    #POSITION_PAYMENT
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
    #POSITION_SERVICE
    And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DESCRIPTION, COMPANY_NAME, OFFICE_NAME under macro NewMod3 with db name nodo_online
    And through the query payment_status retrieve param DESCRIPTION at position 0 and save it under the key DESCRIPTION
    And through the query payment_status retrieve param COMPANY_NAME at position 1 and save it under the key COMPANY_NAME
    And through the query payment_status retrieve param OFFICE_NAME at position 2 and save it under the key OFFICE_NAME
    #POSITION_TRANSFER
    And execution query payment_status to get value on the table POSITION_TRANSFER, with the columns TRANSFER_IDENTIFIER, AMOUNT, PA_FISCAL_CODE_SECONDARY, IBAN, REMITTANCE_INFORMATION, TRANSFER_CATEGORY under macro NewMod3 with db name nodo_online
    And through the query payment_status retrieve param TRANSFER_IDENTIFIER at position 0 and save it under the key TRANSFER_IDENTIFIER
    And through the query payment_status retrieve param AMOUNT at position 1 and save it under the key AMOUNT
    And through the query payment_status retrieve param PA_FISCAL_CODE_SECONDARY at position 2 and save it under the key PA_FISCAL_CODE_SECONDARY
    And through the query payment_status retrieve param IBAN at position 3 and save it under the key IBAN
    And through the query payment_status retrieve param REMITTANCE_INFORMATION at position 4 and save it under the key REMITTANCE_INFORMATION
    And through the query payment_status retrieve param TRANSFER_CATEGORY at position 5 and save it under the key TRANSFER_CATEGORY
    #psp
    And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, CODICE_FISCALE under macro NewMod3 with db name nodo_cfg
    And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
    And through the query psp retrieve param CODICE_FISCALE at position 1 and save it under the key CODICE_FISCALE
    #checks on XML
    And check value $xml_receipt.idPA is equal to value $PA_FISCAL_CODE
    And check value $xml_receipt.idBrokerPA is equal to value $BROKER_PA_ID
    And check value $xml_receipt.noticeNumber is equal to value $NOTICE_ID
    And check value $xml_receipt.fiscalCode is equal to value $PA_FISCAL_CODE
    And check value $xml_receipt.creditorReferenceId is equal to value $CREDITOR_REFERENCE_ID
    And check value $xml_receipt.description is equal to value $DESCRIPTION
    And check value $xml_receipt.companyName is equal to value $COMPANY_NAME
    And check value $xml_receipt.idTransfer is equal to value $TRANSFER_IDENTIFIER
    And check value $xml_receipt.fiscalCodePA is equal to value $PA_FISCAL_CODE_SECONDARY
    And check value $xml_receipt.IBAN is equal to value $IBAN
    And check value $xml_receipt.remittanceInformation is equal to value $REMITTANCE_INFORMATION
    And check value $xml_receipt.transferCategory is equal to value $TRANSFER_CATEGORY
    And check value $xml_receipt.idPSP is equal to value $PSP_ID
    And check value $xml_receipt.pspFiscalCode is equal to value $CODICE_FISCALE
    And check value $xml_receipt.PSPCompanyName is equal to value $RAGIONE_SOCIALE
    And check value $xml_receipt.idChannel is equal to value $CHANNEL_ID
