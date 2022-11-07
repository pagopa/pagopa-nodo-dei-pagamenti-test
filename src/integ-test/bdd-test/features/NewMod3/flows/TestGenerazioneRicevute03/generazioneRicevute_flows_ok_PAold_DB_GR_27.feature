Feature: process tests for generazioneRicevute [DB_GR_27]

  Background:
    Given systems up
    And EC old version


  # Verify phase
  Scenario: Execute verifyPaymentNotice request
      Given generate 1 notice number and iuv with aux digit 3, segregation code #cod_segr_old# and application code NA
      And generate 1 cart with PA #creditor_institution_code_old# and notice number $1noticeNumber
      And RPT1 generation
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
        <pay_i:identificativoUnivocoVersamento>$1iuv</pay_i:identificativoUnivocoVersamento>
        <pay_i:codiceContestoPagamento>$1carrello</pay_i:codiceContestoPagamento>
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
    And EC old version
    When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of verifyPaymentNotice response


  Scenario: Execute activatePaymentNotice request
    Given the Execute verifyPaymentNotice request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
      </qrCode>
      <expirationTime>10000</expirationTime>
      <amount>10.00</amount>
      <paymentNote>causale</paymentNote>
      </nod:activatePaymentNoticeReq>
      </soapenv:Body>
      </soapenv:Envelope>
      """
    When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
    Then check outcome is OK of activatePaymentNotice response


  # nodoInviaRPT phase
  Scenario: Execute nodoInviaRPT request
    Given the Execute activatePaymentNotice request scenario executed successfully
    And initial XML nodoInviaRPT
      """
        <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
        <soapenv:Header>
            <ppt:intestazionePPT>
                <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
                <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
                <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
                <identificativoUnivocoVersamento>$1iuv</identificativoUnivocoVersamento>
                <codiceContestoPagamento>$1carrello</codiceContestoPagamento>
            </ppt:intestazionePPT>
        </soapenv:Header>
        <soapenv:Body>
            <ws:nodoInviaRPT>
                <password>pwdpwdpwd</password>
                <identificativoPSP>#psp#</identificativoPSP>
                <identificativoIntermediarioPSP>#psp#</identificativoIntermediarioPSP>
                <identificativoCanale>#canale_ATTIVATO_PRESSO_PSP#</identificativoCanale>
                <tipoFirma></tipoFirma>
                <rpt>$rpt1Attachment</rpt>
            </ws:nodoInviaRPT>
        </soapenv:Body>
        </soapenv:Envelope>
      """
    When psp sends SOAP nodoInviaRPT to nodo-dei-pagamenti
    Then check esito is OK of nodoInviaRPT response
    And check redirect is 0 of nodoInviaRPT response


  # Payment Outcome Phase outcome OK
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
      <outcome>KO</outcome>
      <details>
      <paymentMethod>creditCard</paymentMethod>
      <paymentChannel>app</paymentChannel>
      <fee>2.00</fee>
      <payer>
      <uniqueIdentifier>
      <entityUniqueIdentifierType>F</entityUniqueIdentifierType>
      <entityUniqueIdentifierValue>#creditor_institution_code_old#</entityUniqueIdentifierValue>
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


  Scenario: Execute second activatePaymentNotice request
    Given the Execute sendPaymentOutcome request scenario executed successfully
    And initial XML activatePaymentNotice
      """
      <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
      <soapenv:Header />
      <soapenv:Body>
      <nod:activatePaymentNoticeReq>
      <idPSP>#psp#</idPSP>
      <idBrokerPSP>#psp#</idBrokerPSP>
      <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
      <password>pwdpwdpwd</password>
      <idempotencyKey>#idempotency_key#</idempotencyKey>
      <qrCode>
      <fiscalCode>#creditor_institution_code_old#</fiscalCode>
      <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
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

@runnable1
  Scenario: Execute mod3CancelV1 job
    Given the Execute second activatePaymentNotice request scenario executed successfully
    When job mod3CancelV1 triggered after 10 seconds
    Then wait 10 seconds for expiration

    #PA query
    And replace pa content with #creditor_institution_code_old# content
    And execution query get_pa_id to get value on the table PA, with the columns RAGIONE_SOCIALE under macro costanti with db name nodo_cfg
    And through the query get_pa_id retrieve param pa_ragione_sociale at position 0 and save it under the key pa_ragione_sociale

    #POSITION_SERVICE query
    And execution query position_service to get value on the table POSITION_SERVICE, with the columns * under macro NewMod3 with db name nodo_online
    And checks the value NotNone of the record at column ID of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And through the query position_service retrieve param ps_id at position 0 and save it under the key ps_id
    And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $verifyPaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value pagamento multibeneficiario of the record at column DESCRIPTION of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $pa_ragione_sociale of the record at column COMPANY_NAME of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value None of the record at column OFFICE_NAME of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SERVICE retrived by the query position_service on db nodo_online under macro NewMod3

    #POSITION_PAYMENT_PLAN query
    And execution query position_service to get value on the table POSITION_PAYMENT_PLAN, with the columns * under macro NewMod3 with db name nodo_online
    And checks the value NotNone of the record at column ID of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value #creditor_institution_code_old# of the record at column PA_FISCAL_CODE of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $verifyPaymentNotice.noticeNumber of the record at column NOTICE_ID of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value #cod_segr_old#$nodoInviaRPT.identificativoUnivocoVersamento of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column DUE_DATE of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value None of the record at column RETENTION_DATE of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value 10.00 of the record at column AMOUNT of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value Y of the record at column FLAG_FINAL_PAYMENT of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value None of the record at column METADATA of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3
    And checks the value $ps_id of the record at column FK_POSITION_SERVICE of the table POSITION_PAYMENT_PLAN retrived by the query position_service on db nodo_online under macro NewMod3

    #POSITION_RECEIPT_XML query
    And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query position_receipt_xml on db nodo_online under macro NewMod3
    
