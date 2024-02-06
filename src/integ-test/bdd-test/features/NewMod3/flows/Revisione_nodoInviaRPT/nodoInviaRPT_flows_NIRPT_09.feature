Feature: process tests for nodoInviaRPT [REV_NIRPT_09] 1229

   Background:
      Given systems up
      And EC old version
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
         <noticeNumber>$verifyPaymentNotice.noticeNumber</noticeNumber>
         </qrCode>
         <expirationTime>4000</expirationTime>
         <amount>10.00</amount>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When psp sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And wait 4 seconds for expiration



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

   @runnable
   Scenario: Excecute nodoInviaRPT
      Given the Define RPT scenario executed successfully
      And initial XML nodoInviaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazionePPT>
         <identificativoIntermediarioPA>#creditor_institution_code_old#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
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
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check esito is OK of nodoInviaRPT response

      #DB CHECK-POSITION_PAYMENT_STATUS
      And checks the value PAYING, PAYING_RPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query payment_status on db nodo_online under macro NewMod3

      #DB CHECK-POSITION_PAYMENT_STATUS_SNAPSHOT
      And checks the value PAYING_RPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query payment_status on db nodo_online under macro NewMod3

      #DB CHECK-STATI_RPT
      And checks the value RPT_RICEVUTA_NODO, RPT_ACCETTATA_NODO, RPT_PARCHEGGIATA_NODO_MOD3 of the record at column STATO of the table STATI_RPT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3

      #DB CHECK-STATI_RPT_SNAPSHOT
      And checks the value RPT_PARCHEGGIATA_NODO_MOD3 of the record at column STATO of the table STATI_RPT_SNAPSHOT retrived by the query nodo_invia_rpt_rpt_stati on db nodo_online under macro NewMod3

      #DB CHECK-POSITION_SUBJECT
      And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DEBTOR_ID under macro NewMod3 with db name nodo_online
      And through the query payment_status retrieve param DEBTOR_ID at position 0 and save it under the key DEBTOR_ID
      And checks the value DEBTOR of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value F of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value RCCGLD09P09H501E of the record at column ENTITY_UNIQUE_IDENTIFIER_VALUE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value Gesualdo;Riccitelli of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value via del gesu of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value 11 of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value 00186 of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value Roma of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value RM of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value IT of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value gesualdo.riccitelli@poste.it of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject_2 on db nodo_online under macro NewMod3


      #DB CHECK-POSITION_SERVICE
      And execution query payment_status to get value on the table POSITION_SERVICE, with the columns DEBTOR_ID under macro NewMod3 with db name nodo_online
      And through the query payment_status retrieve param DEBTOR_ID at position 0 and save it under the key DEBTOR_ID
      And checks the value $DEBTOR_ID of the record at column ID of the table POSITION_SERVICE retrived by the query position_subject_2 on db nodo_online under macro NewMod3


      #DB CHECK-POSITION_PAYMENT
      And execution query payment_status to get value on the table POSITION_PAYMENT, with the columns RPT_ID under macro NewMod3 with db name nodo_online
      And through the query payment_status retrieve param ID at position 0 and save it under the key RPT_ID
      And checks the value $RPT_ID of the record at column ID of the table RPT retrived by the query rpt on db nodo_online under macro NewMod3

      #DB CHECK-POSITION_TRANSFER
      And execution query payment_status to get value on the table POSITION_TRANSFER, with the columns TRANSFER_CATEGORY under macro NewMod3 with db name nodo_online
      And through the query payment_status retrieve param TRANSFER_CATEGORY at position 0 and save it under the key TRANSFER_CATEGORY
      And checks the value $TRANSFER_CATEGORY of the record at column DATI_SPECIFICI_RISCOSSIONE of the table RPT_VERSAMENTI retrived by the query rpt_versamenti on db nodo_online under macro NewMod3

      #DB CHECK-RT
      And verify 0 record for the table RT retrived by the query rpt on db nodo_online under macro NewMod3

      #DB CHECK-RT_VERSAMENTI
      And verify 0 record for the table RT_VERSAMENTI retrived by the query rt_versamenti on db nodo_online under macro NewMod3

      #DB CHECK-POSITION_RECEIPT
      And verify 0 record for the table POSITION_RECEIPT retrived by the query payment_status on db nodo_online under macro NewMod3

      #DB CHECK-POSITION_RECEIPT_RECIPIENT
      And verify 0 record for the table POSITION_RECEIPT_RECIPIENT  retrived by the query payment_status on db nodo_online under macro NewMod3

      #DB CHECK-RT_XML
      And verify 0 record for the table RT_XML retrived by the query rpt on db nodo_online under macro NewMod3

      #DB CHECK-POSITION_RECEIPT_XML
      And verify 0 record for the table POSITION_RECEIPT_XML retrived by the query payment_status on db nodo_online under macro NewMod3
