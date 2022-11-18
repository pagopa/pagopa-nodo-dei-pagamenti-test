Feature: process tests for retryAtokenScaduto

  Background:
    Given systems up

  Scenario: Execute verifyPaymentNotice request
    Given nodo-dei-pagamenti has config parameter scheduler.jobName_paInviaRt.enabled set to false
    And generate 1 notice number and iuv with aux digit 0, segregation code NA and application code #cod_segr#
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
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>$1noticeNumber</noticeNumber>
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
      <identificativoPSP>15376371009</identificativoPSP>
      <identificativoIntermediarioPSP>15376371009</identificativoIntermediarioPSP>
      <identificativoCanale>15376371009_01</identificativoCanale>
      <tipoFirma></tipoFirma>
      <rpt>$rptAttachment</rpt>
      </ws:nodoInviaRPT>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    And verify 0 record for the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3

  Scenario: Execute poller Annulli
    Given the Execute nodoInviaRPT request scenario executed successfully
    When job mod3CancelV1 triggered after 5 seconds
    Then verify the HTTP status code of mod3CancelV1 response is 200
    And wait 5 seconds for expiration 
    And replace iuv content with $1iuv content
    And checks the value RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3

  # Payment Outcome Phase outcome OK
  Scenario: Execute sendPaymentOutcome request
    Given the DB check scenario executed successfully
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

  Scenario: check position_payment_status
    Given the Execute sendPaymentOutcome request scenario executed successfully
    And wait 5 seconds for expiration
    Then checks the value PAYING,PAYING_RPT,CANCELLED,PAID_NORPT of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
    And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_ANNULLATA_NODO,RT_GENERATA_NODO of the record at column STATO of the table STATI_RPT retrived by the query stati_rpt on db nodo_online under macro NewMod3
    And checks the value $1iuv of the record at column CREDITOR_REFERENCE_ID of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken-v2 of the record at column PAYMENT_TOKEN of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value N of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    #RETRY_PA_ATTIVA_RPT
    And checks the value $activatePaymentNotice.fiscalCode of the record at column pa_fiscal_code of the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken-v2 of the record at column token of the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    And checks the value 0 of the record at column retry of the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column inserted_timestamp of the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column updated_timestamp of the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    And checks the value $1iuv of the record at column iuv of the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    And checks the value N of the record at column ready of the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    #RETRY_PA_INVIA_RT
    And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query retry_pa_invia_rt on db nodo_online under macro NewMod3
    And generic update through the query param_update_generic_where_condition of the table POSITION_ACTIVATE the parameter AMOUNT = '3', with where condition PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' AND NOTICE_ID='$activatePaymentNotice.noticeNumber' AND PAYMENT_TOKEN='$activatePaymentNoticeResponse.paymentToken-v2' under macro update_query on db nodo_online
    And nodo-dei-pagamenti has config parameter scheduler.jobName_paInviaRt.enabled set to true

  Scenario: Execute paInviaRT
    Given the check position_payment_status scenario executed successfully
    When job paInviaRt triggered after 20 seconds
    Then verify the HTTP status code of paInviaRt response is 200
    And wait 70 seconds for expiration
    And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_ANNULLATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA  of the record at column STATO of the table STATI_RPT retrived by the query stati_rpt on db nodo_online under macro NewMod3
    And checks the value $1iuv of the record at column CREDITOR_REFERENCE_ID of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value $activatePaymentNoticeResponse.paymentToken-v2 of the record at column PAYMENT_TOKEN of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value N of the record at column NODOINVIARPTREQ of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value N of the record at column PAAATTIVARPTRESP of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RPT_ACTIVATIONS retrived by the query rpt_activision-v2 on db nodo_online under macro NewMod3

  @runnable
  Scenario: Execute paRetryAttivaRpt
    Given the Execute paInviaRT scenario executed successfully
    When job paRetryAttivaRpt triggered after 5 seconds
    Then verify the HTTP status code of paRetryAttivaRpt response is 200
    And wait 10 seconds for expiration
    And generic update through the query param_update_generic_where_condition of the table POSITION_ACTIVATE the parameter AMOUNT = '10', with where condition PA_FISCAL_CODE='$activatePaymentNotice.fiscalCode' AND NOTICE_ID='$activatePaymentNotice.noticeNumber' AND PAYMENT_TOKEN='$activatePaymentNoticeResponse.paymentToken-v2' under macro update_query on db nodo_online
    #RETRY_PA_ATTIVA_RPT
    And verify 0 record for the table RETRY_PA_ATTIVA_RPT retrived by the query retry_pa_invia_rpt on db nodo_online under macro NewMod3
    #RETRY_PA_INVIA_RT
    And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query retry_pa_invia_rt on db nodo_online under macro NewMod3