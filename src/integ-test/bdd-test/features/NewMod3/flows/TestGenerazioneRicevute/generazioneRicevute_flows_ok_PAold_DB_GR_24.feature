Feature: process tests for generazioneRicevute [DB_GR_24] 1327

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
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response
    Then checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3
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
    And verify 0 record for the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3

  @runnable
  # Payment Outcome Phase outcome KO
  Scenario: Execute sendPaymentOutcome request
    Given the Execute nodoInviaRPT request scenario executed successfully
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
    Then check outcome is OK of sendPaymentOutcome response
    
    And wait 5 seconds for expiration
    And execution query position_payment to get value on the table POSITION_RECEIPT, with the columns * under macro NewMod3 with db name nodo_online
    And through the query position_payment retrieve param receipt_id at position 1 and save it under the key receipt_id
    And through the query position_payment retrieve param notice_id at position 2 and save it under the key notice_id
    And through the query position_payment retrieve param pa_fiscal_code at position 3 and save it under the key pa_fiscal_code
    And through the query position_payment retrieve param creditor_reference_id at position 4 and save it under the key creditor_reference_id
    And through the query position_payment retrieve param payment_token at position 5 and save it under the key payment_token
    And through the query position_payment retrieve param outcome at position 6 and save it under the key outcome
    And through the query position_payment retrieve param payment_amount at position 7 and save it under the key payment_amount
    And through the query position_payment retrieve param description at position 8 and save it under the key description
    And through the query position_payment retrieve param company_name at position 9 and save it under the key company_name
    And through the query position_payment retrieve param debtor_id at position 11 and save it under the key debtor_id
    And through the query position_payment retrieve param psp_company_name at position 15 and save it under the key psp_company_name
    And through the query position_payment retrieve param psp_fiscal_code at position 13 and save it under the key psp_fiscal_code
    And through the query position_payment retrieve param psp_vat_number at position 14 and save it under the key psp_vat_number
    And through the query position_payment retrieve param channel_id at position 16 and save it under the key channel_id
    And through the query position_payment retrieve param channel_description at position 17 and save it under the key channel_description
    And through the query position_payment retrieve param payer_id at position 18 and save it under the key payer_id
    And through the query position_payment retrieve param payment_method at position 19 and save it under the key payment_method
    And through the query position_payment retrieve param fee at position 20 and save it under the key fee
    And through the query position_payment retrieve param rt_id at position 25 and save it under the key rt_id
    And through the query position_payment retrieve param fk_position_payment at position 26 and save it under the key fk_position_payment

    And checks the value $receipt_id of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $notice_id of the record at column NOTICE_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $pa_fiscal_code of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $creditor_reference_id of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $payment_token of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $payment_amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $description of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $company_name of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $debtor_id of the record at column DEBTOR_ID of the table POSITION_SERVICE retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $sendPaymentOutcome.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $psp_company_name of the record at column RAGIONE_SOCIALE of the table PSP retrived by the query psp on db nodo_cfg under macro NewMod3
    And checks the value $psp_fiscal_code of the record at column CODICE_FISCALE of the table PSP retrived by the query psp on db nodo_cfg under macro NewMod3
    #And checks the value $psp_vat_number of the record at column VAT_NUMBER of the table PSP retrived by the query psp on db nodo_cfg under macro NewMod3
    And checks the value $channel_id of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value NA of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $payer_id of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $payment_method of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $fk_position_payment of the record at column ID of the table POSITION_PAYMENT retrived by the query position_status_n on db nodo_online under macro NewMod3
    And checks the value $rt_id of the record at column ID of the table RT retrived by the query rpt_id on db nodo_online under macro NewMod3

