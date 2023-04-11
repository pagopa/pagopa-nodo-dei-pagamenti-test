Feature: process tests for retry a token scaduto

  Background:
    Given systems up

  Scenario: Execute verifyPaymentNotice request
    Given generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr#
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
      <noticeNumber>$1noticeNumber</noticeNumber>
      </qrCode>
      </nod:verifyPaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
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
      <amount>10.00</amount>
      <dueDate>2021-12-31</dueDate>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response

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
      <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
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
      <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
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

  Scenario: Execute poller Annulli
    Given the Execute nodoInviaRPT request scenario executed successfully
    When job mod3CancelV1 triggered after 5 seconds
    Then verify the HTTP status code of mod3CancelV1 response is 200

  Scenario: trigger paInviaRT + DB check
    Given the Execute poller Annulli scenario executed successfully
    When job paInviaRt triggered after 5 seconds
    Then verify the HTTP status code of paInviaRt response is 200
    And wait 8 seconds for expiration
    And replace iuv content with $1iuv content
    And checks the value RT_ACCETTATA_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3

  Scenario: Execute sendPaymentOutcome2 request
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

  Scenario: Execute sendPaymentOutcome1 request
    Given the Execute sendPaymentOutcome2 request scenario executed successfully
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
    And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcome response
  
  @runnable
  Scenario: DB check [retry_PaOld_28]
    Given the Execute sendPaymentOutcome1 request scenario executed successfully
    And wait 5 seconds for expiration
    #STATI
    Then checks the value PAYING,INSERTED,PAID of the record at column status of the table POSITION_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value PAYING,PAYING_RPT,CANCELLED,PAID_NORPT of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column stato of the table STATI_RPT retrived by the query stati_rpt on db nodo_online under macro NewMod3
    # POSITION_PAYMENT
    And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column broker_pa_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 1 of the record at column station_version of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column psp_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idBrokerPSP of the record at column broker_psp_id of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column idempotency_key of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column amount of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 2 of the record at column fee of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value creditCard of the record at column payment_method of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NA of the record at column payment_channel of the table POSITION_PAYMENT retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
    And checks the value None of the record at column transfer_date of the table POSITION_PAYMENT retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
    And checks the value None of the record at column payer_id of the table POSITION_PAYMENT retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
    And checks the value None of the record at column application_date of the table POSITION_PAYMENT retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column updated_timestamp of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value MOD3 of the record at column payment_type of the table POSITION_PAYMENT retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column carrello_id of the table POSITION_PAYMENT retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
    ##
    And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column broker_pa_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value 1 of the record at column station_version of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idPSP of the record at column psp_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idBrokerPSP of the record at column broker_psp_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column idempotency_key of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column amount of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value 2 of the record at column fee of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value creditCard of the record at column payment_method of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value app of the record at column payment_channel of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column transfer_date of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column payer_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column application_date of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column inserted_timestamp of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column updated_timestamp of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value MOD3 of the record at column payment_type of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value None of the record at column carrello_id of the table POSITION_PAYMENT retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    # POSITION_ACTIVATE
    And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column idempotency_key of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column token_valid_from of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column token_valid_to of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column amount of the table POSITION_ACTIVATE retrived by the query payment_status on db nodo_online under macro NewMod3
    ##
    And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.idempotencyKey of the record at column idempotency_key of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column payment_token of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column token_valid_from of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column token_valid_to of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And checks the value 10 of the record at column amount of the table POSITION_ACTIVATE retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    #TOKEN_UTILITY
    And verify 1 record for the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNotice.noticeNumber of the record at column notice_id of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $iuv of the record at column creditor_reference_id of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken of the record at column token1 of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken-v2 of the record at column token2 of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And execution query payment_status_orderby to get value on the table POSITION_PAYMENT, with the columns id under macro NewMod3 with db name nodo_online
    And through the query payment_status_orderby retrieve param id at position 0 and save it under the key id0
    And execution query payment_status_orderbydesc to get value on the table POSITION_PAYMENT, with the columns id under macro NewMod3 with db name nodo_online
    And through the query payment_status_orderbydesc retrieve param id at position 0 and save it under the key id1
    And checks the value $id0 of the record at column fk_payment1 of the table TOKEN_UTILITY retrived by the query payment_status_orderby on db nodo_online under macro NewMod3
    And checks the value $id1 of the record at column fk_payment2 of the table TOKEN_UTILITY retrived by the query payment_status_orderbydesc on db nodo_online under macro NewMod3
    And execution query rt_stati to get value on the table RPT, with the columns id under macro NewMod3 with db name nodo_online
    And through the query rt_stati retrieve param id at position 0 and save it under the key fk_rptid0
    And checks the value $fk_rptid0 of the record at column fk_rpt1 of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value None of the record at column fk_rpt2 of the table TOKEN_UTILITY retrived by the query payment_status on db nodo_online under macro NewMod3