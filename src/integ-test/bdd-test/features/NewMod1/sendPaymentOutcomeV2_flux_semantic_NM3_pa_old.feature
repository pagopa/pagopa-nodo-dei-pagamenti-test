Feature: flux / semantic checks for sendPaymentOutcomeV2

   Background:
      Given systems up

   Scenario: verifyPaymentNotice
      Given initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>002#iuv#</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML paVerifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <paf:paVerifyPaymentNoticeRes>
         <outcome>OK</outcome>
         <paymentList>
         <paymentOptionDescription>
         <amount>1.00</amount>
         <options>EQ</options>
         <!--Optional:-->
         <dueDate>2021-12-31</dueDate>
         <!--Optional:-->
         <detailDescription>descrizione dettagliata lato PA</detailDescription>
         <!--Optional:-->
         <allCCP>false</allCCP>
         </paymentOptionDescription>
         </paymentList>
         <!--Optional:-->
         <paymentDescription>/RFB/00202200000217527/5.00/TXT/</paymentDescription>
         <!--Optional:-->
         <fiscalCodePA>$verifyPaymentNotice.fiscalCode</fiscalCodePA>
         <!--Optional:-->
         <companyName>company PA</companyName>
         <!--Optional:-->
         <officeName>office PA</officeName>
         </paf:paVerifyPaymentNoticeRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paVerifyPaymentNotice
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   @skip
   Scenario: activatePaymentNotice
      Given initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeReq>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <idempotencyKey>#idempotency_key#</idempotencyKey>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>002$iuv</noticeNumber>
         </qrCode>
         <expirationTime>60000</expirationTime>
         <amount>10.00</amount>
         <paymentNote>responseFull</paymentNote>
         </nod:activatePaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And initial XML paGetPayment
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:paf="http://pagopa-api.pagopa.gov.it/pa/paForNode.xsd">
         <soapenv:Header />
         <soapenv:Body>
         <paf:paGetPaymentRes>
         <outcome>OK</outcome>
         <data>
         <creditorReferenceId>$iuv</creditorReferenceId>
         <paymentAmount>10.00</paymentAmount>
         <dueDate>2021-12-31</dueDate>
         <!--Optional:-->
         <retentionDate>2021-12-31T12:12:12</retentionDate>
         <!--Optional:-->
         <lastPayment>1</lastPayment>
         <description>description</description>
         <!--Optional:-->
         <companyName>company</companyName>
         <!--Optional:-->
         <officeName>office</officeName>
         <debtor>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>77777777777</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>paGetPaymentName</fullName>
         <!--Optional:-->
         <streetName>paGetPaymentStreet</streetName>
         <!--Optional:-->
         <civicNumber>paGetPayment99</civicNumber>
         <!--Optional:-->
         <postalCode>20155</postalCode>
         <!--Optional:-->
         <city>paGetPaymentCity</city>
         <!--Optional:-->
         <stateProvinceRegion>paGetPaymentState</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>paGetPayment@test.it</e-mail>
         </debtor>
         <!--Optional:-->
         <transferList>
         <!--1 to 5 repetitions:-->
         <transfer>
         <idTransfer>1</idTransfer>
         <transferAmount>10.00</transferAmount>
         <fiscalCodePA>$activatePaymentNotice.fiscalCode</fiscalCodePA>
         <IBAN>IT45R0760103200000000001016</IBAN>
         <remittanceInformation>testPaGetPayment</remittanceInformation>
         <transferCategory>paGetPaymentTest</transferCategory>
         </transfer>
         </transferList>
         <!--Optional:-->
         <metadata>
         <!--1 to 10 repetitions:-->
         <mapEntry>
         <key>1</key>
         <value>22</value>
         </mapEntry>
         </metadata>
         </data>
         </paf:paGetPaymentRes>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      And EC replies to nodo-dei-pagamenti with the paGetPayment

   @skip
   Scenario: sendPaymentOutcomeV2
      Given initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <paymentTokens>
         <paymentToken>$activatePaymentNotice_1Response.paymentToken</paymentToken>
         </paymentTokens>
         <outcome>OK</outcome>
         <!--Optional:-->
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <!--Optional:-->
         <paymentChannel>app</paymentChannel>
         <fee>2.00</fee>
         <!--Optional:-->
         <payer>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>name</fullName>
         <!--Optional:-->
         <streetName>street</streetName>
         <!--Optional:-->
         <civicNumber>civic</civicNumber>
         <!--Optional:-->
         <postalCode>postal</postalCode>
         <!--Optional:-->
         <city>city</city>
         <!--Optional:-->
         <stateProvinceRegion>state</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>prova@test.it</e-mail>
         </payer>
         <applicationDate>2021-12-12</applicationDate>
         <transferDate>2021-12-11</transferDate>
         </details>
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   @skip
   Scenario: sendPaymentOutcomeV2 with 2 paymentToken
      Given initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>#psp#</idPSP>
         <idBrokerPSP>#id_broker_psp#</idBrokerPSP>
         <idChannel>#canale_ATTIVATO_PRESSO_PSP#</idChannel>
         <password>#password#</password>
         <paymentTokens>
         <paymentToken>$activatePaymentNotice_1Response.paymentToken</paymentToken>
         <paymentToken>$activatePaymentNotice_2Response.paymentToken</paymentToken>
         </paymentTokens>
         <outcome>OK</outcome>
         <!--Optional:-->
         <details>
         <paymentMethod>creditCard</paymentMethod>
         <!--Optional:-->
         <paymentChannel>app</paymentChannel>
         <fee>2.00</fee>
         <!--Optional:-->
         <payer>
         <uniqueIdentifier>
         <entityUniqueIdentifierType>G</entityUniqueIdentifierType>
         <entityUniqueIdentifierValue>77777777777_01</entityUniqueIdentifierValue>
         </uniqueIdentifier>
         <fullName>name</fullName>
         <!--Optional:-->
         <streetName>street</streetName>
         <!--Optional:-->
         <civicNumber>civic</civicNumber>
         <!--Optional:-->
         <postalCode>postal</postalCode>
         <!--Optional:-->
         <city>city</city>
         <!--Optional:-->
         <stateProvinceRegion>state</stateProvinceRegion>
         <!--Optional:-->
         <country>IT</country>
         <!--Optional:-->
         <e-mail>prova@test.it</e-mail>
         </payer>
         <applicationDate>2021-12-12</applicationDate>
         <transferDate>2021-12-11</transferDate>
         </details>
         </nod:sendPaymentOutcomeV2Request>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   @skip
   Scenario: RPT
      Given RPT generation
         """
         <pay_i:RPT xsi:schemaLocation="http://www.digitpa.gov.it/schemas/2011/Pagamenti/ PagInf_RPT_RT_6_0_1.xsd " xmlns:pay_i="http://www.digitpa.gov.it/schemas/2011/Pagamenti/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
         <pay_i:versioneOggetto>1.0</pay_i:versioneOggetto>
         <pay_i:dominio>
         <pay_i:identificativoDominio>#creditor_institution_code#</pay_i:identificativoDominio>
         <pay_i:identificativoStazioneRichiedente>#id_station#</pay_i:identificativoStazioneRichiedente>
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
         <pay_i:importoTotaleDaVersare>$activatePaymentNotice.amount</pay_i:importoTotaleDaVersare>
         <pay_i:tipoVersamento>PO</pay_i:tipoVersamento>
         <pay_i:identificativoUnivocoVersamento>$iuv</pay_i:identificativoUnivocoVersamento>
         <pay_i:codiceContestoPagamento>$activatePaymentNotice_1Response.paymentToken</pay_i:codiceContestoPagamento>
         <pay_i:ibanAddebito>IT96R0123454321000000012345</pay_i:ibanAddebito>
         <pay_i:bicAddebito>ARTIITM1045</pay_i:bicAddebito>
         <pay_i:firmaRicevuta>0</pay_i:firmaRicevuta>
         <pay_i:datiSingoloVersamento>
         <pay_i:importoSingoloVersamento>$activatePaymentNotice.amount</pay_i:importoSingoloVersamento>
         <pay_i:commissioneCaricoPA>1.00</pay_i:commissioneCaricoPA>
         <pay_i:ibanAccredito>IT96R0123454321000000012345</pay_i:ibanAccredito>
         <pay_i:bicAccredito>ARTIITM1050</pay_i:bicAccredito>
         <pay_i:ibanAppoggio>IT96R0123454321000000012345</pay_i:ibanAppoggio>
         <pay_i:bicAppoggio>ARTIITM1050</pay_i:bicAppoggio>
         <pay_i:credenzialiPagatore>CP1.1</pay_i:credenzialiPagatore>
         <pay_i:causaleVersamento>pagamento fotocopie pratica</pay_i:causaleVersamento>
         <pay_i:datiSpecificiRiscossione>1/abc</pay_i:datiSpecificiRiscossione>
         </pay_i:datiSingoloVersamento>
         </pay_i:datiVersamento>
         </pay_i:RPT>
         """

   @skip
   Scenario: nodoInviaRPT
      Given initial XML nodoInviaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazionePPT>
         <identificativoIntermediarioPA>#id_broker_old#</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>#id_station_old#</identificativoStazioneIntermediarioPA>
         <identificativoDominio>#creditor_institution_code_old#</identificativoDominio>
         <identificativoUnivocoVersamento>$iuv</identificativoUnivocoVersamento>
         <codiceContestoPagamento>$activatePaymentNotice_1Response.paymentToken</codiceContestoPagamento>
         </ppt:intestazionePPT>
         </soapenv:Header>
         <soapenv:Body>
         <ws:nodoInviaRPT>
         <password>#password#</password>
         <identificativoPSP>15376371009</identificativoPSP>
         <identificativoIntermediarioPSP>15376371009</identificativoIntermediarioPSP>
         <identificativoCanale>15376371009_01</identificativoCanale>
         <tipoFirma></tipoFirma>
         <rpt>$rptAttachment</rpt>
         </ws:nodoInviaRPT>
         </soapenv:Body>
         </soapenv:Envelope>
         """

   # SEM_SPO_7.1

   Scenario: SEM_SPO_7.1 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_7.1 (part 2)
      Given the SEM_SPO_7.1 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And idChannel with #canale_versione_primitive_2# in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_13

   Scenario: SEM_SPO_13 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1
      And updates through the query update_activate of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
      And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online

   Scenario: SEM_SPO_13 (part 2)
      Given the SEM_SPO_13 (part 1) scenario executed successfully
      And random idempotencyKey having $activatePaymentNotice.idPSP as idPSP in activatePaymentNotice
      And EC replies to nodo-dei-pagamenti with the paGetPayment
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_2

   Scenario: SEM_SPO_13 (part 3)
      Given the SEM_SPO_13 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And paymentToken with $activatePaymentNotice_2Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: SEM_SPO_13 (part 4)
      Given the SEM_SPO_13 (part 3) scenario executed successfully
      And paymentToken with $activatePaymentNotice_1Response.paymentToken in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

   # SEM_SPO_13.1

   Scenario: SEM_SPO_13.1 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1
      And updates through the query update_activate of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with CANCELLED under macro NewMod1 on db nodo_online
      And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with INSERTED under macro NewMod1 on db nodo_online

   Scenario: SEM_SPO_13.1 (part 2)
      Given the SEM_SPO_13.1 (part 1) scenario executed successfully
      And random idempotencyKey having $activatePaymentNotice.idPSP as idPSP in activatePaymentNotice
      And EC replies to nodo-dei-pagamenti with the paGetPayment
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_2

   Scenario: SEM_SPO_13.1 (part 3)
      Given the SEM_SPO_13.1 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

   # SEM_SPO_21

   Scenario: SEM_SPO_21 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_21 (part 2)
      Given the SEM_SPO_21 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response
      And wait 5 seconds for expiration
      And checks the value PAYING,PAID of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And checks the value PAID of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And checks the value PAID_NORPT of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 2 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

   # SEM_SPO_23

   Scenario: SEM_SPO_23 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_23 (part 2)
      Given the SEM_SPO_23 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: SEM_SPO_23 (part 3)
      Given the SEM_SPO_23 (part 2) scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

   # SEM_SPO_23.1

   Scenario: SEM_SPO_23.1 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_23.1 (part 2)
      Given the SEM_SPO_23.1 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: SEM_SPO_23.1 (part 3)
      Given the SEM_SPO_23.1 (part 2) scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_ESITO_GIA_ACQUISITO of sendPaymentOutcomeV2 response
      And check description contains Esito concorde of sendPaymentOutcomeV2 response

   # SEM_SPO_28

   Scenario: SEM_SPO_28 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_28 (part 2)
      Given the SEM_SPO_28 (part 1) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And outcome with KO in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_31

   Scenario: SEM_SPO_31 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_31 (part 2)
      Given the SEM_SPO_31 (part 1) scenario executed successfully
      And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with 311011451292109621 under macro NewMod1 on db nodo_online
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_SCONOSCIUTO of sendPaymentOutcomeV2 response
      And updates through the query update_noticeidrandom of the table POSITION_STATUS_SNAPSHOT the parameter NOTICE_ID with $activatePaymentNotice.noticeNumber under macro NewMod1 on db nodo_online

   # SEM_SPO_32

   Scenario: SEM_SPO_32 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      And expirationTime with 2000 in activatePaymentNotice
      And idempotencyKey with None in activatePaymentNotice
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_32 (part 2)
      Given the SEM_SPO_32 (part 1) scenario executed successfully
      And the RPT scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When EC sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response
   @wip
   Scenario: SEM_SPO_32 (part 3)
      Given the SEM_SPO_32 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And outcome with KO in sendPaymentOutcomeV2
      When job mod3CancelV1 triggered after 3 seconds
      And PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_TOKEN_SCADUTO of sendPaymentOutcomeV2 response
      And wait 5 seconds for expiration
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
      And checks the value PAYING,PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 2 record for the table POSITION_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 3 record for the table POSITION_PAYMENT_STATUS retrived by the query select_activate on db nodo_online under macro NewMod1
      And verify 1 record for the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query select_activate on db nodo_online under macro NewMod1

   # SEM_SPO_35.1

   Scenario: SEM_SPO_35.1 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_35.1 (part 2)
      Given the SEM_SPO_35.1 (part 1) scenario executed successfully
      And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter ACTIVATION_PENDING with Y under macro NewMod1 on db nodo_online
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per stato pagamento of sendPaymentOutcomeV2 response

   # SEM_SPO_35.2

   Scenario: SEM_SPO_35.2 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_35.2 (part 2)
      Given the SEM_SPO_35.2 (part 1) scenario executed successfully
      And updates through the query update_activate of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter STATUS with PAYING under macro NewMod1 on db nodo_online
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   # SEM_SPO_36

   Scenario: SEM_SPO_36 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_36 (part 2)
      Given the SEM_SPO_36 (part 1) scenario executed successfully
      And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with PAID under macro NewMod1 on db nodo_online
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

   # SEM_SPO_36.1

   Scenario: SEM_SPO_36.1 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_36.1 (part 2)
      Given the SEM_SPO_36.1 (part 1) scenario executed successfully
      And updates through the query update_activate of the table POSITION_STATUS_SNAPSHOT the parameter STATUS with NOTIFIED under macro NewMod1 on db nodo_online
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response

   # SEM_SPO_37

   Scenario: SEM_SPO_37 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_37 (part 2)
      Given the SEM_SPO_37 (part 1) scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNotice_2

   Scenario: SEM_SPO_37 (part 3)
      Given the SEM_SPO_37 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 with 2 paymentToken scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_SEMANTICA of sendPaymentOutcomeV2 response
      And check description is Outcome non accettabile per token multipli attivati presso il PSP of sendPaymentOutcomeV2 response

   # SEM_SPO_38

   Scenario: SEM_SPO_38 (part 1)
      Given the verifyPaymentNotice scenario executed successfully
      And the activatePaymentNotice scenario executed successfully
      And idempotencyKey with None in activatePaymentNotice
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And saving activatePaymentNotice request in activatePaymentNoticeRequest1
      And save activatePaymentNotice response in activatePaymentNotice_1

   Scenario: SEM_SPO_38 (part 2)
      Given the SEM_SPO_38 (part 1) scenario executed successfully
      And random iuv in context
      And noticeNumber with 002$iuv in activatePaymentNotice
      And creditorReferenceId with $iuv in paGetPayment
      And EC replies to nodo-dei-pagamenti with the paGetPayment
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And saving activatePaymentNotice request in activatePaymentNoticeRequest2

   Scenario: SEM_SPO_38 (part 3)
      Given the SEM_SPO_38 (part 2) scenario executed successfully
      And updates through the query update_noticeid_activate2 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter NOTICE_ID with $activatePaymentNoticeRequest1.noticeNumber under macro NewMod1 on db nodo_online
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is KO of sendPaymentOutcomeV2 response
      And check faultCode is PPT_PAGAMENTO_DUPLICATO of sendPaymentOutcomeV2 response
      And updates through the query update_noticeid_activate1 of the table POSITION_PAYMENT_STATUS_SNAPSHOT the parameter NOTICE_ID with $activatePaymentNoticeRequest2.noticeNumber under macro NewMod1 on db nodo_online