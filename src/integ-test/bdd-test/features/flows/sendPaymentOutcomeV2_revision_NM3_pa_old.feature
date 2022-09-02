Feature: revision checks for sendPaymentOutcomeV2

   Background:
      Given systems up
      And initial XML verifyPaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:verifyPaymentNoticeReq>
         <idPSP>70000000001</idPSP>
         <idBrokerPSP>70000000001</idBrokerPSP>
         <idChannel>70000000001_01</idChannel>
         <password>pwdpwdpwd</password>
         <qrCode>
         <fiscalCode>#creditor_institution_code#</fiscalCode>
         <noticeNumber>002$iuv</noticeNumber>
         </qrCode>
         </nod:verifyPaymentNoticeReq>
         </soapenv:Body>
         </soapenv:Envelope>
         """
      When PSP sends SOAP verifyPaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of verifyPaymentNotice response

   Scenario: activatePaymentNotice
      Given initial XML activatePaymentNotice
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:activatePaymentNoticeReq>
         <idPSP>70000000001</idPSP>
         <idBrokerPSP>70000000001</idBrokerPSP>
         <idChannel>70000000001_01</idChannel>
         <password>pwdpwdpwd</password>
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

   Scenario: sendPaymentOutcomeV2
      Given the scenario executed successfully
      And initial XML sendPaymentOutcomeV2
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:nod="http://pagopa-api.pagopa.gov.it/node/nodeForPsp.xsd">
         <soapenv:Header/>
         <soapenv:Body>
         <nod:sendPaymentOutcomeV2Request>
         <idPSP>70000000001</idPSP>
         <idBrokerPSP>70000000001</idBrokerPSP>
         <idChannel>70000000001_01</idChannel>
         <password>pwdpwdpwd</password>
         <idempotencyKey>#idempotency_key2#</idempotencyKey>
         <paymentTokens>
         <paymentToken>$activatePaymentNoticeResponse.paymentToken</paymentToken>
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

   Scenario: nodoInviaRPT
      Given initial XML nodoInviaRPT
         """
         <soapenv:Envelope xmlns:soapenv="http://schemas.xmlsoap.org/soap/envelope/" xmlns:ppt="http://ws.pagamenti.telematici.gov/ppthead" xmlns:ws="http://ws.pagamenti.telematici.gov/">
         <soapenv:Header>
         <ppt:intestazionePPT>
         <identificativoIntermediarioPA>77777777777</identificativoIntermediarioPA>
         <identificativoStazioneIntermediarioPA>77777777777_05</identificativoStazioneIntermediarioPA>
         <identificativoDominio>#creditor_institution_code#</identificativoDominio>
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

   # REV_SPO_03

   Scenario: REV_SPO_03 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: REV_SPO_03 (part 2)
      Given the REV_SPO_03 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: REV_SPO_03 (part 3)
      Given the REV_SPO_03 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: REV_SPO_03 (part 4)
      Given the REV_SPO_03 (part 3) scenario executed successfully
      When job paInviaRT triggered after 0 seconds
      Then checks the value PAYING,PAYING_RPT,PAID,NOTICE_GENERATED,NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,PAID,NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NOTICE_STORED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value PAYER of the record at column SUBJECT_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.entityUniqueIdentifierType of the record at column ENTITY_UNIQUE_IDENTIFIER_TYPE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fullName of the record at column FULL_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.streetName of the record at column STREET_NAME of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.civicNumber of the record at column CIVIC_NUMBER of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.postalCode of the record at column POSTAL_CODE of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.city of the record at column CITY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.stateProvinceRegion of the record at column STATE_PROVINCE_REGION of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.country of the record at column COUNTRY of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.e-mail of the record at column EMAIL of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_SUBJECT retrived by the query position_subject on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777 of the record at column BROKER_PA of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777_05 of the record at column STATION_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 1 of the record at column STATION_VERSION of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idBrokerPSP of the record at column BROKER_PSP_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.idempotencyKey of the record at column IDEMPOTENCY_KEY of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.amount of the record at column AMOUNT of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column PAYMENT_CHANNEL of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYER_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_PAYMENT_PLAN of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column RPT_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYMENT_TYPE of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column CARRELLO_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ORIGINAL_PAYMENT_TOKEN of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FLAG_IO of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column RICEVUTA_PM of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column FLAG_ACTIVATE_RESP_MISSING of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FLAG_PAYPAL of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column TRANSACTION_ID of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column CLOSE_PAYMENT of the table POSITION_PAYMENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column RECEIPT_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.outcome of the record at column OUTCOME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.amount of the record at column AMOUNT of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value pagamento multibeneficiario of the record at column DESCRIPTION of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PA Salvo of the record at column COMPANY_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column OFFICE_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DEBTOR_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idPSP of the record at column PSP_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_FISCAL_CODE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_VAT_NUMBER of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PSP_COMPANY_NAME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.idChannel of the record at column CHANNEL_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentChannel of the record at column CHANNEL_DESCRIPTION of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYER_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentMethod of the record at column PAYMENT_METHOD of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.fee of the record at column FEE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column PAYMENT_DATE_TIME of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.applicationDate of the record at column APPLICATION_DATE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.transferDate of the record at column TRANSFER_DATE of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column METADATA of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column RT_ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_POSITION_PAYMENT of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $iuv of the record at column CREDITOR_REFERENCE_ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column PAYMENT_TOKEN of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_POSITION_RECEIPT of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.fiscalCode of the record at column RECIPIENT_PA_FISCAL_CODE of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777 of the record at column RECIPIENT_BROKER_PA of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value 77777777777_05 of the record at column RECIPIENT_STATION_ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_BY of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value sendPaymentOutcomeV2 of the record at column UPDATED_BY of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_OK,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATUS of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value 0 of the record at column COD_ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1

   # REV_SPO_05

   Scenario: REV_SPO_05 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: REV_SPO_05 (part 2)
      Given the REV_SPO_05 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: REV_SPO_05 (part 3)
      Given the REV_SPO_05 (part 2) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And outcome with KO in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: REV_SPO_05 (part 4)
      Given the REV_SPO_05 (part 3) scenario executed successfully
      When job paInviaRT triggered after 0 seconds
      And checks the value PAYING,PAYING_RPT,FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value FAILED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_RISOLTA_KO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATUS of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1

   # REV_SPO_06

   Scenario: REV_SPO_06 (part 1)
      Given the activatePaymentNotice scenario executed successfully
      And expirationTime with 2000 in activatePaymentNotice
      When PSP sends SOAP activatePaymentNotice to nodo-dei-pagamenti
      Then check outcome is OK of activatePaymentNotice response
      And save activatePaymentNotice response in activatePaymentNoticeResponse

   Scenario: REV_SPO_06 (part 2)
      Given the REV_SPO_06 (part 1) scenario executed successfully
      And the nodoInviaRPT scenario executed successfully
      When PSP sends SOAP nodoInviaRPT to nodo-dei-pagamenti
      Then check outcome is OK of nodoInviaRPT response

   Scenario: REV_SPO_06 (part 3)
      Given the REV_SPO_06 (part 2) scenario executed successfully
      When job mod3CancelV1 triggered after 3 seconds
      Then wait 10 seconds for expiration

   Scenario: REV_SPO_06 (part 4)
      Given the REV_SPO_06 (part 3) scenario executed successfully
      And the sendPaymentOutcomeV2 scenario executed successfully
      And outcome with KO in sendPaymentOutcomeV2
      When PSP sends SOAP sendPaymentOutcomeV2 to nodo-dei-pagamenti
      Then check outcome is OK of sendPaymentOutcomeV2 response

   Scenario: REV_SPO_06 (part 5)
      Given the REV_SPO_06 (part 4) scenario executed successfully
      When job paInviaRT triggered after 0 seconds
      Then checks the value PAYING,PAYING_RPT,CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value CANCELLED of the record at column STATUS of the table POSITION_PAYMENT_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value PAYING,INSERTED of the record at column STATUS of the table POSITION_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value INSERTED of the record at column STATUS of the table POSITION_STATUS_SNAPSHOT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT_XML retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT_RECIPIENT retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value None of the record at column ID of the table POSITION_RECEIPT_RECIPIENT_STATUS retrived by the query noticeid_pa on db nodo_online under macro NewMod1
      And checks the value RPT_RICEVUTA_NODO,RPT_ACCETTATA_NODO,RPT_PARCHEGGIATA_NODO_MOD3,RPT_ANNULLATA_NODO,RT_GENERATA_NODO,RT_INVIATA_PA,RT_ACCETTATA_PA of the record at column STATUS of the table STATI_RPT retrived by the query iuv_iddominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value 1 of the record at column COD_ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NON_ESEGUITO of the record at column ESITO of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column DATA_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICEVUTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_RICHIESTA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $activatePaymentNotice.amount of the record at column SOMMA_VERSAMENTI of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $nodoInviaRPT.identificativoCanale of the record at column CANALE of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value N of the record at column NOTIFICA_PROCESSATA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NMP of the record at column GENERATA_DA of the table RT retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone,None of the record at column ID of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value $sendPaymentOutcomeV2.paymentToken of the record at column CCP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column FK_RT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column TIPO_FIRMA of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column XML_CONTENT of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column INSERTED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column UPDATED_TIMESTAMP of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1
      And checks the value NotNone of the record at column ID_SESSIONE of the table RT_XML retrived by the query iuv_identdominio on db nodo_online under macro NewMod1

# da aggiungere in query_AutomationTest.json
# "NewMod1" : {"noticeid_pa": "SELECT columns FROM table_name WHERE NOTICE_ID = '002$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "iuv_identdominio": "SELECT columns FROM table_name WHERE IUV = '$iuv' and IDENT_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "iuv_iddominio": "SELECT columns FROM table_name WHERE IUV = '$iuv' and ID_DOMINIO = '#creditor_institution_code#' ORDER BY ID ASC",
#              "position_subject": "SELECT columns FROM table_name WHERE ENTITY_UNIQUE_IDENTIFIER_VALUE = '$sendPaymentOutcomeV2.entityUniqueIdentifierValue' and INSERTED_TIMESTAMP > TO_DATE ('$date','YYYY-MM-DD HH24:MI:SS')"}