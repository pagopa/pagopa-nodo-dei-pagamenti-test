Feature: process tests for retryAtokenScaduto

  Background:
    Given systems up
    And nodo-dei-pagamenti has config parameter scheduler.jobName_paInviaRt.enabled set to false
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
  #And verify 0 record for the table RPT_ACTIVATIONS retrived by the query rpt_activision on db nodo_online under macro NewMod3

  Scenario: Execute poller Annulli
    Given the Execute nodoInviaRPT request scenario executed successfully
    When job mod3CancelV1 triggered after 4 seconds
    Then verify the HTTP status code of mod3CancelV1 response is 200

  Scenario: Execute paInviaRT
    Given the Execute poller Annulli scenario executed successfully
    # And initial XML paaInviaRT
    #   """
    #   <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ws="http://ws.pagamenti.telematici.gov/">
    #   <soapenv:Header/>
    #   <soapenv:Body>
    #   <ws:paaInviaRTRisposta>
    #   <paaInviaRTRisposta>
    #   <!--Optional:-->
    #   <fault>
    #   <faultCode>PAA_SINTASSI_XSD</faultCode>
    #   <faultString>RT non valida rispetto XSD</faultString>
    #   <id>mockPa</id>
    #   <!--Optional:-->
    #   <description>test</description>
    #   </fault>
    #   <!--Optional:-->
    #   <esito>KO</esito>
    #   </paaInviaRTRisposta>
    #   </ws:paaInviaRTRisposta>
    #   </soapenv:Body>
    #   </soapenv:Envelope>
    #   """
    # And EC replies to nodo-dei-pagamenti with the paaInviaRT
    When job paInviaRt triggered after 5 seconds
    Then verify the HTTP status code of paInviaRt response is 200

  # Scenario: DB check
  #   Given the Execute paInviaRT scenario executed successfully
  #   Then checks the value RT_ESITO_SCONOSCIUTO_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3

  @prova
  # Payment Outcome Phase outcome OK
  Scenario: Execute sendPaymentOutcome request
    Given the Execute paInviaRT scenario executed successfully
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
    Then check outcome is OK of sendPaymentOutcome response
  #And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcome response

  Scenario: Execute activatePaymentNotice3 request
    Given the Trigger paInviaRT scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header/>
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>$activatePaymentNotice.idPSP</idPSP>
      <idBrokerPSP>$activatePaymentNotice.idBrokerPSP</idBrokerPSP>
      <idChannel>$activatePaymentNotice.idChannel</idChannel>
      <password>pwdpwdpwd</password>
      <qrCode>
      <fiscalCode>$activatePaymentNotice.fiscalCode</fiscalCode>
      <noticeNumber>$activatePaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <amount>7.00</amount>
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
      <fault>
      <faultCode>PAA_SINTASSI_EXTRAXSD</faultCode>
      <faultString>errore sintattico PA</faultString>
      <id>#creditor_institution_code_old#</id>
      <description>Errore sintattico emesso dalla PA</description>
      </fault>
      <esito>KO</esito>
      </paaAttivaRPTRisposta>
      </ws:paaAttivaRPTRisposta>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    And EC replies to nodo-dei-pagamenti with the paaAttivaRPT
    When psp sends soap activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is KO of activatePaymentNotice response

    And execution query payment_status_orderbydesc to get value on the table POSITION_ACTIVATE, with the columns PAYMENT_TOKEN under macro NewMod3 with db name nodo_online
    And through the query payment_status_orderbydesc retrieve param paymentToken at position 0 and save it under the key paymentToken


  # test execution
  Scenario: Define RPT3
    Given the Execute activatePaymentNotice3 request scenario executed successfully
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
  @prova
  Scenario: Excecute nodoInviaRPT3
    Given the Define RPT3 scenario executed successfully
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
      <identificativoPSP>15376371009</identificativoPSP>
      <identificativoIntermediarioPSP>15376371009</identificativoIntermediarioPSP>
      <identificativoCanale>15376371009_01</identificativoCanale>
      <tipoFirma></tipoFirma>
      <rpt>$rptAttachment</rpt>
      </ws:nodoInviaRPT>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is KO of nodoInviaRPT response
    And check faultCode is PPT_SEMANTICA of nodoInviaRPT response

# @prova
# Scenario: check position_payment_status
#   Given the Execute sendPaymentOutcome request scenario executed successfully
#   Then checks the value PAYING,PAYING_RPT,CANCELLED,PAID_NORPT of the record at column status of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3
#   And checks the value CANCELLED,PAID_NORPT of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro nodo_online
#   And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_ANNULLATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ESITO_SCONOSCIUTOPA of the record at column status of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query on db nodo_online under macro nodo_online
#   And checks the value RT_ESITO_SCONOSCIUTO_PA of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query stati_rpt on db nodo_online under macro NewMod3
#   And verify 0 record for the table RETRY_PA_INVIA_RT retrived by the query stati_rpt on db nodo_online under macro NewMod3


#   #POSITION_PAYMENT
#   And execution query position_receipt to get value on the table POSITION_PAYMENT, with the columns payment_token,notice_id,pa_fiscal_code,creditor_reference_id,outcome,amount,channel_id,payment_channel,payer_id,payment_method,fee,application_date under macro NewMod3 with db name nodo_online
#   And through the query position_receipt retrieve param payment_token at position 0 and save it under the key payment_token
#   And through the query position_receipt retrieve param notice_id at position 1 and save it under the key notice_id
#   And through the query position_receipt retrieve param pa_fiscal_code at position 2 and save it under the key pa_fiscal_code
#   And through the query position_receipt retrieve param creditor_reference_id at position 3 and save it under the key creditor_reference_id
#   And through the query position_receipt retrieve param outcome at position 4 and save it under the key outcome
#   And through the query position_receipt retrieve param amount at position 5 and save it under the key amount
#   And through the query position_receipt retrieve param channel_id at position 6 and save it under the key channel_id
#   And through the query position_receipt retrieve param payment_channel at position 7 and save it under the key payment_channel
#   And through the query position_receipt retrieve param payer_id at position 8 and save it under the key payer_id
#   And through the query position_receipt retrieve param payment_method at position 9 and save it under the key payment_method
#   And through the query position_receipt retrieve param fee at position 10 and save it under the key fee
#   And through the query position_receipt retrieve param application_date at position 11 and save it under the key application_date
#   #POSITION_SERVICE
#   And execution query position_receipt to get value on the table POSITION_SERVICE, with the columns description,company_name,office_name,debtor_id under macro NewMod3 with db name nodo_online
#   And through the query position_receipt retrieve param description at position 0 and save it under the key description
#   And through the query position_receipt retrieve param company_name at position 1 and save it under the key company_name
#   And through the query position_receipt retrieve param office_name at position 2 and save it under the key office_name
#   And through the query position_receipt retrieve param debtor_id at position 3 and save it under the key debtor_id
#   #PSP
#   And execution query psp to get value on the table PSP, with the columns ragione_sociale,codice_fiscale,vat_number under macro NewMod3 with db name nodo_cfg
#   And through the query psp retrieve param ragione_sociale at position 0 and save it under the key ragione_sociale
#   And through the query psp retrieve param codice_fiscale at position 1 and save it under the key codice_fiscale
#   And through the query psp retrieve param vat_number at position 2 and save it under the key vat_number
#   #DB-CHECK
#   And checks the value $payment_token of the record at column receipt_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $notice_id of the record at column notice_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $pa_fiscal_code of the record at column pa_fiscal_code of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $creditor_reference_id of the record at column creditor_reference_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $payment_token of the record at column payment_token of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $outcome of the record at column outcome of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $amount of the record at column payment_amount of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $description of the record at column description of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $company_name of the record at column company_name of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $office_name of the record at column office_name of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $debtor_id of the record at column debtor_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value #psp# of the record at column psp_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $ragione_sociale of the record at column psp_company_name of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $codice_fiscale of the record at column psp_fiscal_code of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $vat_number of the record at column psp_vat_number of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $channel_id of the record at column channel_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $payment_channel of the record at column channel_description of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $payer_id of the record at column payer_id of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $payment_method of the record at column payment_method of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value $fee of the record at column fee of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value NotNone of the record at column payment_date_time of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value NotNone of the record at column transfer_date of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
#   And checks the value None of the record at column metadata of the table POSITION_RECEIPT retrived by the query position_receipt on db nodo_online under macro NewMod3
