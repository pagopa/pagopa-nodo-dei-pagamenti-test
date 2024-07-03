Feature: process tests for retry a token scaduto (retry_PaOd_24) 1201

  Background:
    Given systems up
    And initial XML verifyPaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
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
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>#notice_number_old#</noticeNumber>
      </qrCode>
      <expirationTime>2000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value Y of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3

  Scenario: Execute Poller Annulli
    Given the Execute activatePaymentNotice request scenario executed successfully
    When job mod3CancelV1 triggered after 5 seconds
    Then verify the HTTP status code of mod3CancelV1 response is 200

  Scenario: Execute paInviaRT
    Given the Execute Poller Annulli scenario executed successfully
    When job paInviaRt triggered after 5 seconds
    Then verify the HTTP status code of paInviaRt response is 200

  # Payment Outcome Phase outcome KO
  Scenario: Execute sendPaymentOutcome request
    Given the Execute Poller Annulli scenario executed successfully
    And PSP waits 5 seconds for expiration
    And initial XML sendPaymentOutcome
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:sendPaymentOutcomeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
      <outcome>OK</outcome>
      <details>
      <paymentMethod>creditCard</paymentMethod>
      <paymentChannel>app</paymentChannel>
      <fee>2.00</fee>
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>RCCGLD09P09H502E</entityUniqueIdentifierValue>
      </uniqueIdentifier>
      <fullName>Gesualdo;Riccitelli</fullName>
      <streetName>via del gesu</streetName>
      <civicNumber>11</civicNumber>
      <postalCode>00186</postalCode>
      <city>Roma</city>
      <stateProvinceRegion>RM</stateProvinceRegion>
      <country>IT</country>
      <e-mail>gesualdo.riccitelli@poste.it</e-mail>
      </payer>
      <applicationDate>2021-12-12</applicationDate>
      <transferDate>2021-12-11</transferDate>
      </details>
      </nod:sendPaymentOutcomeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP sendPaymentOutcome to nodo-dei-pagamenti
    Then check outcome is KO of sendPaymentOutcome response
    And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response

  Scenario: Define RPT
    Given the Execute sendPaymentOutcome request scenario executed successfully
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
      <pay_i:causaleVersamento>pagamento fotocopie pratica RPT</pay_i:causaleVersamento>
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
    #  When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti using the token of the activate phase
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    And check redirect is 0 of nodoInviaRPT response


  @runnable
  # test execution
  Scenario: Execution test rety_PaOld_24
    Given the Execute nodoInviaRPT request scenario executed successfully
    And wait 10 seconds for expiration
    Then execution query payment_status to get value on the table POSITION_PAYMENT, with the columns FK_PAYMENT_PLAN,RPT_ID,AMOUNT,CHANNEL_ID,PAYMENT_CHANNEL,PAYER_ID,PAYMENT_METHOD,FEE,INSERTED_TIMESTAMP,APPLICATION_DATE,TRANSFER_DATE under macro NewMod3 with db name nodo_online
    And execution query rpt_id to get value on the table RPT, with the columns ID under macro NewMod3 with db name nodo_online
    And execution query position_receipt to get value on the table POSITION_PAYMENT_PLAN, with the columns ID,METADATA under macro NewMod3 with db name nodo_online
    And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value #id_broker_old# of the record at column BROKER_PA_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value #id_station_old# of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3  
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And with the query payment_status check assert beetwen elem FK_PAYMENT_PLAN in position 0 and elem ID with position 0 of the query position_receipt
    And checks the value PAYING,CANCELLED_NORPT,PAID_NORPT,PAID,NOTICE_GENERATED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And verify 0 record for the table RPT_ACTIVATIONS retrived by the query payment_token_v2 on db nodo_online under macro NewMod3
    And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query stati_rpt on db nodo_online under macro NewMod3
    And checks the value PAYING,INSERTED,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column DUE_DATE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value OK of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
    And execution query position_service to get value on the table POSITION_SERVICE, with the columns DESCRIPTION,COMPANY_NAME,OFFICE_NAME,DEBTOR_ID under macro NewMod3 with db name nodo_online
    And execution query psp to get value on the table PSP, with the columns CODICE_FISCALE,VAT_NUMBER,RAGIONE_SOCIALE under macro NewMod3 with db name nodo_cfg
    And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns PSP_FISCAL_CODE,PSP_VAT_NUMBER,PSP_COMPANY_NAME under macro NewMod3 with db name nodo_online
    And with the query position_receipt check assert beetwen elem PSP_FISCAL_CODE in position 0 and elem CODICE_FISCALE with position 0 of the query psp
    And with the query position_receipt check assert beetwen elem PSP_VAT_NUMBER in position 1 and elem VAT_NUMBER with position 1 of the query psp
    And with the query position_receipt check assert beetwen elem PSP_COMPANY_NAME in position 2 and elem RAGIONE_SOCIALE with position 2 of the query psp
    And execution query position_receipt to get value on the table POSITION_RECEIPT, with the columns DESCRIPTION,COMPANY_NAME,OFFICE_NAME,DEBTOR_ID under macro NewMod3 with db name nodo_online
    And with the query position_receipt check assert beetwen elem DESCRIPTION in position 0 and elem DESCRIPTION with position 0 of the query position_service
    And with the query position_receipt check assert beetwen elem COMPANY_NAME in position 1 and elem COMPANY_NAME with position 1 of the query position_service
    And with the query position_receipt check assert beetwen elem OFFICE_NAME in position 2 and elem OFFICE_NAME with position 2 of the query position_service
    And with the query position_receipt check assert beetwen elem DEBTOR_ID in position 3 and elem DEBTOR_ID with position 3 of the query position_service
    And execution query psp to get value on the table PSP, with the columns RAGIONE_SOCIALE, ID_PSP under macro NewMod3 with db name nodo_cfg
    And through the query psp retrieve param RAGIONE_SOCIALE at position 0 and save it under the key RAGIONE_SOCIALE
    And through the query psp retrieve param PSP_ID at position 1 and save it under the key PSP_ID
    # Assigning XML_CONTENT query result to
    And execution query rt_xml to get value on the table RT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
    And by the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rt
    # Assigning XML_CONTENT query result to
    And execution query rt_xml to get value on the table RPT_XML, with the columns XML_CONTENT under macro NewMod3 with db name nodo_online
    And by the query rt_xml retrieve xml_no_decode XML_CONTENT at position 0 and save it under the key xml_rpt
    # Assigning XML_CONTENT query result to receipt
    And execution query receipt_xml to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
    And through the query receipt_xml retrieve xml XML at position 0 and save it under the key xml_receipt
    #checks on XML
    And check value $xml_rt.identificativoDominio is equal to value $xml_rpt.identificativoDominio
    And check value $xml_rt.riferimentoMessaggioRichiesta is equal to value $xml_rpt.identificativoMessaggioRichiesta
    And check value $xml_rt.codiceIdentificativoUnivoco is equal to value $PSP_ID
    And check value $xml_rt.denominazioneBeneficiario is equal to value $xml_rpt.denominazioneBeneficiario
    And check value $xml_rt.anagraficaPagatore is equal to value $xml_rpt.anagraficaPagatore
    And check value $xml_rt.identificativoUnivocoVersamento is equal to value $xml_rpt.identificativoUnivocoVersamento
    And check value $xml_rt.CodiceContestoPagamento is equal to value $xml_rpt.codiceContestoPagamento
    And check value $xml_rt.identificativoUnivocoRiscossione is equal to value $activatePaymentNoticeResponse.paymentToken
    And check value $xml_rt.causaleVersamento is equal to value $xml_rpt.causaleVersamento
    And check value $xml_rt.datiSpecificiRiscossione is equal to value $xml_rpt.datiSpecificiRiscossione
    #Assigning XML_CONTENT query result to
    And execution query receipt_xml to get value on the table POSITION_RECEIPT_XML, with the columns XML under macro NewMod3 with db name nodo_online
    And through the query receipt_xml retrieve xml XML at position 0 and save it under the key xml_receipt
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
    # TOKEN_UTILITY
    And verify 0 record for the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3

