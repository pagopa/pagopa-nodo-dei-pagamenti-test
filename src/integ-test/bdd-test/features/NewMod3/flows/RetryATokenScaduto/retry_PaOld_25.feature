Feature: process tests for retry a token scaduto

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
    And EC old version

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


  Scenario: Define RPT
    Given the Execute activatePaymentNotice request scenario executed successfully
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
  
  # Payment Outcome Phase outcome KO
  Scenario: Execute sendPaymentOutcome request
    Given the Execute nodoInviaRPT request scenario executed successfully
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
      <entityUniqueIdentifierValue>RCCGLD09P09H501E</entityUniqueIdentifierValue>
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
    Then check outcome is OK of sendPaymentOutcome response

  Scenario: Execute Poller Annulli
    Given the Execute sendPaymentOutcome request scenario executed successfully
    When job mod3CancelV1 triggered after 5 seconds
    Then verify the HTTP status code of mod3CancelV1 response is 200

  Scenario: Execute paaInviaRT
    Given the Execute Poller Annulli scenario executed successfully
    When job paInviaRt triggered after 0 seconds
    Then verify the HTTP status code of paInviaRt response is 200

  @runnable @lazy @dependentread
  # test execution
  Scenario: Execution test rety_PaOld_25
    Given the Execute paaInviaRT scenario executed successfully
    Then execution query payment_status to get value on the table POSITION_PAYMENT, with the columns FK_PAYMENT_PLAN,RPT_ID,AMOUNT,CHANNEL_ID,PAYMENT_CHANNEL,PAYER_ID,PAYMENT_METHOD,FEE,INSERTED_TIMESTAMP,APPLICATION_DATE,TRANSFER_DATE under macro NewMod3 with db name nodo_online
    And execution query rpt_id to get value on the table RPT, with the columns ID,ID_MSG_RICH under macro NewMod3 with db name nodo_online
    And execution query position_receipt to get value on the table POSITION_PAYMENT_PLAN, with the columns ID,METADATA under macro NewMod3 with db name nodo_online
    #position_status
    And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    #position_payment
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
    And checks the value 2 of the record at column FEE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value OK of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value creditCard of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value app of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value MOD3 of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And with the query payment_status check assert beetwen elem FK_PAYMENT_PLAN in position 0 and elem ID with position 0 of the query position_receipt
    And with the query payment_status check assert beetwen elem RPT_ID in position 1 and elem ID with position 0 of the query rpt_id
    #position_payment_status
    And checks the value PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    #stati_rpt
    And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT retrived by the query stati_rpt on db nodo_online under macro NewMod3
    #rt
    And execution query rt_stati to get value on the table RT, with the columns ID_RICHIESTA,SOMMA_VERSAMENTI,ID under macro NewMod3 with db name nodo_online
    And checks the value NotNone of the record at column ID of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column CCP of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column IDENT_DOMINIO of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column IUV of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value #canaleFittizio# of the record at column CANALE of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3
    And with the query rt_stati check assert beetwen elem ID_RICHIESTA in position 0 and elem ID_MSG_RICH with position 1 of the query rpt_id
    And with the query rt_stati check assert beetwen elem SOMMA_VERSAMENTI in position 1 and elem AMOUNT with position 2 of the query payment_status
    #position_receipt
    And execution query position_receipt_n to get value on the table POSITION_RECEIPT, with the columns PAYMENT_AMOUNT,DESCRIPTION,COMPANY_NAME,OFFICE_NAME,DEBTOR_ID,PSP_FISCAL_CODE,PSP_VAT_NUMBER,PSP_COMPANY_NAME,CHANNEL_ID,CHANNEL_DESCRIPTION,PAYER_ID,PAYMENT_METHOD,FEE,PAYMENT_DATE_TIME,APPLICATION_DATE,TRANSFER_DATE,METADATA,RT_ID,FK_POSITION_PAYMENT under macro NewMod3 with db name nodo_online
    And execution query position_status_n to get value on the table POSITION_PAYMENT, with the columns AMOUNT,CHANNEL_ID,PAYMENT_CHANNEL,PAYER_ID,PAYMENT_METHOD,FEE,INSERTED_TIMESTAMP,APPLICATION_DATE,TRANSFER_DATE,ID under macro NewMod3 with db name nodo_online
    And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DESCRIPTION,COMPANY_NAME,OFFICE_NAME,DEBTOR_ID under macro NewMod3 with db name nodo_online
    And execution query psp to get value on the table PSP, with the columns CODICE_FISCALE,VAT_NUMBER,RAGIONE_SOCIALE under macro NewMod3 with db name nodo_cfg
    And with the query position_receipt_n check assert beetwen elem PAYMENT_AMOUNT in position 0 and elem AMOUNT with position 0 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem channel_id in position 8 and elem channel_id with position 1 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem CHANNEL_DESCRIPTION in position 9 and elem PAYMENT_CHANNEL with position 2 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem PAYER_ID in position 10 and elem PAYER_ID with position 3 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem PAYMENT_METHOD in position 11 and elem PAYMENT_METHOD with position 4 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem fee in position 12 and elem fee with position 5 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem payement_date_time in position 13 and elem fee with position 6 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem application_date in position 14 and elem application_date with position 7 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem transfer_date in position 15 and elem transfer_date with position 8 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem FK_POSITION_PAYMENT in position 18 and elem id with position 9 of the query position_status_n
    And with the query position_receipt_n check assert beetwen elem description in position 1 and elem description with position 0 of the query payment_status
    And with the query position_receipt_n check assert beetwen elem company_name in position 2 and elem company_name with position 1 of the query payment_status
    And with the query position_receipt_n check assert beetwen elem office_name in position 3 and elem office_name with position 2 of the query payment_status
    And with the query position_receipt_n check assert beetwen elem debtor_id in position 4 and elem debtor_id with position 3 of the query payment_status
    And with the query position_receipt_n check assert beetwen elem psp_fiscal_code in position 5 and elem codice_fiscale with position 0 of the query psp
    And with the query position_receipt_n check assert beetwen elem vat_number in position 6 and elem vat_number with position 1 of the query psp
    And with the query position_receipt_n check assert beetwen elem company_name in position 7 and elem ragione_sociale with position 2 of the query psp
    And with the query position_receipt_n check assert beetwen elem metadata in position 16 and elem metadata with position 1 of the query position_receipt
    And with the query position_receipt_n check assert beetwen elem rt_id in position 17 and elem id with position 2 of the query rt_stati
    #position_activate
    And checks the value NotNone of the record at column ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column PA_FISCAL_CODE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column PSP_ID of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    #assert IDEMPOTENCY_KEY10 == psp+'_'+context.expand('${#TestCase#idempotenza}')
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column AMOUNT of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column TOKEN_VALID_FROM of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column TOKEN_VALID_TO of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column DUE_DATE of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And RTP XML check




